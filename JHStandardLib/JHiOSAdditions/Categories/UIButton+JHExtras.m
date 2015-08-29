//
//  UIButton.m
//  Air1
//
//  Created by Josh Hudnall on 3/10/15.
//
//

#import "UIButton+JHExtras.h"

@implementation UIButton (JHExtras)

- (void)jh_removeAllTargets {
    [self removeTarget:nil
                action:NULL
      forControlEvents:UIControlEventAllEvents];
}

@end
