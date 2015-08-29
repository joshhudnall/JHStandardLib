//
//  UIApplication+JHExtras.m
//  Air1
//
//  Created by Josh Hudnall on 8/27/14.
//
//

#import "UIApplication+JHExtras.h"
#import "PRPAlertView.h"

@implementation UIApplication (JHExtras)

- (void)jh_askToOpenURLString:(NSString *)urlString {
    [self jh_askToOpenURL:[NSURL URLWithString:urlString] withCallback:nil];
}

- (void)jh_askToOpenURLString:(NSString *)urlString withCallback:(void (^)(BOOL didOpen))callback {
    [self jh_askToOpenURL:[NSURL URLWithString:urlString] withCallback:callback];
}

- (void)jh_askToOpenURL:(NSURL *)url {
    [self jh_askToOpenURL:url withCallback:nil];
}

- (void)jh_askToOpenURL:(NSURL *)url withCallback:(void (^)(BOOL didOpen))callback {
    // Suprisingly common to pass in a string instead of an NSURL
    if ([url isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    [PRPAlertView showWithTitle:@""
                        message:@"This will take you out of the app. Do you want to continue?"
                    cancelTitle:@"Cancel"
                    cancelBlock:^(UIAlertView *alertView) {
                        if (callback) {
                            callback(NO);
                        }
                    }
                     otherTitle:@"Leave App"
                     otherBlock:^(UIAlertView *alertView) {
                         if (callback) {
                             callback(YES);
                         }
                         [self openURL:url];
                     }];
}

- (void)jh_askToCall:(NSString *)phoneNumber {
    // Strips out any non-valid characters from the number
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+();"] invertedSet]] componentsJoinedByString:@""];
    
    [self openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
}

@end
