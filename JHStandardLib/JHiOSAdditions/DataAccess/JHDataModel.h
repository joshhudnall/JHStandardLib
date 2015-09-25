//
//  JHDataModel.h
//  JHStandardLib
//
//  Created by Josh Hudnall on 7/27/15.
//  Copyright (c) 2015 Josh Hudnall. All rights reserved.
//

#import <Foundation/Foundation.h>

// Implements smart NSSecureCoding on all objects without configuration needed
#import "AutoCoding.h"

/**
 *  A standard JSON modeling object. Prefers convention over configuration, though some configuration is available. JSON will ideally be camelCased and the object supports all standard JSON data types.
 */
@interface JHDataModel : NSObject

/**
 *  The raw JSON data used to hydrate this object, nil if model was created without a JSON object
 */
@property (nonatomic, readonly) NSDictionary *rawData;

/**
 *  The computed JSON representation of the object
 */
@property (nonatomic, readonly) NSDictionary *jsonDictionary;

/**
 *  A dictionary that maps JSON data to the object. Default implementation returns a dictionary mapping JSON key "id" to Obj-C property itemID. Override getter to add custom mappings.
 */
@property (nonatomic, readonly) NSDictionary *keyMap;

/**
 *  A dictionary that contains data transformers. Default implementation returns nil. Override getter to add custom mappings.
 */
@property (nonatomic, readonly) NSDictionary *dataTransformers;

/**
 *  Returns an array of objects hydrated with JSON data
 *
 *  @param jsonArray The JSON array of data
 *
 *  @return NSArray of objects
 */
+ (NSArray *)objectsWithJSONArray:(NSArray *)jsonArray;

/**
 *  Factory method to hydrate object with JSON data. Will attempt to match JSON keys (in snake_case or camelCase) to property names (in camelCase) and using the -keyMap property.
 *
 *  @param jsonDictionary NSDictionary containing the JSON data to use.
 *
 *  @return An object inflated with whatever JSON data is available.
 */
+ (instancetype)objectWithJSONDictionary:(NSDictionary *)jsonDictionary;

/**
 *  Init object and hydrate with JSON data. Will attempt to match JSON keys (in snake_case or camelCase) to property names (in camelCase) and using the -keyMap property.
 *
 *  @param jsonDictionary NSDictionary containing the JSON data to use.
 *
 *  @return An object inflated with whatever JSON data is available.
 */
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

/**
 *  Used to determine whether the object created from JSON data is valid. Used by objectsWithJSONArray: when determining whether to include the object. Default implementation always returns YES.
 *
 *  @return BOOL indicating whether the object is valid.
 */
- (BOOL)isValid;

@end


/**
 *  Allows for smartly-typed arrays. Declare an array with the appropriate subclass name-as-protocol, and the serializer will attempt to use that class as the objects that hold the data in the array.
 *
 *  @param JH_MODEL_OBJECT_SUBCLASS Name of subclass
 */
#define JH_ARRAY_TYPE(JH_MODEL_OBJECT_SUBCLASS) \
@protocol JH_MODEL_OBJECT_SUBCLASS <NSObject> \
@end


