//
//  FeatureCollectionViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "FeatureCollectionViewController.h"
#import "FeaturedTileCollectionViewCell.h"
#import "DataParser.h"
#import <UIImageView+AFNetworking.h>
#import "FullPostViewController.h"

#define HEADER_IDENTIFIER @"TopFeatured"
static NSString * const SEGUE_IDENTIFIER = @"viewPost";
static CGFloat marginFromTop = 50.0f;

@interface FeatureCollectionViewController ()
@property (strong, nonatomic) Post *topFeatured;
@end

@implementation FeatureCollectionViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topFeatured = [[DataParser DataForRecentPostsWithPageNumber:1] firstObject];
}

#pragma mark - Accessors

//- (UICollectionView *)collectionView {
//    if (!_collectionView) {
//        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
//        
//        layout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
//        layout.headerHeight = self.view.frame.size.height / 1.5;
//        // layout.footerHeight = 10;
//        layout.minimumColumnSpacing = 10.0f;
//        layout.minimumInteritemSpacing = 10.0f;
//        
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, marginFromTop, self.view.bounds.size.width, self.view.bounds.size.height - marginFromTop) collectionViewLayout:layout];
//        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        _collectionView.dataSource = self;
//        _collectionView.delegate = self;
//        _collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
//        [_collectionView registerClass:[TileCollectionViewCellA class]
//            forCellWithReuseIdentifier:CELL_IDENTIFIER];
//        [_collectionView registerClass:[TileCollectionViewCellB class]
//            forCellWithReuseIdentifier:CELL_IDENTIFIER_B];
//        [_collectionView registerClass:[TileCollectionViewCellC class]
//            forCellWithReuseIdentifier:CELL_IDENTIFIER_C];
//        
//        [_collectionView registerClass:[FeaturedTileCollectionViewCell class]
//            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
//                   withReuseIdentifier:HEADER_IDENTIFIER];
//    }
//    return _collectionView;
//}

- (BOOL)isFeaturedPage {
    return YES;
}

#pragma mark - UICollectionViewDataSource

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.item % 3 == 0) {
//        TileCollectionViewCellA *cellA = (TileCollectionViewCellA *)[self setTileOfClass:@"TileCollectionViewCellA" WithIndexPath:indexPath];
//        return cellA;
//        
//    } else if (indexPath.item % 3 == 1) {
//        TileCollectionViewCellB *cellB = (TileCollectionViewCellB *)[self setTileOfClass:@"TileCollectionViewCellB" WithIndexPath:indexPath];
//        return cellB;
//    } else {
//        TileCollectionViewCellC *cellC = (TileCollectionViewCellC *)[self setTileOfClass:@"TileCollectionViewCellC" WithIndexPath:indexPath];
//        return cellC;
//    }
//    
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        __weak FeaturedTileCollectionViewCell *reusableView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_IDENTIFIER forIndexPath:indexPath];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(showTopFeatured:)];
        
        [reusableView addGestureRecognizer:tap];
        
        reusableView.title.text = self.topFeatured.title;
        reusableView.excerpt.text = self.topFeatured.excerpt;

        
        NSURLRequest *requestLeft = [NSURLRequest requestWithURL:[NSURL URLWithString:self.topFeatured.fullCoverImageURL]];
        [reusableView.imageView setImageWithURLRequest:requestLeft placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            reusableView.imageView.image = image;
        } failure:nil];
        
        reusableView.backgroundColor = [UIColor whiteColor];
        
        return reusableView;
    }
    
    return nil;
}

- (void)showTopFeatured:(UITapGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self.topFeatured];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFIER] && [segue.destinationViewController isKindOfClass:[FullPostViewController class]]) {
        FullPostViewController *postVC = segue.destinationViewController;
        if ([sender isKindOfClass:[Post class]])
            postVC.post = sender;
        else
            postVC.post = nil;
    }
}


@end
