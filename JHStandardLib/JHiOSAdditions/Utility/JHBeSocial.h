//
//  JHAppActions.h
//  PeopleInSpace
//
//  Created by Josh Hudnall on 3/25/14.
//
//

#import <Foundation/Foundation.h>

@interface JHBeSocial : NSObject

/**
 *  Attempt to open a Twitter user's profile in Tweetbot, Twitter App or Twitter.com in that order
 *
 *  @param username The username of the user to open
 */
+ (void)openTwitterProfile:(NSString *)username;

/**
 *  Attempt to open a tweet in Tweetbot, Twitter App or Twitter.com in that order
 *
 *  @param username The username of the tweet owner
 *  @param tweetID  The numeric ID of the tweet
 */
+ (void)openTwitterStatus:(NSString *)username tweet:(unsigned long long)tweetID;

/**
 *  Attempts to open a Facebook page in the native app, falling back to Safari
 *
 *  @param pageID The ID of the page to open
 */
+ (void)openFacebookPageWithID:(NSString *)pageID;

@end
