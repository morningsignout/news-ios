//
//  BaseTiledCollectionViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/9/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "BaseTiledCollectionViewController.h"
#import "TileCollectionViewCellA.h"
#import "TileCollectionViewCellB.h"
#import "DataParser.h"
#import <UIImageView+AFNetworking.h>
#import "FullPostViewController.h"
#import "BaseTileCollectionViewCell.h"
#import "TileCollectionViewCellC.h"
#import "FeaturedTileCollectionViewCell.h"

#define CELL_IDENTIFIER @"TileCell"
#define CELL_IDENTIFIER_B @"TileCell2"
#define CELL_IDENTIFIER_C @"TileCell3"
#define HEADER_IDENTIFIER @"TopFeatured"

static NSString * const SEGUE_IDENTIFIER = @"viewPost";
//static CGFloat marginFromTop = 50.0f;
static CGFloat marginFromTop = 0;

@interface BaseTiledCollectionViewController () {
    Post *seguePost;
    CGSize tileHeight;
}
@property (nonatomic, strong) NSArray *cellSizes;
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation BaseTiledCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    contentType = NONE;
    
    // Start loading data from JSON page 1
    self.page = 1;
    
    //self.posts = [self getDataForPage:self.page];
    NSLog(@"begin loading");
    [self loadPosts];
    NSLog(@"done loading");
    
    tileHeight = CGSizeMake(1, 1.5);
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    //[self.collectionView setRefreshControl:refreshControl];
    [self.collectionView addSubview:refreshControl];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(refreshControl.frame.size.height,0,0,0)];
}

- (void)viewWillAppear:(BOOL)animated {
    seguePost = nil;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)loadPosts {
    
    [self.spinner startAnimating];
    dispatch_queue_t q = dispatch_queue_create("refresh latest", NULL);
    dispatch_async(q, ^{
        
        NSArray * refreshPosts = [self getDataForPage:self.page];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            [self refreshPosts:refreshPosts];
        });
    });

}

- (NSArray *)getDataForPage:(int)pageNum {
    int p = pageNum;
    if (pageNum <= 0 || pageNum > self.posts.count) {
        p = 1;
    }
    NSArray *data = [self getDataForTypeOfView];
    return data;
}

- (NSArray *)getDataForTypeOfView {
    return nil;
}

- (void)refreshPosts:(NSArray *)newPosts {
    self.posts = newPosts;
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
        [self.collectionView reloadData];
        NSLog(@"reloaded new posts");
    });
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        layout.minimumColumnSpacing = 10.0f;
        layout.minimumInteritemSpacing = 10.0f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, marginFromTop, self.view.bounds.size.width, self.view.bounds.size.height - marginFromTop) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];//colorWithWhite:0.9 alpha:0.7];
        [_collectionView registerClass:[TileCollectionViewCellA class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[TileCollectionViewCellB class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER_B];
        [_collectionView registerClass:[TileCollectionViewCellC class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER_C];
        
        if ([self isFeaturedPage]) {
            layout.headerHeight = self.view.frame.size.height / 1.5;
            [_collectionView registerClass:[FeaturedTileCollectionViewCell class]
                forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                       withReuseIdentifier:HEADER_IDENTIFIER];
        }
    }
    return _collectionView;
}

- (BOOL)isFeaturedPage {
    return NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item % 3 == 0) {
        TileCollectionViewCellA *cellA = (TileCollectionViewCellA *)[self setTileOfClass:@"TileCollectionViewCellA" WithIndexPath:indexPath];
        return cellA;
        
    } else if (indexPath.item % 3 == 1) {
        TileCollectionViewCellB *cellB = (TileCollectionViewCellB *)[self setTileOfClass:@"TileCollectionViewCellB" WithIndexPath:indexPath];
        return cellB;
    } else {
        TileCollectionViewCellC *cellC = (TileCollectionViewCellC *)[self setTileOfClass:@"TileCollectionViewCellC" WithIndexPath:indexPath];
        return cellC;
    }
    
}

- (BaseTileCollectionViewCell *)setTileOfClass:(NSString *)cellClass WithIndexPath:(NSIndexPath *)indexPath {
    
    __weak BaseTileCollectionViewCell *cell;
    
    
    if ([cellClass isEqualToString:@"TileCollectionViewCellA"]) {
        cell = (TileCollectionViewCellA *)[self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    } else if ([cellClass isEqualToString:@"TileCollectionViewCellB"]) {
        cell = (TileCollectionViewCellB *)[self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER_B forIndexPath:indexPath];
    } else if ([cellClass isEqualToString:@"TileCollectionViewCellC"]) {
        cell = (TileCollectionViewCellC *)[self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER_C forIndexPath:indexPath];
    }
    
    Post *post = [self.posts objectAtIndex:indexPath.item];
    
    NSURLRequest *requestLeft = [NSURLRequest requestWithURL:[NSURL URLWithString:post.thumbnailCoverImageURL]];
    
    cell.title.text = post.title;
    cell.imageView.image = nil;
    [cell.imageView setImageWithURLRequest:requestLeft placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageView.image = image;
    } failure:nil];
    
    return cell;
    
}

#pragma mark - Navigation
 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:[self.posts objectAtIndex:indexPath.item]];
}

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

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return tileHeight;
}

@end
