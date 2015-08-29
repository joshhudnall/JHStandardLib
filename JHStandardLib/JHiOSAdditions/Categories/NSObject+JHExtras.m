//
//  NSObject+JHExtras.m
//  Connoshoer
//
//  Created by Josh Hudnall on 1/3/13.
//  Copyright (c) 2013 Connoshoer. All rights reserved.
//

#import "NSObject+JHExtras.h"

@implementation NSObject (JHExtras)

- (void)jh_performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), block);
}


@end
