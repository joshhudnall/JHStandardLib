//
//  Singleton.h
//  GetStarted
//
//  Created by Josh Hudnall on 4/23/14.
//
//

/*
 * Force allocWithZone: and init to return the singleton instance. This should only be used in extreme circumstances
 * and use indicates that you're probably doing something wrong. Being able to create a fresh instance of a given class
 * is key to test-driven development.
 */
//#define kForceSingleton

#import <Foundation/Foundation.h>

@interface JHSingleton : NSObject

+ (instancetype)sharedInstance;

@end
