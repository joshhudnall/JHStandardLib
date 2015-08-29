//
//  JHFormCell.h
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//

#import <UIKit/UIKit.h>
#import "JHFormField.h"

@protocol JHFormCell <NSObject>

@optional
/**
 *  If implemented, this method will be called whenever the user selects the cell in the form's tableView.
 *
 *  @param tableView  The tableView where the cell was selected.
 *  @param controller The tableViewController for the tableView.
 */
- (void)didSelectWithTableView:(UITableView *)tableView controller:(UITableViewController *)controller;

@end


@interface JHFormCell : UITableViewCell <JHFormCell> {
    /**
     *  Ensures that the cell is properly setup before performing any action blocks (prevents unnecessarily null values being saved).
     */
    BOOL _shouldPerformActions;
}

/**
 *  The field that the cell is displaying
 */
@property (nonatomic, weak) JHFormField *field;

/**
 *  The color of the value text in the cell
 */
@property (nonatomic, copy) UIColor *valueColor;

/**
 *  The color of the placeholder text in the cell
 */
@property (nonatomic, copy) UIColor *placeholderColor;

/**
 *  Sets up the cell for the type of field being displayed
 */
- (void)setup;

/**
 *  Updates the display of the cell to reflect the field's values
 */
- (void)update;

@end
