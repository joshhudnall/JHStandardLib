//
//  JHOptionsCell.m
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//

#import "JHFormOptionsCell.h"

@interface JHFormOptionsCell () <UIPickerViewDataSource, UIPickerViewDelegate>

/**
 *  The currently selected option index. -1 means no selected index
 */
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL editing;
@property (nonatomic, strong) UIPickerView *pickerView;

@end


@implementation JHFormOptionsCell
@synthesize editing = _editing;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setup {
    [super setup];
    
    _selectedIndex = -1;
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;

    [self.field addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    [self update];
}

- (void)dealloc {
    _pickerView.dataSource = nil;
    _pickerView.delegate = nil;
    
    [self.field removeObserver:self forKeyPath:@"selectedIndex"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if (object == self.field) {
        if ([keyPath isEqualToString:@"selectedIndex"]) {
            self.selectedIndex = self.field.selectedIndex;
        }
        
        [self setNeedsLayout];
    }
}

// TODO: Shouldn't fire action if the value wasn't changed
- (void)update {
    [super update];
    
    // Find the selected index either by value or by index
    if ([self.field.value isKindOfClass:[NSString class]]) {
        [self.field.options enumerateObjectsUsingBlock:^(NSString *option, NSUInteger idx, BOOL *stop) {
            if ([option isEqualToString:self.field.value]) {
                _selectedIndex = idx;
                *stop = YES;
            }
        }];
    } else if (self.field.value) {
        _selectedIndex = [self.field.value integerValue];
    } else {
        _selectedIndex = -1;
    }

    // Set the cell to display the value or placeholder
    self.detailTextLabel.text = [self nameForOptionAtIndex:_selectedIndex] ?: self.field.placeholder;
    
    // If we're displaying the placholder, dim the text
    if (_selectedIndex == -1) {
        
        self.detailTextLabel.textColor = self.placeholderColor;
    } else {
        self.detailTextLabel.textColor = self.valueColor;
    }
    
    [self setNeedsLayout];
}

- (void)didSelectWithTableView:(UITableView *)tableView controller:(__unused UIViewController *)controller {
    [self becomeFirstResponder];
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

- (NSString *)nameForOptionAtIndex:(NSInteger)index {
    if (index < 0 || index > self.field.options.count - 1) {
        return nil;
    }
    
    return [self.field.options objectAtIndex:index];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < -1) {
        selectedIndex = -1;
    } else if (selectedIndex > (NSInteger)self.field.options.count - 1) {
        selectedIndex = self.field.options.count - 1;
    }
    
    _selectedIndex = selectedIndex;

    self.field.value = [self nameForOptionAtIndex:_selectedIndex];

    if (_shouldPerformActions && self.field.action) {
        self.field.action(self.field, _editing);
    }
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


#pragma mark - UIPickerView Delegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView numberOfRowsInComponent:(__unused NSInteger)component
{
    return [self.field.options count];
}

- (NSString *)pickerView:(__unused UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(__unused NSInteger)component
{
    return [self nameForOptionAtIndex:row];
}

- (void)pickerView:(__unused UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(__unused NSInteger)component
{
    self.selectedIndex = row;
}

@end
