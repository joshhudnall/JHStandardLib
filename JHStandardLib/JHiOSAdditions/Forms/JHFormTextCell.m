//
//  JHTextFieldCell.m
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//

#import "JHFormTextCell.h"

@implementation JHFormTextCell

- (void)setup {
    [super setup];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.textColor = self.valueColor;
    [_textField setValue:self.placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    self.accessoryView = _textField;
}

// TODO: Shouldn't fire action if the value wasn't changed
- (void)update {
    [super update];
    
    _textField.text = self.field.value;
    _textField.placeholder = self.field.placeholder;
    
    if (_shouldPerformActions && self.field.action) {
        self.field.action(self.field, YES);
    }
}

- (void)setValueColor:(UIColor *)valueColor {
    [super setValueColor:valueColor];
    
    _textField.textColor = valueColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    [super setPlaceholderColor:placeholderColor];
    
    [_textField setValue:self.placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}


#pragma mark - Respond to events

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [_textField becomeFirstResponder];
}

- (void)didSelectWithTableView:(UITableView *)tableView controller:(__unused UIViewController *)controller {
    [self becomeFirstResponder];
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.field.value = textField.text;
}

@end
