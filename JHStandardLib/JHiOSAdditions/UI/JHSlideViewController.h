//
//  JHSlideViewController.h
//  TheLifeYouWantTour
//
//  Created by Josh Hudnall on 3/21/14.
//  Copyright (c) 2014 fastPXL. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Posted before the menu is opened
 */
extern NSString *const JHSlideViewControllerWillOpenNotification;

/**
 *  Posted after the menu is opened
 */
extern NSString *const JHSlideViewControllerDidOpenNotification;

/**
 *  Posted before the menu is closed
 */
extern NSString *const JHSlideViewControllerWillCloseNotification;

/**
 *  Posted after the menu is closed
 */
extern NSString *const JHSlideViewControllerDidCloseNotification;

/**
 *  Posted when switchToViewController:withCompletion: is called regardless of if an actual switch will occur
 */
extern NSString *const JHSlideViewControllerWasAskedToSwitchViewControllerNotification;

/**
 *  Posted before the view controller is switched
 */
extern NSString *const JHSlideViewControllerWillSwitchViewControllerNotification;

/**
 *  Posted after the view controller is switched
 */
extern NSString *const JHSlideViewControllerDidSwitchViewControllerNotification;

typedef NS_ENUM(NSInteger, JHViewControllerReuseMode) {
    /**
     *  Switch to a view controllers regardless of if the current view controller is the same class or instance
     */
    JHViewControllerReuseModeNone,
    
    /**
     *  Only switch to a view controller if it is not a member of the same class as the current view controller
     */
    JHViewControllerReuseModeSameClass,
    
    /**
     *  Only switch to a view controller if it is not already the current view controller
     */
    JHViewControllerReuseModeSameInstance,
};

typedef NS_ENUM (NSInteger, JHSlideViewControllerLandscapeMode) {
    /**
     *  In this mode, the menu behaves normally regardless of orientation on iPad
     */
    JHSlideViewControllerLandscapeModeNormal,
    
    /**
     *  In this mode, the menu is always visible in landscape mode on iPad
     */
    JHSlideViewControllerLandscapeModeAlwaysOpen,
};

@protocol JHSlideViewMenuDelegate;

@interface JHSlideViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, assign) JHSlideViewControllerLandscapeMode landscapeMode;
@property (nonatomic, assign) JHViewControllerReuseMode reuseMode;
@property (nonatomic, assign, getter = isMenuOpen) BOOL menuOpen;
@property (nonatomic, readonly) UIView *overlayView;
@property (nonatomic, readonly) UINavigationController *navController;
@property (nonatomic, strong) UIViewController <JHSlideViewMenuDelegate> *menuViewController;

+ (JHSlideViewController *)defaultController;

- (id)initWithMenuViewController:(UIViewController <JHSlideViewMenuDelegate> *)menuViewController;
- (id)initWithRootViewController:(UIViewController *)rootViewController andMenuViewController:(UIViewController <JHSlideViewMenuDelegate> *)menuViewController;

- (void)switchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;
- (void)openMenuWithCompletion:(void (^)())completion;
- (void)closeMenuWithCompletion:(void (^)())completion;
- (void)toggleMenu;

@end


#pragma mark - JHSlideViewMenuDelegate

@protocol JHSlideViewMenuDelegate <NSObject>

- (NSInteger)numberOfMenuItems;
- (void)selectMenuItemAtIndex:(NSInteger)index;
- (void)slideViewDidCloseMenu:(JHSlideViewController *)slideView;

@end



#pragma mark - UIViewController (JHSlideViewController)

@interface UIViewController (JHSlideViewController)

@property (nonatomic, weak) JHSlideViewController *slideViewController;
@property (nonatomic, assign) BOOL shouldShareSlideGestureRecognizer;

@end