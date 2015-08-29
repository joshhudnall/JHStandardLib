//
//  UICollectionView+JHExtras.m
//  Air1
//
//  Created by Josh Hudnall on 8/27/14.
//
//

#import "UICollectionView+JHExtras.h"

@implementation UICollectionView (JHExtras)

- (NSIndexPath *)jh_indexPathForItemContainingView:(UIView *)view {
    UIView *superview = view;
    while (superview) {
        if ([superview isKindOfClass:[UICollectionViewCell class]]) {
            break;
        }
        superview = superview.superview;
    }
    if (superview) {
        return [self indexPathForCell:(UICollectionViewCell *)superview];
    } else {
        return nil;
    }
}

@end
