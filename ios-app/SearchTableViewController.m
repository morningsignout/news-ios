//
//  SearchTableViewController.m
//  ios-app
//
//  Created by Brandon Pon on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "SearchTableViewController.h"
#import "DataParser.h"
#import "Post.h"
#import "TiledCell.h"
#import "Tile.h"

@interface SearchTableViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) NSArray * searchArray;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar becomeFirstResponder];
    [self.searchController.searchBar sizeToFit];
    
    // Don't allow user to tap in underlying table cell
    self.tableView.allowsSelection = NO;
    self.tableView.delaysContentTouches = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(_searchArray && self.searchController.active){
        
        int count = (int)[self.searchArray count] / 2;
        NSLog(@"controller active, %ld, %d",[self.searchArray count],count);
        return count;
    }
    NSLog(@"inactive");
    return 0;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    dispatch_queue_t fetchQ = dispatch_queue_create("load search results", NULL);
    dispatch_async(fetchQ, ^{
        NSString *searchString = searchController.searchBar.text;
        [self filterContentForSearchText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
    
            [self.tableView reloadData];
        });
    });
}

//searches while user enters in characters
#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    //[self.searchArray removeAllObjects];
    _searchArray = nil;
    // Filter the array using NSPredicate
    NSLog(@"changed %@",searchText);
    if([searchText length] == 0)
        return;
    _searchArray = [DataParser DataForSearchTerm:searchText InPage:1];
    if(_searchArray)
        [self.tableView reloadData];
    else{
        NSLog(@"loading failed");
    }
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    //filteredCandyArray = [NSMutableArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:predicate]];
}

/*- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //Do search logic here
}*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get post objects
    Post *leftPost = [self.searchArray objectAtIndex:(indexPath.row) * 2];
    Post *rightPost = [self.searchArray objectAtIndex:(indexPath.row) * 2 + 1];
    
    TiledCell *tiledCell;

    tiledCell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];

    
    [self setTileInfo:tiledCell.tileLeft WithPost:leftPost];
    [self setTileInfo:tiledCell.tileRight WithPost:rightPost];
    
    return tiledCell;
}

- (void)setTileInfo:(Tile *)cellTile WithPost:(Post *)post {
    
    //__weak
    Tile *tile = cellTile;
    tile.post = post;
    tile.title.text = post.title;
    NSLog(@"tile post: %@",post.title);
    
    /*NSURLRequest *requestLeft = [NSURLRequest requestWithURL:[NSURL URLWithString:post.thumbnailCoverImageURL]];
    [tile.image setImageWithURLRequest:requestLeft placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        tile.image.image = image;
        tile.image.contentMode = UIViewContentModeScaleAspectFill;
        [tile.image setClipsToBounds:YES];
    } failure:nil];*/
    
}

//hides the keyboard when scrolling
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrolled");
    [self.searchController.searchBar resignFirstResponder];
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
