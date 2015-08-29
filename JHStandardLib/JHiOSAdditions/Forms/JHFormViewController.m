//
//  JHFormViewController.m
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//

#import <UIKit/UIKit.h>
#import "JHFormViewController.h"

// Form Cells
#import "JHFormSwitchCell.h"
#import "JHFormTextCell.h"
#import "JHFormOptionsCell.h"
#import "JHFormDateCell.h"


static NSString *const JHFormCellTypeDefault = @"default";
static NSString *const JHFormCellTypeLabel = @"label";
static NSString *const JHFormCellTypeText = @"text";
static NSString *const JHFormCellTypeSwitch = @"switch";
static NSString *const JHFormCellTypeOptions = @"options";
static NSString *const JHFormCellTypeDate = @"date";
static NSString *const JHFormCellTypeTime = @"time";
static NSString *const JHFormCellTypeDateTime = @"datetime";

// To be implemented
//static NSString *const JHFormCellTypeLongText = @"longtext";
//static NSString *const JHFormCellTypeURL = @"url";
//static NSString *const JHFormCellTypeEmail = @"email";
//static NSString *const JHFormCellTypePhone = @"phone";
//static NSString *const JHFormCellTypePassword = @"password";
//static NSString *const JHFormCellTypeNumber = @"number";
//static NSString *const JHFormCellTypeInteger = @"integer";
//static NSString *const JHFormCellTypeFloat = @"float";
//static NSString *const JHFormCellTypeBitfield = @"bitfield";
//static NSString *const JHFormCellTypeImage = @"image";


@interface JHFormViewController ()

@property (nonatomic, strong) NSMutableArray *sectionsAndRows;
@property (nonatomic) BOOL hasRegisteredClassesForTable;

@end

@implementation JHFormViewController
@synthesize fields = _fields;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _sectionsAndRows = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    UIBarButtonItem *printButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(echoValues)];
    self.navigationItem.rightBarButtonItem = printButton;
}

- (void)echoValues {
    JHFormField *field = [_fields objectAtIndex:4];
    field.value = [NSDate date];
    
    field = [_fields objectAtIndex:1];
    field.value = @"Test";
    
    field = [_fields objectAtIndex:7];
    field.value = @YES;
    
    [_fields enumerateObjectsUsingBlock:^(JHFormField *field, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@ : %@", field.title, field.value);
        if (field.fieldType == JHFieldTypeOptions) {
            NSLog(@"%@ Selected Index : %d", field.title, field.selectedIndex);
        }
    }];
}

- (NSArray *)fields {
    if ( ! _fields) {
        _fields = @[
                    [JHFormField fieldWithDictionary:@{JHFormFieldType:@(JHFieldTypeText),
                                                       JHFormFieldKey:@"firstName",
                                                       JHFormFieldHeader:@"Personal Information",
                                                       JHFormFieldTitle:@"First Name",
                                                       JHFormFieldPlaceholder:@"Josh",
                                                       JHFormFieldAction:^(JHFormField *field, BOOL final) {
                        NSLog(@"%@ : %@", field.title, field.value);
                    },
                                                       }],
                    
                    [JHFormField fieldWithDictionary:@{JHFormFieldType:@(JHFieldTypeText),
                                                       JHFormFieldKey:@"lastName",
                                                       JHFormFieldTitle:@"Last Name",
                                                       JHFormFieldPlaceholder:@"Hudnall",
                                                       JHFormFieldAction:^(JHFormField *field, BOOL final) {
                        NSLog(@"%@ : %@", field.title, field.value);
                    },
                                                       }],
                    
                    [JHFormField fieldWithDictionary:@{JHFormFieldType:@(JHFieldTypeDate),
                                                       JHFormFieldKey:@"birthdate",
                                                       JHFormFieldTitle:@"Birthdate",
                                                       JHFormFieldPlaceholder:@"Jan 1, 2001",
                                                       JHFormFieldAction:^(JHFormField *field, BOOL final) {
                        NSLog(@"%@ : %@", field.title, field.value);
                    },
                                                       }],
                    
                    [JHFormField fieldWithDictionary:@{JHFormFieldType:@(JHFieldTypeTime),
                                                       JHFormFieldKey:@"wakeUp",
                                                       JHFormFieldTitle:@"Wake Up Time",
                                                       JHFormFieldPlaceholder:@"10:00am",
                                                       JHFormFieldAction:^(JHFormField *field, BOOL final) {
                        NSLog(@"%@ : %@", field.title, field.value);
                    },
                                                       }],
                    
                    [JHFormField fieldWithDictionary:@{JHFormFieldType:@(JHFieldTypeDateTime),
                                                       JHFormFieldKey:@"nextMeeting",
                                                       JHFormFieldTitle:@"Next Meeting",
                                                       JHFormFieldPlaceholder:@"Mar 2, 2012 3:15pm",
                                                       JHFormFieldAction:^(JHFormField *field, BOOL final) {
                        NSLog(@"%@ : %@", field.title, field.value);
                    },
                                                       }],
                    
                    [JHFormField fieldWithDictionary:@{JHFormFieldType:@(JHFieldTypeOptions),
                                                       JHFormFieldKey:@"favoriteCity",
                                                       JHFormFieldHeader:@"Preferences",
                                                       JHFormFieldTitle:@"Favorite City",
                                                       JHFormFieldOptions:@[
                                                               @"New York",
                                                               @"Chicago",
                                                               @"Denver",
                                                               ],
                                                       JHFormFieldPlaceholder:@"Select a City",
                                                       JHFormFieldAction:^(JHFormField *field, BOOL final) {
                        NSLog(@"%@ : %@", field.title, field.value);
                    },
                                                       }],
                    
                    [JHFormField fieldWithDictionary:@{JHFormFieldType:@(JHFieldTypeSwitch),
                                                       JHFormFieldKey:@"receiveNotifications",
                                                       JHFormFieldTitle:@"Receive Notifications",
                                                       JHFormFieldValue:@YES,
                                                       JHFormFieldAction:^(JHFormField *field, BOOL final) {
                        NSLog(@"%@ : %@", field.title, field.value);
                    },
                                                       }],
                    
                    [JHFormField fieldWithDictionary:@{JHFormFieldType:@(JHFieldTypeSwitch),
                                                       JHFormFieldKey:@"trackAds",
                                                       JHFormFieldTitle:@"Track Ads",
                                                       JHFormFieldAction:^(JHFormField *field, BOOL final) {
                        NSLog(@"%@ : %hhd", field.title, [field.value boolValue]);
                    },
                                                       }],
                    ];

        if ( ! _hasRegisteredClassesForTable) {
            [[self classesForDefaultFieldTypes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [self.tableView registerClass:obj forCellReuseIdentifier:NSStringFromClass(obj)];
            }];
            _hasRegisteredClassesForTable = YES;
        }

        // Makes sure each field can reference this controller
        [_fields enumerateObjectsUsingBlock:^(JHFormField *field, NSUInteger idx, BOOL *stop) {
            field.formController = self;

            if (field.cellClass) {
                [self.tableView registerClass:field.cellClass forCellReuseIdentifier:NSStringFromClass(field.cellClass)];
            }
        }];
    }
    
    return _fields;
}

- (NSDictionary *)classesForDefaultFieldTypes {
    return @{@(JHFieldTypeInfo): [JHFormCell class],
             @(JHFieldTypeText): [JHFormTextCell class],
             @(JHFieldTypeDate): [JHFormDateCell class],
             @(JHFieldTypeTime): [JHFormDateCell class],
             @(JHFieldTypeDateTime): [JHFormDateCell class],
             @(JHFieldTypeOptions): [JHFormOptionsCell class],
             @(JHFieldTypeSwitch): [JHFormSwitchCell class],
             };
    
}

- (Class)classForFieldType:(JHFieldType)fieldType {
    return [[self classesForDefaultFieldTypes] objectForKey:@(fieldType)];
}

- (NSArray *)formSections {
    NSMutableArray *sections = [NSMutableArray array];
    [self.fields enumerateObjectsUsingBlock:^(JHFormField *field, NSUInteger idx, BOOL *stop) {
        if (field.header) {
            [sections addObject:field.header];
        }
    }];
    
    return [sections copy];
}

- (NSArray *)formRowsForSection:(NSString *)sectionName {
    NSMutableArray *rows = [NSMutableArray array];
    
    __block BOOL inSection = NO;
    [self.fields enumerateObjectsUsingBlock:^(JHFormField *field, NSUInteger idx, BOOL *stop) {
        if ([field.header isEqualToString:sectionName]) {
            inSection = YES;
        } else if (field.header && inSection) {
            inSection = NO;
        }
        
        if (inSection) {
            [rows addObject:field];
        }
    }];
    
    return [rows copy];
}

- (JHFormField *)fieldForIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionName = [[self formSections] objectAtIndex:indexPath.section];
    return [[self formRowsForSection:sectionName] objectAtIndex:indexPath.row];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self formSections].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self formSections] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName = [[self formSections] objectAtIndex:section];
    return [self formRowsForSection:sectionName].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHFormField *field = [self fieldForIndexPath:indexPath];
    
    Class cellClass = field.cellClass ?: [self classForFieldType:field.fieldType];
    
    JHFormCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    
    /*
     * The cell maintains a weak reference to the field (held strongly in this controller) so that it can update the field.
     * This also allows us to update the field object and have the cell update its display to reflect changes.
     */
    cell.field = field;
    
    cell.placeholderColor = [UIColor blueColor];
    cell.valueColor = [UIColor redColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //forward to cell
    UITableViewCell<JHFormCell> *cell = (UITableViewCell<JHFormCell> *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(didSelectWithTableView:controller:)]) {
        [cell didSelectWithTableView:tableView controller:self];
    }
}

@end
