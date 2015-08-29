//
//  JHViewController.m
//  MyDieline
//
//  Created by Josh Hudnall on 5/24/12.
//  Copyright (c) 2012 Method Apps. All rights reserved.
//

#import "JHViewController.h"
#import "NSString+JHExtras.h"

@interface JHViewController ()

@end

@implementation JHViewController

- (NSUInteger)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone;
}

@end


