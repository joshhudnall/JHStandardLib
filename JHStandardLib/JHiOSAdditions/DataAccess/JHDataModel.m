//
//  JHDataModel.m
//  JHStandardLib
//
//  Created by Josh Hudnall on 7/27/15.
//  Copyright (c) 2015 Josh Hudnall. All rights reserved.
//

#import "JHDataModel.h"
#import "TMCache.h"
#import <objc/runtime.h>
#import <objc/Protocol.h>

#pragma mark NSString Utilities Declarations

@interface NSString (CaseConversion)

- (NSString *)camelCaseToSnakeCase;
- (NSString *)snakeCaseToCamelCase;

@end


#pragma mark - Implementation

@implementation JHDataModel
@dynamic keyMap;
@dynamic dataTransformers;

+ (NSArray *)objectsWithJSONArray:(NSArray *)jsonArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *jsonDict in jsonArray) {
        JHDataModel *object = [self objectWithJSONDictionary:jsonDict];
        if ([object isValid]) {
            [array addObject:object];
        }
    }
    return [array copy];
}

+ (instancetype)objectWithJSONDictionary:(NSDictionary *)jsonDictionary {
    return [[self alloc] initWithJSONDictionary:jsonDictionary];
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super init]) {
        [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            NSString *adjKey = nil;
            
            NSString *mappedKey = self.keyMap[key];
            if (mappedKey && [self propertyExists:mappedKey]) {
                // Then look for a mapping to use
                adjKey = mappedKey;
                
            } else if ([self propertyExists:[key snakeCaseToCamelCase]]) {
                // Then see if we have a default mapping in snake_case
                adjKey = [key snakeCaseToCamelCase];
            
            } else if ([self propertyExists:key]) {
                // Then see if we have a default mapping in camelCase
                adjKey = key;
            }
            
            if (adjKey) {
                // If there is a mapping, let's try to set the value as appropriate
                Class propertyClass = [self classOfProperty:adjKey];
                
                if (propertyClass == [NSString class]) {
                    [self setStringValue:value forKey:adjKey];
                } else if (propertyClass == [NSURL class]) {
                    [self setURLValue:value forKey:adjKey];
                } else if (propertyClass == [NSDate class]) {
                    [self setDateValue:value forKey:adjKey];
                } else if (propertyClass == [NSNumber class]) {
                    [self setNumberValue:value forKey:adjKey];
                } else if (propertyClass == [NSArray class]) {
                    [self setArrayValue:value forKey:adjKey];
                } else if (propertyClass == [NSDictionary class]) {
                    [self setDictionaryValue:value forKey:adjKey];
                } else if ([propertyClass isSubclassOfClass:[JHDataModel class]]) {
                    [self setModelObjectValue:value forKey:adjKey usingClass:propertyClass];
                }
            }
        }];
        
        _rawData = [jsonDictionary copy];
    }
    return self;
}

- (NSDictionary *)keyMap {
    return nil;
}

- (NSDictionary *)dataTransformers {
    return nil;
}

- (BOOL)isValid {
    return YES;
}


#pragma mark - Data-safe setters

- (void)setStringValue:(NSString *)value forKey:(NSString *)key {
    if (value && [value isKindOfClass:[NSString class]]) {
        [self setValue:value forKey:key];
    }
}

- (void)setURLValue:(NSString *)value forKey:(NSString *)key {
    if (value && [value isKindOfClass:[NSString class]]) {
        if ([value rangeOfString:@"//"].location == 0) {
            value = [NSString stringWithFormat:@"http:%@", value];
        } else if ([value rangeOfString:@"://"].location == NSNotFound) {
            value = [NSString stringWithFormat:@"http://%@", value];
        }
        
        NSURL *url = [NSURL URLWithString:value];
        
        [self setValue:url forKey:key];
    }
}

- (void)setNumberValue:(id)value forKey:(NSString *)key {
    if (value && [value isKindOfClass:[NSNumber class]]) {
        [self setValue:value forKey:key];
    } else if (value && [value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:value];
        
        [self setValue:myNumber forKey:key];
    }
}

- (void)setDateValue:(NSString *)value forKey:(NSString *)key {
    // Set up a date formatter
    static NSString *_defaultFormat = nil;
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultFormat = @"y'-'MM'-'dd HH':'mm':'ss"; // Default to MySQL format
        
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
        _dateFormatter.dateFormat = _defaultFormat;
    });
    
    if (value && [value isKindOfClass:[NSString class]]) {
        id transformer = self.dataTransformers[key];
        
        if (transformer && [transformer isKindOfClass:[NSValueTransformer class]]) {
            NSDate *date = [(NSValueTransformer *)transformer transformedValue:value];
            [self setValue:date forKey:key];
        } else {
            if (transformer && [transformer isKindOfClass:[NSString class]] && ! [_dateFormatter.dateFormat isEqualToString:(NSString *)transformer]) {
                // Use transformer if available
                _dateFormatter.dateFormat = (NSString *)transformer;
            } else if ( ! transformer && ! [_dateFormatter.dateFormat isEqualToString:_defaultFormat]) {
                // Otherwise use default
                _dateFormatter.dateFormat = _defaultFormat;
            }
            
            NSDate *date = [_dateFormatter dateFromString:value];
            
            [self setValue:date forKey:key];
        }
    }
}

- (void)setArrayValue:(NSArray *)value forKey:(NSString *)key {
    if (value && [value isKindOfClass:[NSArray class]]) {
        id transformer = self.dataTransformers[key];
        
        NSString *arrayType = [self protocolForNSArrayProperty:key];
        Class cls = NSClassFromString(arrayType);

        if (transformer && [transformer isKindOfClass:[NSValueTransformer class]]) {
            NSArray *array = [(NSValueTransformer *)transformer transformedValue:value];
            [self setValue:array forKey:key];
        } else if (cls && [cls respondsToSelector:@selector(isSubclassOfClass:)] && [cls isSubclassOfClass:[JHDataModel class]]) {
            NSArray *values = [cls performSelector:@selector(objectsWithJSONArray:) withObject:value];
            
            [self setValue:values forKey:key];
        } else {
            NSMutableArray *array = [NSMutableArray array];
            [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [array addObject:obj];
            }];
            [self setValue:[array copy] forKey:key];
        }
    }
}

- (void)setDictionaryValue:(NSDictionary *)value forKey:(NSString *)key {
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        id transformer = self.dataTransformers[key];
        
        if (transformer && [transformer isKindOfClass:[NSValueTransformer class]]) {
            NSDictionary *dictionary = [(NSValueTransformer *)transformer transformedValue:value];
            [self setValue:dictionary forKey:key];
        } else if (transformer && [transformer respondsToSelector:@selector(isSubclassOfClass:)] && [transformer isSubclassOfClass:[JHDataModel class]]) {
            Class cls = transformer;
            
            NSDictionary *newValue = [cls performSelector:@selector(objectWithJSONDictionary:) withObject:value];
            
            [self setValue:newValue forKey:key];
        } else {
            [self setValue:value forKey:key];
        }
    }
}

- (void)setModelObjectValue:(NSDictionary *)value forKey:(NSString *)key usingClass:(Class)cls {
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        id newValue = [cls performSelector:@selector(objectWithJSONDictionary:) withObject:value];
        
        [self setValue:newValue forKey:key];
    }
}


#pragma mark - KVC Utility Methods

- (NSString *)protocolForNSArrayProperty:(NSString *)propertyName {
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    
    NSString *propertyProtocol = nil;
    char *typeEncoding = property_copyAttributeValue(property, "T");
    
    if (typeEncoding[0] == '@') {
        if (strlen(typeEncoding) >= 3)
        {
            char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
            __autoreleasing NSString *name = @(className);
            NSRange fromRange = [name rangeOfString:@"<"];
            if (fromRange.location != NSNotFound)
            {
                name = [name substringFromIndex:fromRange.location + 1];

                NSRange toRange = [name rangeOfString:@">"];
                name = [name substringToIndex:toRange.location];
            }
            propertyProtocol = [name copy];
            free(className);
        }
    }
    
    return propertyProtocol;
}

- (Class)classOfProperty:(NSString *)propertyName {
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    
    Class propertyClass = nil;
    char *typeEncoding = property_copyAttributeValue(property, "T");
    switch (typeEncoding[0])
    {
        case '@':
        {
            if (strlen(typeEncoding) >= 3)
            {
                char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                __autoreleasing NSString *name = @(className);
                NSRange range = [name rangeOfString:@"<"];
                if (range.location != NSNotFound)
                {
                    name = [name substringToIndex:range.location];
                }
                propertyClass = NSClassFromString(name) ?: [NSObject class];
                free(className);
            }
            break;
        }
        case 'c':
        case 'i':
        case 's':
        case 'l':
        case 'q':
        case 'C':
        case 'I':
        case 'S':
        case 'L':
        case 'Q':
        case 'f':
        case 'd':
        case 'B':
        {
            propertyClass = [NSNumber class];
            break;
        }
        case '{':
        {
            propertyClass = [NSValue class];
            break;
        }
    }
    free(typeEncoding);
    
    return propertyClass;
}

- (BOOL)propertyExists:(NSString *)propertyName {
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    return property != NULL;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // Do nothing, overriding to prevent an exception from being thrown
}

- (void)setNilValueForKey:(NSString *)key {
    // Do nothing, overriding to prevent an exception from being thrown
}

- (id)valueForUndefinedKey:(NSString *)key {
    return @(NSNotFound);
}

@end


#pragma mark - NSString Utilities

@implementation NSString (CaseConversion)

- (NSString *)camelCaseToSnakeCase {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    scanner.caseSensitive = YES;
    
    NSString *builder = [NSString string];
    NSString *buffer = nil;
    NSUInteger lastScanLocation = 0;
    
    while ( ! [scanner isAtEnd]) {
        if ([scanner scanCharactersFromSet:[NSCharacterSet lowercaseLetterCharacterSet] intoString:&buffer]) {
            builder = [builder stringByAppendingString:buffer];
            
            if ([scanner scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&buffer]) {
                
                builder = [builder stringByAppendingString:@"_"];
                builder = [builder stringByAppendingString:[buffer lowercaseString]];
            }
        }
        
        // If the scanner location has not moved, there's a problem somewhere.
        if (lastScanLocation == scanner.scanLocation) return nil;
        lastScanLocation = scanner.scanLocation;
    }
    
    return builder;
}

- (NSString *)snakeCaseToCamelCase {
    NSArray *components = [self componentsSeparatedByString:@"_"];
    NSMutableString *output = [NSMutableString string];
    
    for (NSUInteger i = 0; i < components.count; i++) {
        if (i == 0) {
            [output appendString:components[i]];
        } else {
            [output appendString:[components[i] capitalizedString]];
        }
    }
    
    return [NSString stringWithString:output];
}

@end




