//
//  UIApplication+JHExtras.h
//  Air1
//
//  Created by Josh Hudnall on 8/27/14.
//
//

#import <UIKit/UIKit.h>

@interface UIApplication (JHExtras)

/**
 *  Asks the user if they'd like to leave the app and open the url.
 *
 *  @param urlString The url string to open
 */
- (void)jh_askToOpenURLString:(NSString *)urlString;

/**
 *  Asks the user if they'd like to leave the app and open the url.
 *
 *  @param urlString The url string to open
 *  @param callback  A callback that includes whether or not the user decided to open the link
 */
- (void)jh_askToOpenURLString:(NSString *)urlString withCallback:(void (^)(BOOL didOpen))callback;

/**
 *  Asks the user if they'd like to leave the app and open the url.
 *
 *  @param url The url to open
 */
- (void)jh_askToOpenURL:(NSURL *)url;

/**
 *  Asks the user if they'd like to leave the app and open the url.
 *
 *  @param url The url to open
 *  @param callback  A callback that includes whether or not the user decided to open the link
 */
- (void)jh_askToOpenURL:(NSURL *)url withCallback:(void (^)(BOOL didOpen))callback;

/**
 *  Asks the user if they'd like to call a number
 *
 *  @param phoneNumber The phone number to call
 */
- (void)jh_askToCall:(NSString *)phoneNumber;

@end
