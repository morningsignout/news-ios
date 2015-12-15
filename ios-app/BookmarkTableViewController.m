//
//  BookmarkTableViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/15/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "BookmarkTableViewController.h"
#import "BookmarkTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "DropdownNavigationController.h"
#import "FullPostViewController.h"
#import <CoreData/CoreData.h>
#import "Post.h"
#import "DataParser.h"
#import "Constants.h"

#define CELL_IDENTIFIER @"bookmarkCell"
static NSString * const SEGUE_IDENTIFIER = @"viewPost";

@interface BookmarkTableViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *attributes;
}
@property (strong, nonatomic) NSMutableArray *bookmarks;
@property (strong, nonatomic) NSMutableArray *coreDataPostIDs;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@end

@implementation BookmarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.view.backgroundColor = [UIColor kCollectionViewBackgroundColor];
    
    // Set up style and attributes
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.firstLineHeadIndent = 10.0;
    style.headIndent = 10;
    style.tailIndent = 0;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    attributes = @{NSParagraphStyleAttributeName : style};
    // Place activity indicator
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
    self.spinner.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 30, 30);
    [self.spinner startAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    DropdownNavigationController *navVC = (DropdownNavigationController *)self.parentViewController.parentViewController;
    navVC.titleLabel.text = @"Bookmarks";
    navVC.titleLabel.textColor = [UIColor kNavTextColor];
    self.navigationController.navigationBarHidden = YES;
    
    // Pull core data content
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Post"];
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        
        // Pull out all the posts IDs previously saved and request for their post content
        self.coreDataPostIDs = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        for (NSManagedObject *bookmark in self.coreDataPostIDs) {
            int postID = [[bookmark valueForKey:@"id"] intValue];
            Post *bookmarkedPost = [DataParser DataForPostID:postID];
            
            BOOL exists = NO;
            // If array already has the post, dont add it to the data source
            for (Post* post in self.bookmarks) {
                if (post.ID == postID) {
                    exists = YES;
                    break;
                }
            }
            
            if (!exists) {
                [self.bookmarks addObject:bookmarkedPost];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.spinner stopAnimating];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)bookmarks {
    if (!_bookmarks) {
        _bookmarks = [NSMutableArray array];
    }
    return _bookmarks;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.bookmarks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookmarkTableViewCell *cell = (BookmarkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    Post *post                          = [self.bookmarks objectAtIndex:indexPath.row];
    cell.titleLabel.text                = post.title;
    cell.excerptLabel.text              = post.excerpt;
    cell.imageView.image                = nil;
    cell.imageView.contentMode          = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds        = YES;
    NSAttributedString *title           = [[NSAttributedString alloc] initWithString:cell.titleLabel.text
                                                                          attributes:attributes];
    NSAttributedString *excerpt         = [[NSAttributedString alloc] initWithString:cell.excerptLabel.text
                                                                          attributes:attributes];
    cell.titleLabel.attributedText      = title;
    cell.excerptLabel.attributedText    = excerpt;
    NSURLRequest *requestLeft = [NSURLRequest requestWithURL:[NSURL URLWithString:post.fullCoverImageURL]];
    [cell.imageView setImageWithURLRequest:requestLeft placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageView.image = image;
    } failure:nil];
    
    return cell;
}

- (IBAction)removeFromBookmarks:(id)sender {
    NSLog(@"remove");
    
    // Get index of cell
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSUInteger cellIndex = indexPath.row;
    
    // Remove from core data and NSMutableArray
    [self.bookmarks removeObjectAtIndex:cellIndex];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *removeThisPost = [self.coreDataPostIDs objectAtIndex:indexPath.row];
    [context deleteObject:removeThisPost];
    [self.coreDataPostIDs removeObject:removeThisPost];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    
    [self.tableView reloadData];
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

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFIER] && [segue.destinationViewController isKindOfClass:[FullPostViewController class]]) {
        FullPostViewController *postVC = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Post *post = [self.bookmarks objectAtIndex:selectedIndexPath.row];
        postVC.post = post;
    }
}


@end
