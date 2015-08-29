//
//  NSUserDefaults+JHExtras.h
//  Air1 Photo Booth
//
//  Created by Josh Hudnall on 5/18/14.
//  Copyright (c) 2014 Josh Hudnall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (JHExtras)

- (id)objectForKey:(NSString *)defaultName defaultValue:(id)defaultValue;
- (BOOL)boolForKey:(NSString *)defaultName defaultValue:(BOOL)defaultValue;
- (NSInteger)integerForKey:(NSString *)defaultName defaultValue:(NSInteger)defaultValue;
- (float)floatForKey:(NSString *)defaultName defaultValue:(float)defaultValue;
- (NSString *)stringForKey:(NSString *)defaultName defaultValue:(NSString *)defaultValue;
- (NSArray *)arrayForKey:(NSString *)defaultName defaultValue:(NSArray *)defaultValue;
- (NSDictionary *)dictionaryForKey:(NSString *)defaultName defaultValue:(NSDictionary *)defaultValue;
- (NSData *)dataForKey:(NSString *)defaultName defaultValue:(NSData *)defaultValue;
- (NSArray *)stringArrayForKey:(NSString *)defaultName defaultValue:(NSArray *)defaultValue;
- (double)doubleForKey:(NSString *)defaultName defaultValue:(double)defaultValue;
- (NSURL *)URLForKey:(NSString *)defaultName defaultValue:(NSURL *)defaultValue;

@end
