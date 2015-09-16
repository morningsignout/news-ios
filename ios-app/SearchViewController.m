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

@interface SearchViewController () <UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) NSArray *all;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSArray *current;
@property (nonatomic) bool end;
@property (nonatomic) NSInteger flush;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    contentType = SEARCH;
    [super viewDidLoad];
    
    self.end = false;
    self.flush = 0;
    
    _all = nil;
    _tags = nil;
    _current = nil;
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
    //self.searchController.searchBar.frame = CGRectMake(0, marginFromTop, self.view.bounds.size.width, self.searchController.searchBar.bounds.size.height);
    self.definesPresentationContext = YES;
    
    // Set up search segmented control
    NSArray *itemArray = [NSArray arrayWithObjects: @"All", @"Tags", @"Categories", nil];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmentedControl.frame = CGRectMake((self.view.frame.size.width-320)/2, 50, 320, 20);
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [self.segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    
    // Set up segmented control background view
    CGFloat marginSegmentedBackground = 20;
    UIView *segmentedControlBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.frame.origin.y - marginSegmentedBackground / 2, self.view.frame.size.width, self.segmentedControl.bounds.size.height + marginSegmentedBackground)];
    segmentedControlBackground.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    [self.view addSubview:segmentedControlBackground];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.view addSubview:self.searchController.searchBar];
    [self.view addSubview:self.segmentedControl];
    self.navigationController.navigationBarHidden = YES;
    //[self.searchController setActive:YES];
    NSLog(@"set active");
    DropdownNavigationController *navVC = (DropdownNavigationController *)self.parentViewController.parentViewController;
    navVC.titleLabel.text = @"Search";
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did apper");
    [self.searchController setActive:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.searchController.active = NO;
    [self.searchController.searchBar removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView data source

- (NSArray *)getDataForTypeOfView {
    NSLog(@"getting data for view");
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
        
        self.flush++;
        NSArray* refreshPosts;
        int yesFlush = (int)self.flush;
        if(self.segmentedControl.selectedSegmentIndex == 0)
            refreshPosts = [DataParser DataForSearchTerm:self.searchTerm InPage:self.page];
        else if(self.segmentedControl.selectedSegmentIndex == 1)
            refreshPosts = [DataParser DataForPostWithTag:self.searchTerm AndPageNumber:self.page];
        
        if(self.flush == yesFlush){
            self.flush = 0;
            if(self.segmentedControl.selectedSegmentIndex == 0)
                self.all = refreshPosts;
            else if(self.segmentedControl.selectedSegmentIndex == 1)
                self.tags = refreshPosts;
            [self refreshPosts:refreshPosts];
            
        }
        else{
            refreshPosts = nil;
        }
        
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    //[self.collectionView setContentOffset:CGPointZero animated:YES];
}

- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"presenting");
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

- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0){
        // segment "all"
        [self refreshPosts:_all];
    }
    else if(segment.selectedSegmentIndex == 1){
        // segment "tags"
        [self refreshPosts:_tags];
    }
    else if(segment.selectedSegmentIndex == 2){
        
    }
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
