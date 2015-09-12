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
#import "DropdownNavigationController.h"

#define HEADER_IDENTIFIER @"TopFeatured"
static NSString * const SEGUE_IDENTIFIER = @"viewPost";

@interface FeatureCollectionViewController ()
@property (strong, nonatomic) Post *topFeatured;
@end

@implementation FeatureCollectionViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.topFeatured = [[DataParser DataForRecentPostsWithPageNumber:1] firstObject];
    self.topFeatured = [super getPostFromPosts:0];
    NSLog(@"super load done");
    contentType = FEATURED;
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self.collectionView addSubview:refreshControl];
    
}

- (void)viewWillAppear:(BOOL)animated {
    DropdownNavigationController *navVC = (DropdownNavigationController *)self.parentViewController.parentViewController;
    navVC.titleLabel.text = @"Featured";
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Accessors

- (BOOL)isFeaturedPage {
    return YES;
}

- (NSArray *)getDataForTypeOfView {
    NSArray *data = [DataParser DataForFeaturedPostsWithPageNumber:self.page];
    self.topFeatured = data.firstObject;
    NSMutableArray *smallerTileData = [NSMutableArray arrayWithArray:[data subarrayWithRange:NSMakeRange(1, data.count - 1)]];
    [smallerTileData addObject:[smallerTileData objectAtIndex:rand() % (smallerTileData.count - 1)]];
    return smallerTileData;
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

- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    
    dispatch_queue_t q = dispatch_queue_create("refresh latest", NULL);
    dispatch_async(q, ^{
        
        NSArray * refreshPosts = [self getDataForTypeOfView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIRefreshControl *)sender endRefreshing];
            
            [self refreshPosts:refreshPosts];
        });
    });
    
    
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
