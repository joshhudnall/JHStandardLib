//
//  JHFormField.h
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const JHFormFieldKey = @"key";
static NSString *const JHFormFieldCellClass = @"cellClass";
static NSString *const JHFormFieldType = @"type";
static NSString *const JHFormFieldTitle = @"title";
static NSString *const JHFormFieldValue = @"value";
static NSString *const JHFormFieldPlaceholder = @"placeholder";
static NSString *const JHFormFieldOptions = @"options";
static NSString *const JHFormFieldAction = @"action";
static NSString *const JHFormFieldHeader = @"header";


@class JHFormField, JHFormViewController;

/**
 *  Block called whenever a cell is updated
 *
 *  @param field The field being updated
 *  @param final If true, the editor has ended or resigned as first responder. If false, the editor (e.g. a textField) is still editing.
 */
typedef void (^JHFieldCellAction)(JHFormField *field, BOOL final);

/**
 *  Defines the field type for a form field
 */
typedef NS_ENUM(NSUInteger, JHFieldType) {
    /**
     *  A generic field that only displays information
     */
    JHFieldTypeInfo,
    /**
     *  A text entry field
     */
    JHFieldTypeText,
    /**
     *  A boolean field, on or off
     */
    JHFieldTypeSwitch,
    /**
     *  A field to select from a list of options
     */
    JHFieldTypeOptions,
    /**
     *  A date selection field
     */
    JHFieldTypeDate,
    /**
     *  A date and time selection field
     */
    JHFieldTypeDateTime,
    /**
     *  A time selection field
     */
    JHFieldTypeTime,
};

@interface JHFormField : NSObject

/**
 *  The form controller the field belongs to
 */
@property (nonatomic, weak) JHFormViewController *formController;

/**
 *  The type of the field
 */
@property (nonatomic, assign, readonly) JHFieldType fieldType;

/**
 *  The unique key of the field, used for identifying the field
 */
@property (nonatomic, copy) NSString *key;

/**
 *  The class of the cell that represents this field
 */
@property (nonatomic) Class cellClass;

/**
 *  The section header of the field
 */
@property (nonatomic, copy) NSString *header;

/**
 *  The title of the field
 */
@property (nonatomic, copy) NSString *title;

/**
 *  The value of the field
 */
@property (nonatomic, copy) id value;

/**
 *  Options to display on an options field
 */
@property (nonatomic, copy) NSArray *options;

/**
 *  Index of the selected option on an options field. -1 if no option is selected.
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  A placeholder to display in the field
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  The action a field should perform after its value has changed. This action will be called when the user changes the value
 *  or it is updated via code.
 */
@property (nonatomic, copy) JHFieldCellAction action;



/**
 *  Factory method to generate a new field
 *
 *  @param fieldType   The type of form field
 *  @param header      If not nil, starts a new section in the form. Pass an empty string to create a section without a title.
 *  @param title       The title of the field
 *  @param value       The value of the field
 *  @param placeholder A placeholder to display when the field has no value
 *
 *  @return A field object
 */
+ (instancetype)fieldWithDictionary:(NSDictionary *)dictionary;

@end



