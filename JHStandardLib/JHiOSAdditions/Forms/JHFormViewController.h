//
//  JHFormViewController.h
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//


#import <UIKit/UIKit.h>

@interface JHFormViewController : UITableViewController

/**
 *  An array of field descriptors which define the form and holds the values of each field
 */
@property (nonatomic, readonly) NSArray *fields;

@end
