//
//  NSArray+JHExtras.m
//  Connoshoer
//
//  Created by Josh Hudnall on 1/1/13.
//  Copyright (c) 2013 Connoshoer. All rights reserved.
//

#import "NSMutableArray+JHExtras.h"

@implementation NSMutableArray (JHExtras)

- (void)jh_addUniqueObjectsFromArray:(NSArray *)array usingComparator:(JHComparator)comparator {
    for (id obj in array) {
        if ( ! comparator(self, obj)) {
            [self addObject:obj];
        }
    }
}

@end
