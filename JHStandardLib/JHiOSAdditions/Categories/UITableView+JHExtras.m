//
//  UITableView+JHExtras.m
//  CellSubviewLocation
//
//  Created by Matt Drance on 9/9/10.
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//

#import "UITableView+JHExtras.h"
#import <UIKit/UIKit.h>

@implementation UITableView (JHExtras)

- (NSIndexPath *)jh_indexPathForRowContainingView:(UIView *)view {
    UIView *superview = view;
    while (superview) {
        if ([superview isKindOfClass:[UITableViewCell class]]) {
            break;
        }
        superview = superview.superview;
    }
    if (superview) {
        return [self indexPathForCell:(UITableViewCell *)superview];
    } else {
        return nil;
    }
}

@end
