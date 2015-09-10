//
//  SearchTableViewController.m
//  ios-app
//
//  Created by Brandon Pon on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "SearchTableViewController.h"
#import "BaseTiledCollectionViewController.h"
#import "DataParser.h"
#import "Post.h"
#import "NavDropdownController.h"

@interface SearchTableViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSString *searchTerm;

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    contentType = SEARCH;
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.definesPresentationContext = YES;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.searchBar.delegate = self;
//    [self.searchController.searchBar becomeFirstResponder];
//
//    [self.searchController.searchBar sizeToFit];
//    [self.view addSubview:self.searchController.searchBar];
//    self.searchController.searchBar.frame = CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100);

    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    
    [self.searchBar sizeToFit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView data source

- (NSArray *)getDataForTypeOfView {
    if (!_searchTerm || [_searchTerm isEqualToString:@""]) {
        return nil;
    }
    return [DataParser DataForSearchTerm:self.searchTerm InPage:self.page];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    if (!_searchTerm || [_searchTerm isEqualToString:@""]) {
//        return;
//    }
    
    self.searchTerm = searchController.searchBar.text;
    
    dispatch_queue_t fetchQ = dispatch_queue_create("load search results", NULL);
    dispatch_async(fetchQ, ^{
        [self filterContentForSearchText:self.searchTerm scope:searchController.searchBar.selectedScopeButtonIndex];
        [self refreshPosts:[DataParser DataForSearchTerm:self.searchTerm InPage:self.page]];
        
    });
}

#pragma mark Content Filtering

//searches while user enters in characters
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    
    
    NSLog(@"changed %@",searchText);
    
    if([searchText length] == 0)
        return;
    
    
    self.searchTerm = searchText;
    
    //dispatch_queue_t fetchQ = dispatch_queue_create("load search results", NULL);
    //dispatch_async(fetchQ, ^{
        [self refreshPosts:[DataParser DataForSearchTerm:searchText InPage:self.page]];
    //});
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // to limit network activity, reload half a second after last key press.
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshPosts:) object:nil];
    [self performSelector:@selector(refreshPosts:) withObject:nil afterDelay:0.5];
}

/*- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //Do search logic here
}*/

//hides the keyboard when scrolling
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrolled");
    [self.searchController.searchBar resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
