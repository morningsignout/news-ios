//
//  CommentsViewController.m
//  ios-app
//
//  Created by Vincent Chau on 11/19/15.
//  Edited by Siddharth Verma on 12/17/15
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CommentsViewController.h"
#import <IonIcons.h>
#import "Comment.h"
#import <AFNetworking.h>
#import "FullPostViewController.h"
#import "Post.h"
#import "MBProgressHUD.h"

@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIWebViewDelegate> {
    NSString *commentCode;
    NSString *accessToken;
    BOOL loggedIn;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) UITextField *commentTextField;
@property (strong, nonatomic) UIWebView *commentWebView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.comments count] > 0) {
        return [self.comments count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"CellIdentifier";
    UITableViewCell *cell         = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.comments count] == 0) {
        cell.textLabel.text = @"There are no comments to show.";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:15.0];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    Comment *currentComment = self.comments[indexPath.row];
    
    cell.textLabel.text = currentComment.message;
    NSString *commentAuthor = [NSString stringWithFormat:@"posted by %@ on %@", currentComment.senderName, currentComment.date];
    cell.detailTextLabel.text = commentAuthor;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:14.0];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)loadView
{
    // Set up view
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGRect viewSize = CGRectMake(0, screenFrame.size.height * 0.35, screenFrame.size.width, screenFrame.size.height * 0.65);
    CGRect tableViewSize = CGRectMake(0, screenFrame.size.height * 0.5, screenFrame.size.width, screenFrame.size.height / 2.0);
    self.view = [[UIView alloc] initWithFrame:screenFrame];

    // Tableview setup
    self.tableView = [[UITableView alloc] initWithFrame:tableViewSize
                                                  style:UITableViewStylePlain];
    self.tableView.tableFooterView           = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    [self.view addSubview:self.tableView];
    
    // Textfield and Submit setup
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0,viewSize.origin.y,viewSize.size.width,viewSize.size.height - tableViewSize.size.height)];
    blankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blankView];
    
    self.commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewSize.size.width * 0.04,viewSize.origin.y + 15,viewSize.size.width * 0.75,blankView.frame.size.height * 0.4)];
    self.commentTextField.delegate = self;
    self.commentTextField.placeholder = @"Post a comment...";
    [self.commentTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:self.commentTextField];
    
    // Post button set up
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postButton.frame = CGRectMake(viewSize.size.width * 0.83, viewSize.origin.y + 20, 50, 30);
    
    [postButton         addTarget:self
                           action:@selector(postComment)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [postButton          setTitle:@"Post"
                         forState:UIControlStateNormal];
    
    [postButton     setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0]
                         forState:UIControlStateNormal];
    
    [postButton     setTitleColor:[UIColor grayColor]
                         forState:UIControlStateHighlighted];
   
    [self.view addSubview:postButton];
    
    // Set up invisible button for user exit
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0,0, screenFrame.size.width, screenFrame.size.height * 0.35);
    closeButton.backgroundColor = [UIColor clearColor];

    [closeButton        addTarget:self
                           action:@selector(closeButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
   
    [closeButton setTitle:@"" forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
    
    // Resign keyboard when tap outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(resignKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)resignKeyboard:(UITapGestureRecognizer *)tap {
    [self.commentTextField resignFirstResponder];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)closeButtonPressed:(UIBarButtonItem*)button{
    [self.view endEditing:YES];
    [self.delegate didCloseComments];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HTTP Comment Code

// For comment system
NSString *publicKey = @"CaEN4GfINnGs2clsprUxiFw1Uj2IGhtpAtRpGSOH7OenWsZN0HxaAqyE5vgu9aP2";
NSString *secretKey = @"IVGGJxysqN5GgoMRc0qHtBzUYiOw6Ma77hkWFTytB42kUicNSHyKrmcnsusxKNBH";
NSString *redirectURL = @"http://morningsignout.com";

- (UIWebView *)commentWebView {
    if (!_commentWebView) {
        _commentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:self.commentWebView];
        [self.view bringSubviewToFront:self.commentWebView];
        self.commentWebView.delegate = self;
    }
    return _commentWebView;
}

- (void)getCommentCode {
    NSString *getCodeURL = [NSString stringWithFormat:@"https://disqus.com/api/oauth/2.0/authorize/?client_id=%@&response_type=code&state=TEST&redirect_uri=%@&duration=permanent&scope=read", publicKey, redirectURL];
    
    [self.commentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:getCodeURL]]];
    [UIView animateWithDuration:0.5 animations:^{
        self.commentWebView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70);
    }];
}

- (void)getAccessToken {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"grant_type": @"authorization_code",
                             @"client_id": publicKey,
                             @"client_secret": secretKey,
                             @"redirect_uri": redirectURL,
                             @"code": commentCode };
    [manager POST:@"https://disqus.com/api/oauth/2.0/access_token/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        accessToken = [responseObject valueForKey:@"access_token"];
        loggedIn = YES;
        [self postComment];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)postComment {
    // Reject empty comments
    if ([self.commentTextField.text isEqualToString:@""]) {
        [self showShortSpinner:@"Comment cannot be blank"];
        return;
    }
    
    [self.commentTextField resignFirstResponder];
    
    // Only post once logged into Disqus
    if (!loggedIn) {
        [self getCommentCode];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"api_key": publicKey,
                             @"access_token": accessToken,
                             @"thread": [NSString stringWithFormat:@"%@", self.disqusID],
                             @"message": self.commentTextField.text };
    [manager POST:@"https://disqus.com/api/3.0/posts/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Add comment to table
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *stringFromDate = [NSString stringWithString:[formatter stringFromDate:[NSDate date]]];
        
        Comment *newComment = [[Comment alloc] initWithName:@"you" Message:self.commentTextField.text AndDate:stringFromDate];
        
        self.commentTextField.text = @"";
        
        [self endLongSpinner];
        [self showShortSpinner:@"Comment successfully posted."];
        
        [self.comments addObject:newComment];
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showShortSpinner:@"This service is currently unavailable. Please try again later."];
        
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *currentURL = [request.URL absoluteString];
    if ([currentURL containsString:@"code="]) {
        NSRange range = [currentURL rangeOfString:@"code="];
        commentCode = [currentURL substringFromIndex:range.location + 5];
        
        // Start spinner
        [self startSpinnerWithMessage:@"Posting comment..."];
        
        // Return to original view
        [UIView animateWithDuration:0.5 animations:^{
            self.commentWebView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished){
            [self.commentWebView removeFromSuperview];
        }];
        
        // Get access token after logging in
        [self getAccessToken];
    }
    return YES;
}

#pragma mark - Spinner Methods

- (MBProgressHUD *)HUD {
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.mode = MBProgressHUDModeIndeterminate;
        _HUD.dimBackground = YES;
    }
    return _HUD;
}

- (void)startSpinnerWithMessage:(NSString *)message {
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.labelText = message;
    [self.HUD show:YES];
}

- (void)endLongSpinner {
    self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.HUD showWhileExecuting:@selector(delay) onTarget:self withObject:nil animated:YES];
}

- (void)delay {
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        self.HUD.progress = progress;
        usleep(5000);
    }
}

- (void)showShortSpinner:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

@end

