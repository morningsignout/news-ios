//
//  BaseTiledCollectionViewController.h
//  ios-app
//
//  Created by Shannon Phu on 9/9/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "Post.h"

typedef enum ContentType { FEATURED, SEARCH, NONE } ContentType;

@interface BaseTiledCollectionViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout> {
    ContentType contentType;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic) int page;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIActivityIndicatorView *bottomSpinner;

- (BOOL)isFeaturedPage;
- (NSArray *)getDataForTypeOfView;
- (void)refreshPosts:(NSArray *)newPosts;
- (void)loadPosts;
- (Post*)getPostFromPosts:(int)index;
- (void)fetchMoreItems;
- (void)setUpClassesForCollectionViewLayout:(CHTCollectionViewWaterfallLayout *)layout;

@end
