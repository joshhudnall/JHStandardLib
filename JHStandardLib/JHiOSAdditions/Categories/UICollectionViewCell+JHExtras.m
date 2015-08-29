//
//  UICollectionViewCell+JHExtras.m
//  GetStarted
//
//  Created by Josh Hudnall on 8/4/14.
//
//

#import "UICollectionViewCell+JHExtras.h"

@implementation UICollectionViewCell (JHExtras)

+ (NSString *)jh_defaultCellIdentifier {
    return NSStringFromClass(self);
}

@end
