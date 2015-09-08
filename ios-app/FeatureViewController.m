//
//  FeatureViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/7/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "FeatureViewController.h"
#import "DropdownMenuController.h"
#import "FullPostViewController.h"

#import "DataParser.h"
#import "FeaturedStoryTableViewCell.h"
#import "TiledCellTypeA.h"
#import "TiledCellTypeB.h"
#import "Tile.h"
#import "Post.h"

static NSString * const SEGUE_IDENTIFIER = @"viewPost";

@interface FeatureViewController () <UITableViewDataSource, UITableViewDelegate> {
    int page;
    UITapGestureRecognizer *tapTile;
    Post *seguePost;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) Post *topFeatured;
@end

@implementation FeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
    
    // Be notified when data is done loading
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad) name:@"dataLoaded" object:nil];
    // Be notified when tile is tapped
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tileTapped:) name:@"tileTapped" object:nil];
    
//    [self.refreshControl addTarget:self
//                            action:@selector(getDataForPage:)
//                  forControlEvents:UIControlEventValueChanged];
    
    // Don't allow user to tap in underlying table cell
    self.tableView.allowsSelection = NO;
    self.tableView.delaysContentTouches = YES;
    
    // Start loading data from JSON page 1
    page = 1;
    self.topFeatured = [[DataParser DataForRecentPostsWithPageNumber:1] firstObject];
    self.posts = [self getDataForPage:page];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    seguePost = nil;
    self.navigationController.navigationBarHidden = YES;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Customize your menu programmatically here.
    [self customizeMenu];
}

-(void) customizeMenu {
    // EXAMPLE: To set the menubar background colour programmatically.
    // FYI: There is a bug where the color comes out differently when set programmatically
    // than when set in XCode Interface builder, and I don't know why.
    //[self setMenubarBackground:[UIColor greenColor]];
    
    // Replace menu button with an IonIcon.
    [self.menuButton setTitle:@"Menu" forState:UIControlStateNormal];
    
    //Uncomment to stop drop 'Triangle' from appearing
    //[self dropShapeShouldShowWhenOpen:NO];
    
    //Uncomment to fade to white instead of default (black)
    [self setFadeTintWithColor:[UIColor blackColor]];
    
    //Uncomment for increased fade effect (default is 0.5f)
    //[self setFadeAmountWithAlpha:0.2f];
    
    
}

- (NSArray *)getDataForPage:(int)pageNum {
    int p = pageNum;
    if (pageNum <= 0 || pageNum > self.posts.count) {
        p = 1;
    }
    return [DataParser DataForFeaturedPostsWithPageNumber:p];
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
        
        cell.post = self.topFeatured;
        cell.title.text = cell.post.title;
        
        return cell;
    }
    else {
        // Get post objects
        Post *leftPost = [self.posts objectAtIndex:(indexPath.row - 1) * 2];
        Post *rightPost = [self.posts objectAtIndex:(indexPath.row - 1) * 2 + 1];
        
        int cellType = indexPath.row % 2;
        
        if (cellType == 0) {
            TiledCellTypeA *cellTypeA = [tableView dequeueReusableCellWithIdentifier:@"A" forIndexPath:indexPath];
            
            cellTypeA.tileLeft.post = leftPost;
            cellTypeA.tileLeft.title.text = leftPost.title;
            
            cellTypeA.tileRight.post = rightPost;
            cellTypeA.tileRight.title.text = rightPost.title;
            
            return cellTypeA;
            
        } else if (cellType == 1) {
            TiledCellTypeB *cellTypeB = [tableView dequeueReusableCellWithIdentifier:@"B" forIndexPath:indexPath];
            
            cellTypeB.tileLeft.post = leftPost;
            cellTypeB.tileLeft.title.text = leftPost.title;
            
            cellTypeB.tileRight.post = rightPost;
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


#pragma mark - Gesture Recognizer Methods

- (void)tileTapped:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"tileTapped"])
    {
        seguePost = notification.object;
        NSLog(@"segue");
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
