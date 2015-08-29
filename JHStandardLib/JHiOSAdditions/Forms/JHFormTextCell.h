//
//  JHTextFieldCell.h
//  GetStarted
//
//  Created by Josh Hudnall on 5/29/14.
//
//

#import <UIKit/UIKit.h>
#import "JHFormCell.h"

@interface JHFormTextCell : JHFormCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

