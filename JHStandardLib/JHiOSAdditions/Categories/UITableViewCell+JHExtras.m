//
//  UITableViewCell+JHExtras.m
//  GetStarted
//
//  Created by Josh Hudnall on 8/4/14.
//
//

#import "UITableViewCell+JHExtras.h"

@implementation UITableViewCell (JHExtras)

+ (NSString *)jh_defaultCellIdentifier {
    return NSStringFromClass(self);
}

@end
