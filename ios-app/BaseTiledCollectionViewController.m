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
#import "DropdownNavigationController.h"
#import <CoreData/CoreData.h>
#import "CDPost.h"
#import "AppDelegate.h"

#define CELL_IDENTIFIER @"TileCell"
#define CELL_IDENTIFIER_B @"TileCell2"
#define CELL_IDENTIFIER_C @"TileCell3"
#define HEADER_IDENTIFIER @"TopFeatured"
#define LOADING_CELL_IDENTIFIER @"Loading"

static NSString * const SEGUE_IDENTIFIER = @"viewPost";

@interface BaseTiledCollectionViewController () <NSFetchedResultsControllerDelegate> {
    Post *seguePost;
    CGSize tileHeight;
}
@property (nonatomic, strong) NSArray *cellSizes;
//@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIView *bottomSpinnerBackground;
@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation BaseTiledCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    contentType = NONE;
    
    _delegate = [[UIApplication sharedApplication] delegate];
    
    // Start loading data from JSON page 1
    self.page = 1;
    
    // Perform fetch
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

    // Download new posts
    [self loadPosts];
    
    tileHeight = CGSizeMake(1, 1.5);
    
    //[self.collectionView setContentInset:UIEdgeInsetsMake(62,0,0,0)];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0,0,75,0)];
    [self.view bringSubviewToFront:self.spinner];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    seguePost = nil;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    //self.navigationController.navigationBarHidden = YES;
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

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController)
        return _fetchedResultsController;
    
    /* Initialize the fetchedResultsController */
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDPost"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:self.delegate.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    frc.delegate = self;
    self.fetchedResultsController = frc;
    
    return _fetchedResultsController;
}

- (void)loadPosts {
    
    [self.spinner startAnimating];
    dispatch_queue_t q = dispatch_queue_create("refresh latest", NULL);
    dispatch_async(q, ^{
    
        NSArray * refreshPosts = [self getDataForPage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshPosts:refreshPosts];
            [self.spinner stopAnimating];
            NSLog(@"Reloaded new posts");
        });
    });

}

- (NSArray *)getDataForPage {
    if (self.page <= 0) {
        return nil;
    }
    NSArray *data = [self getDataForTypeOfView];
    return data;
}

- (NSArray *)getDataForTypeOfView {
    return nil;
}

- (void)refreshPosts:(NSArray *)newPosts {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Load into core data
        for (Post *post in newPosts)
            [CDPost postWithPost:post inManagedObjectContext:self.delegate.managedObjectContext];
        [self.delegate saveContext];
        self.collectionView.userInteractionEnabled = YES;
        [self.spinner stopAnimating];
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
        
        // Set up collection view UI
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
        
        [self setUpClassesForCollectionViewLayout:layout];
    }
    return _collectionView;
}

- (void)setUpClassesForCollectionViewLayout:(CHTCollectionViewWaterfallLayout *)layout {
    // Tell collection view what classes to use
    [_collectionView registerClass:[TileCollectionViewCellA class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [_collectionView registerClass:[TileCollectionViewCellB class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER_B];
    [_collectionView registerClass:[TileCollectionViewCellC class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER_C];
    
    // Deal with if feature view showing
    if ([self isFeaturedPage]) {
        layout.headerHeight = self.view.frame.size.height / 1.5;
        [_collectionView registerClass:[FeaturedTileCollectionViewCell class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
    }

}

- (BOOL)isFeaturedPage {
    return NO;
}

- (Post *)getPostFromPosts:(int)index {
    if (self.fetchedResultsController.fetchedObjects.count == 0)
        return nil;
    CDPost *cPost = [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
    Post *post = [Post postFromCDPost:cPost];
    return post;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self getEndOfPosts] && indexPath.item == self.fetchedResultsController.fetchedObjects.count - 3) {
        [self.spinner startAnimating];
        NSLog(@"still fetching");
        [self fetchMoreItems];
    }
    

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

    return nil;
}

- (void)fetchMoreItems {
    NSLog(@"FETCHING MORE ITEMS");
    if (self.page > 0) {
        self.spinner.hidden = YES;
    } else {
        [self.spinner startAnimating];
    }

    // Get next page of data
    __block NSArray *newData;
    dispatch_queue_t q = dispatch_queue_create("load more posts", NULL);
    dispatch_async(q, ^{
        self.page++;
        NSLog(@"now on page %d of data", self.page);
        newData = [self getDataForPage];
        if([newData count] < 28){
            [self setEndOfPosts:true];
            NSLog(@"end of posts reached");
        }

        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self refreshPosts:newData];
            [self showNoMoreContent];
        });
    
    });
    
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
    
    CDPost *cPost = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.item];
    Post *post = [Post postFromCDPost:cPost];
    
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
    CDPost *cPost = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.item];
    Post *post = [Post postFromCDPost:cPost];
    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:post];
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

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSNumber *end = [NSNumber numberWithBool:[self getEndOfPosts]];
//    if(end)
//        return;
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height - self.view.frame.size.height / 3) {
        // we are at the end
        [self.bottomSpinner startAnimating];
        [self performSelector:@selector(showNoMoreContent) withObject:nil afterDelay:4];
    }
}

- (void)showNoMoreContent {
    [self.bottomSpinner stopAnimating];
    self.bottomSpinnerBackground.hidden = YES;
}

- (UIActivityIndicatorView *)bottomSpinner {
    if (!_bottomSpinner) {
        _bottomSpinnerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 75, self.view.frame.size.width, 75)];
        _bottomSpinnerBackground.backgroundColor = [UIColor kBottomSpinnerBackgroundColor];
        [self.view addSubview:_bottomSpinnerBackground];
        
        _bottomSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _bottomSpinner.frame = CGRectMake(self.view.center.x - 15, self.view.frame.size.height - 50, 30, 30);
        [self.view addSubview:_bottomSpinner];
    }
    self.bottomSpinnerBackground.hidden = NO;
    return _bottomSpinner;
}

- (void) setEndOfPosts:(bool)set{
    return;
}

- (BOOL)getEndOfPosts{
    return nil;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications,
    // so tell the table view to process all updates.
    [self.collectionView reloadData];
}

@end
