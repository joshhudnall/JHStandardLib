//
//  JHSwitchCell.m
//  Air1
//
//  Created by Josh Hudnall on 8/29/14.
//
//

#import "JHSwitchCell.h"

@implementation JHSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _toggleSwitch = [UISwitch new];
        self.accessoryView = _toggleSwitch;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
