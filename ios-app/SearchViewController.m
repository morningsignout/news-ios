//
//  SearchTableViewController.m
//  ios-app
//
//  Created by Brandon Pon on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "SearchViewController.h"
#import "BaseTiledCollectionViewController.h"
#import "DataParser.h"
#import "Post.h"
#import "NavDropdownController.h"
#import "FadeSegue.h"

@interface SearchViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSString *searchTerm;

@end

@implementation SearchViewController

int flush = 0;

- (void)viewDidLoad {
    contentType = SEARCH;
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.definesPresentationContext = YES;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    //[self.searchController.searchBar becomeFirstResponder];
    //self.collectionView. = self.searchController.searchBar;

    [self.searchController.searchBar sizeToFit];
    [self.view addSubview:self.searchController.searchBar];

}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewdidappear");
    [self.searchController setActive:YES];
    [self.searchController.searchBar becomeFirstResponder];
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

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.searchTerm = searchController.searchBar.text;
    
    dispatch_queue_t fetchQ = dispatch_queue_create("load search results", NULL);
    dispatch_async(fetchQ, ^{
        //[self filterContentForSearchText:self.searchTerm scope:searchController.searchBar.selectedScopeButtonIndex];
        //[self refreshPosts:[DataParser DataForSearchTerm:self.searchTerm InPage:self.page]];
        //NSLog(@"changed %@",self.searchTerm);
        
        if([self.searchTerm length] == 0)
            return;
        flush++;
        int yesFlush = flush;
        NSArray * refreshPosts = [DataParser DataForSearchTerm:self.searchTerm InPage:self.page];
        
        if(flush == yesFlush){
            flush = 0;
            [self refreshPosts:refreshPosts];
        }
        else{
            refreshPosts = nil;
        }
        
    });
}

//#pragma mark Content Filtering
//
////searches while user enters in characters
//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope {
//    // Update the filtered array based on the search text and scope.
//    // Remove all objects from the filtered search array
//    
//    
//    NSLog(@"changed %@",searchText);
//    
//    if([searchText length] == 0)
//        return;
//    
//    
//    self.searchTerm = searchText;
//    
//    //dispatch_queue_t fetchQ = dispatch_queue_create("load search results", NULL);
//    //dispatch_async(fetchQ, ^{
//        [self refreshPosts:[DataParser DataForSearchTerm:searchText InPage:self.page]];
//    //});
//    
//}

/*
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // to limit network activity, reload half a second after last key press.
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshPosts:) object:nil];
    [self performSelector:@selector(refreshPosts:) withObject:nil afterDelay:0.5];
}*/

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
