//
//  UICollectionViewCell+JHExtras.h
//  GetStarted
//
//  Created by Josh Hudnall on 8/4/14.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (JHExtras)

/**
 *  Returns a string that can be used as the cell identifier for cell reuse
 *
 *  @return Cell identifier
 */
+ (NSString *)jh_defaultCellIdentifier;

@end
