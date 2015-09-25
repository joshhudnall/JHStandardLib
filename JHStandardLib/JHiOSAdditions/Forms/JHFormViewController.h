//
//  JHFormViewController.h
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//


#import <UIKit/UIKit.h>

// Form Cells
#import "JHFormSwitchCell.h"
#import "JHFormTextCell.h"
#import "JHFormOptionsCell.h"
#import "JHFormDateCell.h"

@interface JHFormViewController : UITableViewController

/**
 *  An array of field descriptors which define the form and holds the values of each field
 */
@property (nonatomic, readonly) NSArray *fields;

@property (nonatomic, readonly) NSArray *formDescription;

@end
