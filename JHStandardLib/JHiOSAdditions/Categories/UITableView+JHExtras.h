//
//  UITableView+JHExtras.h
//  CellSubviewLocation
//
//  Created by Matt Drance on 9/9/10.
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UITableView (JHExtras)

/**
 *  Returns the index path for the row containing the specified vied
 *
 *  @param view A view to test
 *
 *  @return Returns the indexPath of the cell containing the view, nil if no cell contains the view
 */
- (NSIndexPath *)jh_indexPathForRowContainingView:(UIView *)view;

@end
