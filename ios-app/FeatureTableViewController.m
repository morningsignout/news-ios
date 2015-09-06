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
#import "TiledCellTypeA.h"
#import "TiledCellTypeB.h"
#import "Tile.h"
#import "Post.h"

@interface FeatureTableViewController () {
    int page;
}
@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *posts;
@end

@implementation FeatureTableViewController

@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad) name:@"dataLoaded" object:nil];
    [self.refreshControl addTarget:self
                            action:@selector(getDataForPage:)
                  forControlEvents:UIControlEventValueChanged];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    page = 1;
    self.posts = [self getDataForPage:page];
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
        FeaturedStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feature" forIndexPath:indexPath];
        return cell;
    }
    else {
        // Get post objects
        Post *leftPost = [self.posts objectAtIndex:(indexPath.row - 1) * 2];
        Post *rightPost = [self.posts objectAtIndex:(indexPath.row - 1) * 2 + 1];
        
        int cellType = indexPath.row % 2;

        if (cellType == 0) {
            TiledCellTypeA *cellTypeA = [tableView dequeueReusableCellWithIdentifier:@"A" forIndexPath:indexPath];
            
            if (!cellTypeA) {
                cellTypeA = [[TiledCellTypeA alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"A"];
            }
            
            cellTypeA.tileLeft.title.text = leftPost.title;
            cellTypeA.tileRight.title.text = rightPost.title;
            
            return cellTypeA;
            
        } else if (cellType == 1) {
            TiledCellTypeB *cellTypeB = [tableView dequeueReusableCellWithIdentifier:@"B" forIndexPath:indexPath];

            if (!cellTypeB) {
                cellTypeB = [[TiledCellTypeB alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"B"];
            }
            
            cellTypeB.tileLeft.title.text = leftPost.title;
            cellTypeB.tileRight.title.text = rightPost.title;
            
            return cellTypeB;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.view.frame.size.height / 1.5;
    }
    return self.view.frame.size.height / 4;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
