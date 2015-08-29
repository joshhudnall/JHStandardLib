//
//  JHDateCell.m
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//

#import "JHFormDateCell.h"
#import "NSDate+JHExtras.h"

@interface JHFormDateCell ()

@property (nonatomic, assign) BOOL editing;
@property (nonatomic, strong) UIDatePicker *pickerView;

@end

@implementation JHFormDateCell
@synthesize editing = _editing;

- (void)setup {
    [super setup];
    
    self.pickerView = [[UIDatePicker alloc] init];
    [self.pickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

// TODO: Shouldn't fire action if the value wasn't changed
- (void)update {
    [super update];
    
    if ( ! self.field.value) {
        self.detailTextLabel.text = self.field.placeholder;
        self.detailTextLabel.textColor = self.placeholderColor;
    } else {
        if (self.pickerView.datePickerMode == UIDatePickerModeDate) {
            self.detailTextLabel.text = [self.field.value jh_dateFormatted:@"MMM dd, YYYY"];
        } else if (self.pickerView.datePickerMode == UIDatePickerModeDateAndTime) {
            self.detailTextLabel.text = [self.field.value jh_dateFormatted:@"MMM dd, YYYY h:mma"];
        } else {
            self.detailTextLabel.text = [self.field.value jh_dateFormatted:@"h:mma"];
        }
        self.detailTextLabel.textColor = self.valueColor;
    }
    
    [self setNeedsLayout];
    
    if (_shouldPerformActions && self.field.action) {
        self.field.action(self.field, YES);
    }
}

- (void)didSelectWithTableView:(UITableView *)tableView controller:(__unused UIViewController *)controller {
    if (self.field.value) {
        _pickerView.date = self.field.value;
    }
    [self becomeFirstResponder];
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

- (void)setField:(JHFormField *)field {
    [super setField:field];
    
    if (self.field.fieldType == JHFieldTypeDate) {
        self.pickerView.datePickerMode = UIDatePickerModeDate;
    } else if (self.field.fieldType == JHFieldTypeDateTime) {
        self.pickerView.datePickerMode = UIDatePickerModeDateAndTime;
    } else {
        self.pickerView.datePickerMode = UIDatePickerModeTime;
    }
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker {
    self.field.value = datePicker.date;
}


#pragma mark - Respond to events

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    _editing = YES;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    _editing = NO;
    if (_shouldPerformActions && self.field.action) {
        self.field.action(self.field, _editing);
    }
    return [super resignFirstResponder];
}

- (UIView *)inputView {
    return self.pickerView;
}


@end

