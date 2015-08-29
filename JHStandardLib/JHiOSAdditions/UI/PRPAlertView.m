/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
 ***/
//
//  PRPAlertView.m
//  PRPAlertView
//
//  Created by Matt Drance on 1/24/11.
//  Copyright 2011 Bookhouse Software LLC. All rights reserved.
//

#import "PRPAlertView.h"

@interface PRPAlertView ()

@property (nonatomic, copy) PRPAlertBlock cancelBlock;
@property (nonatomic, copy) PRPAlertBlock otherBlock;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *otherButtonTitle;

@end

@implementation PRPAlertView

@synthesize cancelBlock;
@synthesize otherBlock;
@synthesize cancelButtonTitle;
@synthesize otherButtonTitle;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
          buttonTitle:(NSString *)buttonTitle {
    
    [self showWithTitle:title message:message
            cancelTitle:buttonTitle cancelBlock:nil
             otherTitle:nil otherBlock:nil];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
          cancelTitle:(NSString *)cancelTitle
          cancelBlock:(PRPAlertBlock)cancelBlk
           otherTitle:(NSString *)otherTitle
           otherBlock:(PRPAlertBlock)otherBlk {
    
    [self showWithTitle:title
                  style:UIAlertViewStyleDefault message:message
            cancelTitle:cancelTitle cancelBlock:cancelBlk
             otherTitle:otherTitle otherBlock:otherBlk];
}

+ (void)showWithTitle:(NSString *)title
                style:(UIAlertViewStyle)style
              message:(NSString *)message
          cancelTitle:(NSString *)cancelTitle
          cancelBlock:(PRPAlertBlock)cancelBlk
           otherTitle:(NSString *)otherTitle
           otherBlock:(PRPAlertBlock)otherBlk {
    
    [[[self alloc] initWithTitle:title style:style
                         message:message
                     cancelTitle:cancelTitle cancelBlock:cancelBlk
                      otherTitle:otherTitle otherBlock:otherBlk]
     show];
}

- (id)initWithTitle:(NSString *)title
              style:(UIAlertViewStyle)style
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle 
        cancelBlock:(PRPAlertBlock)cancelBlk
         otherTitle:(NSString *)otherTitle
         otherBlock:(PRPAlertBlock)otherBlk {
	
    if ((self = [super initWithTitle:title 
                             message:message
                            delegate:self
                   cancelButtonTitle:cancelTitle 
                   otherButtonTitles:otherTitle, nil])) {
		
        if (cancelBlk == nil && otherBlk == nil) {
            self.delegate = nil;
        }
        self.alertViewStyle = style;
        self.cancelButtonTitle = cancelTitle;
        self.otherButtonTitle = otherTitle;
        self.cancelBlock = cancelBlk;
        self.otherBlock = otherBlk;
    }
    return self;
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:self.cancelButtonTitle]) {
        if (self.cancelBlock) self.cancelBlock(alertView);
    } else if ([buttonTitle isEqualToString:self.otherButtonTitle]) {
        if (self.otherBlock) self.otherBlock(alertView);
    }
}

@end