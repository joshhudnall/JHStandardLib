//
//  UICollectionView+JHExtras.h
//  Air1
//
//  Created by Josh Hudnall on 8/27/14.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionView (JHExtras)

/**
 *  Returns the index path for the row containing the specified view
 *
 *  @param view A view to test
 *
 *  @return Returns the indexPath of the cell containing the view, nil if no cell contains the view
 */
- (NSIndexPath *)jh_indexPathForItemContainingView:(UIView *)view;

@end
