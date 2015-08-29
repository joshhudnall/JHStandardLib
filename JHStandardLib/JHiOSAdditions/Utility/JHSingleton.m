//
//  Singleton.m
//  GetStarted
//
//  Created by Josh Hudnall on 4/23/14.
//
//

#import "JHSingleton.h"

// This class is designed to be subclassed, this dict holds references to each shared instance
static NSMutableDictionary *_sharedInstances = nil;

@implementation JHSingleton

+ (void)initialize {
	if (_sharedInstances == nil) {
		_sharedInstances = [NSMutableDictionary dictionary];
	}
}

+ (instancetype)sharedInstance {
	id sharedInstance = nil;
    
	@synchronized(self) {
		NSString *instanceClass = NSStringFromClass(self);
        
		sharedInstance = [_sharedInstances objectForKey:instanceClass];
		if (sharedInstance == nil) {
			sharedInstance = [[self alloc] init];
			[_sharedInstances setObject:sharedInstance forKey:instanceClass];
		}
	}
    
	return sharedInstance;
}

#ifdef kForceSingleton
- (id)allocWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (id)init {
    return [[self class] sharedInstance];
}
#endif

@end
