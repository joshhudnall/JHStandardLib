//
//  JHFormCell.m
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//

#import "JHFormCell.h"

@implementation JHFormCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup {
    _valueColor = [UIColor darkTextColor];
    _placeholderColor = [UIColor colorWithWhite:0.f alpha:0.7f];
    
    [self.field addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.field addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    [self.field addObserver:self forKeyPath:@"placeholder" options:NSKeyValueObservingOptionNew context:nil];
    [self.field addObserver:self forKeyPath:@"options" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.field removeObserver:self forKeyPath:@"title"];
    [self.field removeObserver:self forKeyPath:@"value"];
    [self.field removeObserver:self forKeyPath:@"placeholder"];
    [self.field removeObserver:self forKeyPath:@"options"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.field) {
        _shouldPerformActions = NO;

        if ([keyPath isEqualToString:@"title"]) {
            [self update];
        }
        
        if ([keyPath isEqualToString:@"placeholder"]) {
            [self update];
        }
        
        if ([keyPath isEqualToString:@"options"]) {
            [self update];
        }
        
        _shouldPerformActions = YES;
        
        if ([keyPath isEqualToString:@"value"]) {
            [self update];
        }
        
        [self setNeedsLayout];
    }
}

- (void)setField:(JHFormField *)field {
    _shouldPerformActions = NO;
    
    _field = field;
    
    [self setup];
    [self update];
    
    _shouldPerformActions = YES;
}

- (void)setValueColor:(UIColor *)valueColor {
    _shouldPerformActions = NO;
    
    _valueColor = valueColor;
    
    [self update];
    
    _shouldPerformActions = YES;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _shouldPerformActions = NO;
    
    _placeholderColor = placeholderColor;
    
    [self update];
    
    _shouldPerformActions = YES;
}

- (void)update {
    self.textLabel.text = _field.title;
}

@end
