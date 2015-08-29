//
//  JHFormField.m
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//

#import "JHFormField.h"

@interface JHFormField ()

// Redeclared as readwrite for the factory methods
@property (nonatomic, assign, readwrite) JHFieldType fieldType;

@end


@implementation JHFormField
@synthesize value = _value;

+ (instancetype)fieldWithDictionary:(NSDictionary *)dictionary {
    
    JHFormField *field = [JHFormField new];
    
    field.fieldType = [[dictionary objectForKey:JHFormFieldType] integerValue] ?: 0;
    field.key = [dictionary objectForKey:JHFormFieldKey] ?: @"";
    field.cellClass = [dictionary objectForKey:JHFormFieldCellClass];
    field.header = [dictionary objectForKey:JHFormFieldHeader];
    field.title = [dictionary objectForKey:JHFormFieldTitle] ?: @"";
    field.value = [dictionary objectForKey:JHFormFieldValue];
    field.options = [dictionary objectForKey:JHFormFieldOptions];
    field.placeholder = [dictionary objectForKey:JHFormFieldPlaceholder];
    field.action = [dictionary objectForKey:JHFormFieldAction];
    
    return field;
}

- (void)setValue:(id)value {
    _value = value;
    
    if (_fieldType == JHFieldTypeOptions) {
        NSInteger index = [_options indexOfObject:self.value];
        _selectedIndex = (index != NSNotFound) ? index : -1;
    }
}

- (id)value {
    // Makes it so that an unset bool value becomes NO
    if (self.fieldType == JHFieldTypeSwitch) {
        return @([_value boolValue]);
    }
    
    return _value;
}

- (NSInteger)selectedIndex {
    if (_fieldType != JHFieldTypeOptions) {
        return -1;
    }
    
    NSInteger index = [_options indexOfObject:self.value];
    
    return (index != NSNotFound) ? index : -1;
}

@end


