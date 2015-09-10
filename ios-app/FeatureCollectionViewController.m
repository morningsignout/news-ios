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
    //self.topFeatured = [[DataParser DataForRecentPostsWithPageNumber:1] firstObject];
    NSLog(@"super load done");
    contentType = FEATURED;
    
}

#pragma mark - Accessors

- (BOOL)isFeaturedPage {
    return YES;
}

- (NSArray *)getDataForTypeOfView {
    NSArray *data = [DataParser DataForFeaturedPostsWithPageNumber:self.page];
    self.topFeatured = data.firstObject;
    return [data subarrayWithRange:NSMakeRange(1, data.count - 1)];
}

#pragma mark - UICollectionViewDataSource

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
        
        reusableView.backgroundColor = [UIColor clearColor];
        
        return reusableView;
    }
    
    return nil;
}

#pragma mark - Navigation

- (void)showTopFeatured:(UITapGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self.topFeatured];
}


//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:SEGUE_IDENTIFIER] && [segue.destinationViewController isKindOfClass:[FullPostViewController class]]) {
//        FullPostViewController *postVC = segue.destinationViewController;
//        if ([sender isKindOfClass:[Post class]])
//            postVC.post = sender;
//        else
//            postVC.post = nil;
//    }
//}


@end
