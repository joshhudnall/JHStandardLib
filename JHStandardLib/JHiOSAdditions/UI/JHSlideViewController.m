//
//  JHSlideViewController.m
//  TheLifeYouWantTour
//
//  Created by Josh Hudnall on 3/21/14.
//  Copyright (c) 2014 fastPXL. All rights reserved.
//

#ifndef IS_IPAD
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#endif
#ifndef IS_IOS_7
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#endif

#import <objc/runtime.h>

#import "JHSlideViewController.h"

NSString *const JHSlideViewControllerWillOpenNotification = @"JHSlideViewControllerWillOpenNotification";
NSString *const JHSlideViewControllerDidOpenNotification = @"JHSlideViewControllerDidOpenNotification";
NSString *const JHSlideViewControllerWillCloseNotification = @"JHSlideViewControllerWillCloseNotification";
NSString *const JHSlideViewControllerDidCloseNotification = @"JHSlideViewControllerDidCloseNotification";
NSString *const JHSlideViewControllerWasAskedToSwitchViewControllerNotification = @"JHSlideViewControllerWasAskedToSwitchViewControllerNotification";
NSString *const JHSlideViewControllerWillSwitchViewControllerNotification = @"JHSlideViewControllerWillSwitchViewControllerNotification";
NSString *const JHSlideViewControllerDidSwitchViewControllerNotification = @"JHSlideViewControllerDidSwitchViewControllerNotification";

@interface JHSlideViewController () <UIGestureRecognizerDelegate> {
    BOOL _hasSetStaticConstraints;
}

@property (nonatomic, strong) NSArray *_navConstraints;
@property (nonatomic, strong) NSArray *_menuConstraints;
@property (nonatomic, strong) UITapGestureRecognizer *_tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *_panRecognizer;
@property (nonatomic, assign) CGPoint _draggingPoint;
@property (nonatomic, assign) CGFloat _slideOffset;
@property (nonatomic, assign) CGFloat _openWidth;
@property (nonatomic, strong) UIButton *_menuButton;

@end

@implementation JHSlideViewController
@synthesize menuViewController = _menuViewController;
@synthesize navController = _navController;
@synthesize _openWidth;

static JHSlideViewController *_defaultController;

- (id)init {
	if (self = [super init]) {
		[self setup];
	}
    
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self setup];
	}
    
	return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController andMenuViewController:(UIViewController <JHSlideViewMenuDelegate> *)menuViewController {
    NSAssert(rootViewController != nil, @"You cannot pass nil as rootViewController");
    NSAssert(menuViewController != nil, @"You cannot pass nil as menuViewController");
    
	if (self = [super init]) {
		[self setup];
        
		[self switchToViewController:rootViewController withCompletion:nil];
        [self setMenuViewController:menuViewController];
	}
    
	return self;
}

- (id)initWithMenuViewController:(UIViewController <JHSlideViewMenuDelegate> *)menuViewController {
    NSAssert(menuViewController != nil, @"You cannot pass nil as menuViewController");
    
	if (self = [super init]) {
		[self setup];
        
        [self setMenuViewController:menuViewController];
        if (self.menuViewController.numberOfMenuItems) {
            [self.menuViewController selectMenuItemAtIndex:0];
        }
	}
    
	return self;
}

+ (JHSlideViewController *)defaultController {
    if ( ! _defaultController) {
        _defaultController = [[self alloc] init];
    }
    
    return _defaultController;
}

- (void)setup {
    self.view.backgroundColor = [UIColor blackColor];
    
    _landscapeMode = JHSlideViewControllerLandscapeModeNormal;
    _reuseMode = JHViewControllerReuseModeSameInstance;
    
	_navController = [[UINavigationController alloc] init];
	_navController.delegate = self;
	_navController.view.clipsToBounds = YES;
    _navController.view.backgroundColor = [UIColor whiteColor];
    _navController.navigationBar.translucent = NO;
    [_navController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
	self._openWidth = (IS_IPAD && _landscapeMode == JHSlideViewControllerLandscapeModeAlwaysOpen) ? 320 : ( ! IS_IPAD) ? 272 : 275;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= 70000
	if ( ! IS_IOS_7) {
		self.wantsFullScreenLayout = YES;
	}
#endif
    
    if (_landscapeMode == JHSlideViewControllerLandscapeModeNormal || ! IS_IPAD || ! UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        [self.view addGestureRecognizer:self._panRecognizer];
    }
    
	[self addChildViewController:_navController];
	[self.view addSubview:_navController.view];
	[_navController didMoveToParentViewController:self];
    
    _overlayView = [[UIView alloc] initWithFrame:_navController.view.frame];
    _overlayView.userInteractionEnabled = NO;
    //[self.view addSubview:_overlayView];
    
    if ( ! _defaultController) {
        _defaultController = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    UIView *navView = _navController.view;
    UIView *menuView = _menuViewController.view;
	NSDictionary *viewsDict = NSDictionaryOfVariableBindings(navView, menuView);
	NSString *visualFormat;
    
    // DYNAMIC CONSTRAINTS - These can change in certain circumstances
    
    // Navigation Controller
    if (self._navConstraints) {
        [self.view removeConstraints:self._navConstraints];
    }
    
    if (IS_IPAD && UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && _landscapeMode == JHSlideViewControllerLandscapeModeAlwaysOpen) {
        visualFormat = [NSString stringWithFormat:@"[navView(768)]|"];
        self._navConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDict];
    } else {
        visualFormat = [NSString stringWithFormat:@"|[navView]|"];
        self._navConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDict];
    }
    [self.view addConstraints:self._navConstraints];
    
    // Menu Controller
    if (self._menuConstraints) {
        [self.view removeConstraints:self._menuConstraints];
    }
    
    if (IS_IPAD && UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && _landscapeMode == JHSlideViewControllerLandscapeModeAlwaysOpen) {
        CGFloat wideSide = (self.view.frame.size.width > self.view.frame.size.height) ? self.view.frame.size.width : self.view.frame.size.height;
        visualFormat = [NSString stringWithFormat:@"|[menuView(%f)]", wideSide - 768];
        self._menuConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDict];
    } else {
        visualFormat = [NSString stringWithFormat:@"|[menuView(%f)]", _openWidth];
        self._menuConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDict];
    }
    [self.view addConstraints:self._menuConstraints];
    
    
    // STATIC CONSTRAINTS - These don't change once set
    
    if ( ! _hasSetStaticConstraints) {
        NSArray *constraints;
        visualFormat = [NSString stringWithFormat:@"V:|[navView]|"];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                              options:0
                                                              metrics:nil
                                                                views:viewsDict];
        [self.view addConstraints:constraints];
        
        visualFormat = [NSString stringWithFormat:@"V:|[menuView]|"];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                              options:0
                                                              metrics:nil
                                                                views:viewsDict];
        [self.view addConstraints:constraints];
        
        _hasSetStaticConstraints = YES;
    }

	[super updateViewConstraints];
}

- (void)set_openWidth:(CGFloat)openWidth {
    _openWidth = openWidth;
    
	self._slideOffset = self.view.frame.size.width - self._openWidth;
}

- (void)setMenuViewController:(UIViewController <JHSlideViewMenuDelegate> *)menuViewController {
	// Remove self from an outgoing _menuViewController
	if (_menuViewController) {
		[_menuViewController willMoveToParentViewController:nil];
		_menuViewController.slideViewController = nil;
		[_menuViewController.view removeFromSuperview];
		[_menuViewController removeFromParentViewController];
	}
    
	// Set the property
	_menuViewController = menuViewController;
    [_menuViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
	if (menuViewController) {
		// Add self to an incoming _menuViewController
		menuViewController.slideViewController = self;
        
		[self addChildViewController:_menuViewController];
		[self.view insertSubview:_menuViewController.view atIndex:0];
		[_menuViewController didMoveToParentViewController:self];
	}
}

- (void)switchToViewController:(UIViewController *)viewController withCompletion:(void (^)() )completion {
    [[NSNotificationCenter defaultCenter] postNotificationName:JHSlideViewControllerWasAskedToSwitchViewControllerNotification
                                                        object:self
                                                      userInfo:nil];
    BOOL shouldSwitch = YES;
    switch (_reuseMode) {
        case JHViewControllerReuseModeSameClass:
            if ([[_navController.viewControllers firstObject] isMemberOfClass:[viewController class]]) {
                shouldSwitch = NO;
            }
            break;
        case JHViewControllerReuseModeSameInstance:
            if (viewController && viewController == [_navController.viewControllers firstObject]) {
                shouldSwitch = NO;
            }
            break;
            
        default:
            break;
    }
    
	if (shouldSwitch) {
        [[NSNotificationCenter defaultCenter] postNotificationName:JHSlideViewControllerWillSwitchViewControllerNotification
                                                            object:self
                                                          userInfo:nil];

        _navController.toolbarHidden = YES; // Some view controllers don't properly hide this when disappearing
        //_navController.navigationBarHidden = NO; // Some view controllers may override this, but if not we want to default to NO
        
        viewController.navigationItem.leftBarButtonItem = [self menuButton];
        viewController.slideViewController = self;
        
        [_navController setViewControllers:@[viewController]];
        
		if ([self isMenuOpen]) {
            [self closeMenuWithCompletion:completion];
		} else {
			if (completion) {
				completion();
			}
		}
        
        [[NSNotificationCenter defaultCenter] postNotificationName:JHSlideViewControllerDidSwitchViewControllerNotification
                                                            object:self
                                                          userInfo:nil];
	} else {
        [self closeMenuWithCompletion:completion];
    }
}

- (UIBarButtonItem *)menuButton {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && _landscapeMode == JHSlideViewControllerLandscapeModeAlwaysOpen) {
        return nil;
    }
    
    if ( ! self._menuButton) {
        self._menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self._menuButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    [self setMenuButtonImage];
    
	return [[UIBarButtonItem alloc] initWithCustomView:self._menuButton];
}

- (void)setMenuButtonImage {
    UIImage *buttonImage;
    if (self.isMenuOpen) {
        buttonImage = [UIImage imageNamed:@"menu-button"];
    } else {
        buttonImage = [UIImage imageNamed:@"menu-button"];
    }
    
	[self._menuButton setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
	[self._menuButton setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateHighlighted];
	[self._menuButton setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateSelected];
	[self._menuButton setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateHighlighted | UIControlStateSelected];
	
    CGRect frame = self._menuButton.frame;
	frame.size = [UIImage imageNamed:@"menu-button"].size;
	self._menuButton.frame = frame;
}

- (void)openMenuWithCompletion:(void (^)() )completion {
	[self openMenuWithDuration:0.2f andCompletion:completion];
}

- (void)openMenuWithDuration:(CGFloat)duration andCompletion:(void (^)() )completion {
    [[NSNotificationCenter defaultCenter] postNotificationName:JHSlideViewControllerWillOpenNotification
                                                        object:self
                                                      userInfo:nil];

    __block CGRect menuFrame = _menuViewController.view.frame;
    if (_menuViewController.view.frame.origin.x == 0) {
        menuFrame.origin.x = -50;
        _menuViewController.view.frame = menuFrame;
    }
	
    [UIView animateWithDuration:duration
                     animations:^{
                         CGRect navFrame = _navController.view.frame;
                         navFrame.origin.x = [self maxXForDragging];
                         _navController.view.frame = navFrame;
                         _overlayView.frame = navFrame;
                         
                         menuFrame.origin.x = 0;
                         _menuViewController.view.frame = menuFrame;
                     } completion:^(BOOL finished) {
                         [self setMenuButtonImage];
                         _navController.visibleViewController.view.userInteractionEnabled = NO;
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:JHSlideViewControllerDidOpenNotification
                                                                             object:self
                                                                           userInfo:nil];

                         if (completion) {
                             completion();
                         }
                     }];
	[_navController.view addGestureRecognizer:self._tapRecognizer];
}

- (void)closeMenuWithCompletion:(void (^)() )completion {
	[self closeMenuWithDuration:0.2f andCompletion:completion];
}

- (void)closeMenuWithDuration:(CGFloat)duration andCompletion:(void (^)() )completion {
    [[NSNotificationCenter defaultCenter] postNotificationName:JHSlideViewControllerWillCloseNotification
                                                        object:self
                                                      userInfo:nil];
    
	[UIView animateWithDuration:duration
                     animations:^{
                         CGRect frame = _navController.view.frame;
                         frame.origin.x = 0;
                         _navController.view.frame = frame;
                         _overlayView.frame = frame;
                         _menuViewController.view.x = -50;
                     } completion:^(BOOL finished) {
                         [self setMenuButtonImage];
                         _navController.visibleViewController.view.userInteractionEnabled = YES;
                         if ([_menuViewController respondsToSelector:@selector(slideViewDidCloseMenu:)]) {
                             [_menuViewController slideViewDidCloseMenu:self];
                         }
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:JHSlideViewControllerDidCloseNotification
                                                                             object:self
                                                                           userInfo:nil];
                         
                         if (completion) {
                             completion();
                         }
                     }];
	[_navController.view removeGestureRecognizer:self._tapRecognizer];
}

- (void)toggleMenu {
	[self toggleMenuWithCompletion:nil];
}

- (void)toggleMenuWithCompletion:(void (^)() )completion {
	if (IS_IPAD && UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && _landscapeMode == JHSlideViewControllerLandscapeModeAlwaysOpen) {
		if (completion) {
			completion();
			return;
		}
	}
    
	if (self.isMenuOpen) {
		[self closeMenuWithCompletion:completion];
	} else {
		[self openMenuWithCompletion:completion];
	}
}

- (BOOL)isMenuOpen {
	if (IS_IPAD && UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && _landscapeMode == JHSlideViewControllerLandscapeModeAlwaysOpen) {
		return NO;
	}
    
	return _navController.view.frame.origin.x > 0;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (IS_IPAD) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return IS_IPAD;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && _landscapeMode == JHSlideViewControllerLandscapeModeAlwaysOpen) {
		[self.view removeGestureRecognizer:self._panRecognizer];
	} else if ( ! [self.view.gestureRecognizers containsObject:self._panRecognizer]) {
		[self.view addGestureRecognizer:self._panRecognizer];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
	if (IS_IPAD) {
		self._slideOffset = self.view.frame.size.width - self._openWidth;
		[self.view setNeedsLayout];
        [(UIViewController *)[_navController.viewControllers objectAtIndex:0] navigationItem].leftBarButtonItem = [self menuButton];
	}
}


#pragma mark - Gesture Recognizing -

- (UITapGestureRecognizer *)_tapRecognizer {
	if (! __tapRecognizer) {
		__tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
	}
    
	return __tapRecognizer;
}

- (UIPanGestureRecognizer *)_panRecognizer {
	if (! __panRecognizer) {
		__panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        __panRecognizer.delegate = self;
	}
    
	return __panRecognizer;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [_navController.visibleViewController shouldShareSlideGestureRecognizer];
}

- (void)tapDetected:(UITapGestureRecognizer *)_tapRecognizer {
	[self closeMenuWithCompletion:nil];
}

- (void)panDetected:(UIPanGestureRecognizer *)a_panRecognizer {
	CGPoint translation = [a_panRecognizer translationInView:a_panRecognizer.view];
	CGPoint velocity = [a_panRecognizer velocityInView:a_panRecognizer.view];
	NSInteger movement = translation.x - self._draggingPoint.x;
    
	if (a_panRecognizer.state == UIGestureRecognizerStateBegan) {
		self._draggingPoint = translation;
	} else if (a_panRecognizer.state == UIGestureRecognizerStateChanged) {
		static CGFloat lastHorizontalLocation = 0;
		CGFloat newHorizontalLocation = [self horizontalLocation];
        
		lastHorizontalLocation = newHorizontalLocation;
        
		newHorizontalLocation += movement;
        
		if (newHorizontalLocation >= self.minXForDragging && newHorizontalLocation <= self.maxXForDragging) {
			[self moveHorizontallyToLocation:newHorizontalLocation];
		}
        
		self._draggingPoint = translation;
	} else if (a_panRecognizer.state == UIGestureRecognizerStateEnded) {
		NSInteger currentX = [self horizontalLocation];
		NSInteger currentXOffset = abs(currentX);
		NSInteger positiveVelocity = abs(velocity.x);
        
		// If the speed is high enough follow direction
		if (velocity.x > 0 && positiveVelocity >= 800) {
			[self openMenuWithDuration:0.2 andCompletion:nil];
		} else if (velocity.x <= 0 && positiveVelocity >= 300) {
			[self closeMenuWithDuration:0.13 andCompletion:nil];
		} else {
			if (currentXOffset < (self.horizontalSize - self._slideOffset) / 2) {
				[self closeMenuWithCompletion:nil];
			} else if (currentXOffset < self._openWidth) {
				[self openMenuWithCompletion:nil];
			}
		}
	}
}

- (void)moveHorizontallyToLocation:(CGFloat)location {
	CGRect rect = _navController.view.frame;
	rect.origin.x = location;
	_navController.view.frame = rect;
    _overlayView.frame = rect;
    
    // x = C + (y - A) * (D - C) / (B - A)  ::  A - B (range 1) normalized to C - D (range 2)
    CGFloat a = 0; CGFloat b = self._openWidth;
    CGFloat c = -50; CGFloat d = 0;
    CGFloat newX = c + (location - a) * (d - c) / (b - a);
	
    rect = _menuViewController.view.frame;
	rect.origin.x = fminf(0, newX);
	_menuViewController.view.frame = rect;
}

- (CGFloat)horizontalLocation {
	return _navController.view.frame.origin.x;
}

- (CGFloat)horizontalSize {
	CGRect rect = _navController.view.frame;
	UIInterfaceOrientation orientation = self.interfaceOrientation;
    
	if (UIInterfaceOrientationIsLandscape(orientation) ) {
        return (IS_IOS_8) ? rect.size.width : rect.size.height;
	} else {
		return rect.size.width;
	}
}

- (NSInteger)minXForDragging {
	return 0;
}

- (NSInteger)maxXForDragging {
	return self.horizontalSize - self._slideOffset;
}


#pragma mark - Helpers

- (NSString *)nameOfInterfaceOrientation:(UIInterfaceOrientation)theOrientation {
	NSString *orientationName = nil;
	switch (theOrientation) {
        case UIInterfaceOrientationPortrait:
            orientationName = @"Portrait";     // Home button at bottom
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            orientationName = @"Portrait (Upside Down)";     // Home button at top
            break;
        case UIInterfaceOrientationLandscapeLeft:
            orientationName = @"Landscape (Left)";     // Home button on left
            break;
        case UIInterfaceOrientationLandscapeRight:
            orientationName = @"Landscape (Right)";     // Home button on right
            break;
        default:
            break;
	}
    
	return orientationName;
}

@end


#pragma mark - UIViewController (JHSlideViewController)

@implementation UIViewController (JHSlideViewController)

static void *const kJHSlideViewControllerKey = (void *)&kJHSlideViewControllerKey;

- (void)setSlideViewController:(JHSlideViewController *)slideViewController {
	objc_setAssociatedObject(self, kJHSlideViewControllerKey, slideViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (JHSlideViewController *)slideViewController {
    JHSlideViewController *vc = objc_getAssociatedObject(self, kJHSlideViewControllerKey);
    
    // If self doesn't have a reference to the slide view controller, it could be because it is down the
    // stack. See if one can be found and return it.
    if ( ! vc && [self isKindOfClass:[JHSlideViewController class]]) {
        vc = (JHSlideViewController *)self;
    }
    if ( ! vc && self.navigationController.slideViewController) {
        vc = self.navigationController.slideViewController;
    }
    if ( ! vc && self.tabBarController.slideViewController) {
        vc = self.tabBarController.slideViewController;
    }
    if ( ! vc && self.parentViewController.slideViewController) {
        vc = self.parentViewController.slideViewController;
    }
    if ( ! vc && [self.parentViewController isKindOfClass:[JHSlideViewController class]]) {
        vc = (JHSlideViewController *)self.parentViewController;
    }
    
	return vc;
}

static void *const kJHShouldShareSlideGestureRecognizerKey = (void *)&kJHShouldShareSlideGestureRecognizerKey;
- (void)setShouldShareSlideGestureRecognizer:(BOOL)shouldShareSlideGestureRecognizer {
	objc_setAssociatedObject(self, kJHShouldShareSlideGestureRecognizerKey, [NSNumber numberWithBool:shouldShareSlideGestureRecognizer], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)shouldShareSlideGestureRecognizer {
    NSNumber *boolNum = objc_getAssociatedObject(self, kJHShouldShareSlideGestureRecognizerKey);
    
    return [boolNum boolValue];
}

@end