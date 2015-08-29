//
//  NSMutableArray+JHExtras.h
//  Connoshoer
//
//  Created by Josh Hudnall on 1/1/13.
//  Copyright (c) 2013 Connoshoer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^JHComparator)(id array, id obj);

@interface NSMutableArray (JHExtras)

/**
 *  Adds objects from one array to the receiver array, but skips any objects that are already in the array.
 *
 *  @param array      The array to pull unique objects from
 *  @param comparator Block that provides the receiver array as well as the object it wants to add. Return YES if it is unique.
 */
- (void)jh_addUniqueObjectsFromArray:(NSArray *)array usingComparator:(JHComparator)comparator;

@end
