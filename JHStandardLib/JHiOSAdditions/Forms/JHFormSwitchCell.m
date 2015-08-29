//
//  SwitchCell.m
//  Air1Mobile
//
//  Created by Josh Hudnall on 7/27/12.
//
//

#import "JHFormSwitchCell.h"

@implementation JHFormSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setup {
    [super setup];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _toggleSwitch = [[UISwitch alloc] init];
    [_toggleSwitch addTarget:self action:@selector(toggleSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.accessoryView = _toggleSwitch;
}

// TODO: Shouldn't fire action if the value wasn't changed
- (void)update {
    [super update];
    
    [_toggleSwitch setOn:[self.field.value boolValue] animated:YES];

    if (_shouldPerformActions && self.field.action) {
        self.field.action(self.field, YES);
    }
}

- (void)toggleSwitchValueChanged:(UISwitch *)toggleSwitch {
    self.field.value = @(toggleSwitch.isOn);
}

@end
