//
//  JHCollectionViewController.m
//  TheLifeYouWantTour
//
//  Created by Josh Hudnall on 5/13/14.
//  Copyright (c) 2014 fastPXL. All rights reserved.
//

#import "JHCollectionViewController.h"

@interface JHCollectionViewController ()

@property (nonatomic) UILabel *messageLabel;

@end

@implementation JHCollectionViewController
@synthesize messageLabel = _messageLabel;

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [self init];
    if (self) {
        _collectionViewLayout = layout;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Only create a new collectionView if not loading from an XIB
    if ( ! _collectionView || ! _collectionView.superview) {
        if ( ! _collectionViewLayout) {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            [flowLayout setMinimumInteritemSpacing:0.f];
            [flowLayout setMinimumLineSpacing:0.f];
            [flowLayout setSectionInset:UIEdgeInsetsZero];
            
            _collectionViewLayout = flowLayout;
        }
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionViewLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.opaque = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _collectionView.scrollsToTop = YES;
        
        [self.view addSubview:_collectionView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (_clearsSelectionOnViewWillAppear) {
		[_collectionView.indexPathsForSelectedItems enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
        }];
	}
}

// UICollectionViewController sets itself as the delegate/dataSource if none is already set
// this mimics that behavior
- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    
    _collectionView.delegate = _collectionView.delegate ?: self;
    _collectionView.dataSource = _collectionView.dataSource ?: self;
}

- (void)showMessage:(NSString *)message {
    if ( ! _messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont boldSystemFontOfSize:18];
        _messageLabel.textColor = [UIColor grayColor];
        _messageLabel.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_messageLabel];
    }
    
    _messageLabel.text = message;
    
    [_messageLabel sizeToFit];
    _messageLabel.frame = CGRectMake((self.view.frame.size.width - _messageLabel.frame.size.width) / 2,
                                     (self.view.frame.size.height - _messageLabel.frame.size.height) / 2,
                                     _messageLabel.frame.size.width,
                                     _messageLabel.frame.size.height);
    
    _collectionView.hidden = YES;
    _messageLabel.hidden = NO;
}

- (void)hideMessage {
    _collectionView.hidden = NO;
    _messageLabel.hidden = YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
