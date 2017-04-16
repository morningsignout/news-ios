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
#import "DropdownNavigationController.h"
#include "Constants.h"

@interface SearchViewController () <UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSString *searchTerm;
@property (nonatomic) bool end;
@property (nonatomic) NSInteger flush;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    contentType = SEARCH;
    [super viewDidLoad];
    
    self.end = false;
    self.flush = 0;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(70,0,75,0)];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.barTintColor = [UIColor kNavBackgroundColor];
    self.definesPresentationContext = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    [self.view addSubview:self.searchController.searchBar];
    self.navigationController.navigationBarHidden = YES;

    DropdownNavigationController *navVC = (DropdownNavigationController *)self.parentViewController.parentViewController;
    navVC.titleLabel.text = @"Search";
    navVC.titleLabel.textColor = [UIColor kNavTextColor];
    navVC.navigationItem.title = @"Search";
}

- (void)viewDidAppear:(BOOL)animated{
    [self.searchController setActive:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.searchController.searchBar resignFirstResponder];

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
        
        if([self.searchTerm length] == 0)
            return;
        
        NSArray* refreshPosts = [DataParser DataForSearchTerm:self.searchTerm InPage:self.page];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshPosts:refreshPosts];
            [self.collectionView reloadData];
            [self endLongSpinner];
        });
        
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self startSpinnerWithMessage:@"Searching..."];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self endLongSpinner];
}

- (void)didPresentSearchController:(UISearchController *)searchController{
    [searchController.searchBar becomeFirstResponder];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    [self.searchController.searchBar resignFirstResponder];
}

- (void) setEndOfPosts:(bool)set{
    self.end = set;
}

- (BOOL) getEndOfPosts{
    return self.end;
}

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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
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

- (BOOL)isSearch
{
    return YES;
}

- (NSString *)searchText
{
    return self.searchTerm;
}

@end
