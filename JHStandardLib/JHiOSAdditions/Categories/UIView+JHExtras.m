//
//  UIView+JHExtras.m
//  Air1
//
//  Created by Josh Hudnall on 8/25/14.
//
//

#import "UIView+JHExtras.h"

@implementation UIView (JHExtras)

- (UIViewController *)jh_viewController {
    // Take the view controller class object here and avoid sending the same message iteratively unnecessarily.
    Class vcc = [UIViewController class];
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: vcc])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

@end
