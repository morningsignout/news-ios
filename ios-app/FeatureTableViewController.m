//
//  FeatureTableViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/4/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

// Note: DataParser will return 28 posts at a time.

#import "DataParser.h"
#import "FeatureTableViewController.h"
#import "FeaturedStoryTableViewCell.h"
#import "TiledCell.h"
#import "Tile.h"
#import "Post.h"
#import "FullPostViewController.h"
#import "NavDropdownController.h"
#import <UIImageView+AFNetworking.h>

static NSString * const SEGUE_IDENTIFIER = @"viewPost";

@interface FeatureTableViewController ()<UIGestureRecognizerDelegate> {
    int page;
    UITapGestureRecognizer *tapTile;
    Post *seguePost;
}
@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) Post *topFeatured;
@end

@implementation FeatureTableViewController

@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Be notified when data is done loading
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad) name:@"dataLoaded" object:nil];
    // Be notified when tile is tapped
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tileTapped:) name:@"tileTapped" object:nil];
    
    [self.refreshControl addTarget:self
                            action:@selector(getDataForPage:)
                  forControlEvents:UIControlEventValueChanged];
    
    // Don't allow user to tap in underlying table cell
    self.tableView.allowsSelection = NO;
    self.tableView.delaysContentTouches = YES;
    
    // Start loading data from JSON page 1
    page = 1;
    self.topFeatured = [[DataParser DataForRecentPostsWithPageNumber:1] firstObject];
    self.posts = [self getDataForPage:page];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    seguePost = nil;
    self.navigationController.navigationBarHidden = YES;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Customize your menubar programmatically here.
    NavDropdownController* menu = (NavDropdownController *) [self parentViewController];
    [menu setMenubarTitle:@"Features"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getDataForPage:(int)pageNum {
    int p = pageNum;
    if (pageNum <= 0 || pageNum > self.posts.count) {
        p = 1;
    }
    return [DataParser DataForFeaturedPostsWithPageNumber:p];
}

- (void)dataDidLoad {
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (int)[self.posts count] / 2 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        __weak FeaturedStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feature" forIndexPath:indexPath];
        
        cell.post = self.topFeatured;
        cell.title.text = cell.post.title;
        
        NSURLRequest *requestLeft = [NSURLRequest requestWithURL:[NSURL URLWithString:cell.post.fullCoverImageURL]];
        [cell.image setImageWithURLRequest:requestLeft placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            cell.image.image = image;
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.imageView setClipsToBounds:YES];
        } failure:nil];
        
        return cell;
    }
    else {
        // Get post objects
        Post *leftPost = [self.posts objectAtIndex:(indexPath.row - 1) * 2];
        Post *rightPost = [self.posts objectAtIndex:(indexPath.row - 1) * 2 + 1];
        
        int cellType = indexPath.row % 2;
        
        TiledCell *tiledCell;

        if (cellType == 0) {
            tiledCell = [tableView dequeueReusableCellWithIdentifier:@"A" forIndexPath:indexPath];
        } else if (cellType == 1) {
            tiledCell = [tableView dequeueReusableCellWithIdentifier:@"B" forIndexPath:indexPath];
        }
        
        [self setTileInfo:tiledCell.tileLeft WithPost:leftPost];
        [self setTileInfo:tiledCell.tileRight WithPost:rightPost];
        
        return tiledCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.view.frame.size.height / 1.5;
    }
    return self.view.frame.size.height / 3;
}

- (void)setTileInfo:(Tile *)cellTile WithPost:(Post *)post {
    
    __weak Tile *tile = cellTile;
    tile.post = post;
    tile.title.text = post.title;
    
    NSURLRequest *requestLeft = [NSURLRequest requestWithURL:[NSURL URLWithString:post.thumbnailCoverImageURL]];
    [tile.image setImageWithURLRequest:requestLeft placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        tile.image.image = image;
        tile.image.contentMode = UIViewContentModeScaleAspectFill;
        [tile.image setClipsToBounds:YES];
    } failure:nil];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Gesture Recognizer Methods

- (void)tileTapped:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"tileTapped"])
    {
        seguePost = notification.object;
        [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFIER] && [segue.destinationViewController isKindOfClass:[FullPostViewController class]]) {
        FullPostViewController *postVC = segue.destinationViewController;
        if (seguePost) {
            postVC.post = seguePost;
        }
    }
    
}


@end
