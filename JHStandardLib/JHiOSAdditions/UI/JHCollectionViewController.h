//
//  JHCollectionViewController.h
//  TheLifeYouWantTour
//
//  Created by Josh Hudnall on 5/13/14.
//  Copyright (c) 2014 fastPXL. All rights reserved.
//

#import "JHViewController.h"

@interface JHCollectionViewController : JHViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, readonly) UICollectionViewLayout *collectionViewLayout;
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout;

- (void)showMessage:(NSString *)message;
- (void)hideMessage;

@end
