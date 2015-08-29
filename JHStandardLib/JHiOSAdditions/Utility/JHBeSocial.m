//
//  JHAppActions.m
//
//  Created by Josh Hudnall on 3/25/14.
//
//

#import <UIKit/UIKit.h>
#import "JHBeSocial.h"
#import "PRPAlertView.h"
#import "UIApplication+JHExtras.h"

typedef NS_ENUM(NSUInteger, TwitterApp) {
    TwitterAppTweetbot,
    TwitterAppTwitter,
    TwitterAppSafari,
};

@implementation JHBeSocial

#pragma mark - Twitter

+ (void)openTwitterProfile:(NSString *)username {
    if ([self hasTweetbot]) {
        [self openTwitterLink:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/%@", username]] inApp:TwitterAppTweetbot];
        
    } else if ([self hasTwitter]) {
        [self openTwitterLink:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", username]] inApp:TwitterAppTwitter];
        
    } else {
        [self openTwitterLink:[NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", username]] inApp:TwitterAppSafari];
    }
}

+ (void)openTwitterStatus:(NSString *)username tweet:(unsigned long long)tweetID {
    if ([self hasTweetbot]) {
        [self openTwitterLink:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///status/%llu", tweetID]] inApp:TwitterAppTweetbot];
        
    } else if ([self hasTwitter]) {
        [self openTwitterLink:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://status?id=%llu", tweetID]] inApp:TwitterAppTwitter];
        
    } else {
        [self openTwitterLink:[NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@/status/%llu", username, tweetID]] inApp:TwitterAppSafari];
    }
}

+ (BOOL)hasTweetbot {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:///user_profile/peopleinspace"]];
}

+ (BOOL)hasTwitter {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=peopleinspace"]];
}

+ (void)openTwitterLink:(NSURL *)url inApp:(TwitterApp)app {
    NSString *alertMessage = @"";
    NSString *alertActionButton = @"";
    if (app == TwitterAppTweetbot) {
        alertMessage = @"This will take you to Tweetbot. Do you want to continue?";
        alertActionButton = @"Open Tweetbot";
    } else if (app == TwitterAppTwitter) {
        alertMessage = @"This will take you to the Twitter app. Do you want to continue?";
        alertActionButton = @"Open Twitter";
    } else {
        alertMessage = @"This will take you to Safari. Do you want to continue?";
        alertActionButton = @"Open Safari";
    }
    
    [PRPAlertView showWithTitle:@"Leave App?"
                        message:alertMessage
                    cancelTitle:@"Cancel"
                    cancelBlock:nil
                     otherTitle:alertActionButton
                     otherBlock:^(UIAlertView *alertView) {
                         [[UIApplication sharedApplication] openURL:url];
                     }];
}


#pragma mark - Facebook

+ (void)openFacebookPageWithID:(NSString *)pageID {
    NSString *fbAppString = [NSString stringWithFormat:@"fb://profile/%@", pageID];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:fbAppString]]) {
        [[UIApplication sharedApplication] jh_askToOpenURLString:fbAppString];
    } else {
        [[UIApplication sharedApplication] jh_askToOpenURLString:[NSString stringWithFormat:@"http://facebook.com/%@", pageID]];
    }
}

@end
