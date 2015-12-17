//
//  FullPostViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/6/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//
#import "CommentsViewController.h"
#import "FullPostViewController.h"
#import "Post.h"
#import "ExternalLinksWebViewController.h"
#import "ImageViewController.h"
#import <AFNetworking.h>
#import <CoreData/CoreData.h>
#import "ArticleLabels.h"
#import "Constants.h"
#import "PostHeaderInfo.h"
#include "AuthorViewController.h"
#import "DataParser.h"
#include "Comment.h"

static NSString * const header = @"<!-- Latest compiled and minified CSS --><link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css\"><!-- Optional theme --><link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css\"><!-- Latest compiled and minified JavaScript --><script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js\"></script><!-- Yeon's CSS --><link rel=\"stylesheet\" href=\"http://morningsignout.com/wp-content/themes/mso/style.css?ver=4.3\"><meta charset=\"utf-8\"> \
    <style type=\"text/css\">.ssba {}.ssba img { width: 30px !important; padding: 0px; border:  0; box-shadow: none !important; display: inline !important; vertical-align: middle; } .ssba, .ssba a {text-decoration:none;border:0;background: none;font-family: Indie Flower;font-size: 20px;}</style><div style=\"padding:5px;background-color:white;box-shadow:none;\"></div>";

static const CGFloat initialWebViewYOffset = 450;

// For comment system

NSString *publicKey = @"CaEN4GfINnGs2clsprUxiFw1Uj2IGhtpAtRpGSOH7OenWsZN0HxaAqyE5vgu9aP2";
NSString *secretKey = @"IVGGJxysqN5GgoMRc0qHtBzUYiOw6Ma77hkWFTytB42kUicNSHyKrmcnsusxKNBH";
NSString *redirectURL = @"http://morningsignout.com";

@interface FullPostViewController () <UIWebViewDelegate, UIScrollViewDelegate, CommentsViewControllerDelegate> {
    NSString *fontSizeStyle;
    float mainFontSize;
    float captionFontSize;
    bool scrolled, loaded;
    NSString *commentCode;
    NSString *accessToken;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIWebView *commentWebView;
@property (strong, nonatomic) NSString *html;
@property (strong, nonatomic) NSArray *font;
@property (weak, nonatomic) IBOutlet PostHeaderInfo *header;
@property (nonatomic) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation FullPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = YES;
    [self setupNavigationBarStyle];
    
    [self.header.coverImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapCoverImageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCoverImage:)];
    [self.header.coverImage addGestureRecognizer:tapCoverImageRecognizer];
    
    [self.header.articleLabels.authorLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapAuthorRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAuthor:)];
    [self.header.articleLabels.authorLabel addGestureRecognizer:tapAuthorRecognizer];
    
    // Retrieve user font size preference if was previously saved
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Font"];
    self.font = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if (self.font.firstObject) {
        NSNumber *numberFormatFloat = [self.font.firstObject valueForKey:@"mainSize"];
        mainFontSize = [numberFormatFloat floatValue];
        numberFormatFloat = [self.font.firstObject valueForKey:@"captionSize"];
        captionFontSize = [numberFormatFloat floatValue];
    } else {
        mainFontSize = 1.5;
        captionFontSize = 1.2;
    }
    
    [self setUpLabels];
    
    NSString *filteredHTML = [self.post.body stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    filteredHTML = [filteredHTML stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
    NSString *containerFront = @"<div class=\"container\">";
    NSString *containerEnd = @"</div>";
    filteredHTML = [containerFront stringByAppendingString:filteredHTML];
    filteredHTML = [filteredHTML stringByAppendingString:containerEnd];
    filteredHTML = [header stringByAppendingString:filteredHTML];
    self.html = filteredHTML;
    
    [self loadWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadPostImage];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.header.coverImage.image = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBarStyle {
    [self.navigationController.navigationBar setBarTintColor:[UIColor kNavBackgroundColor]];
    self.navigationController.navigationBar.tintColor = [UIColor kNavTextColor];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    UIBarButtonItem *bookmarkItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkPost)];
    UIBarButtonItem *fontIncItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(increaseFontSize)];
    UIBarButtonItem *fontDecItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(decreaseFontSize)];
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(loadComments)];
    
    NSArray *actionButtonItems = @[shareItem, bookmarkItem, fontIncItem, fontDecItem, commentItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)loadPostImage {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.post.fullCoverImageURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *image = responseObject;
        self.header.coverImage.image = image;
        self.header.coverImage.contentMode = UIViewContentModeScaleAspectFill;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}

- (void)setUpLabels {
    //UIColor *blue = [UIColor colorWithRed:0.125 green:0.498 blue:0.722 alpha:1];          // from website
    UIColor *blue = [UIColor colorWithRed:0.11 green:0.38 blue:0.541 alpha:1];              // darker version
    UIColor *lighterblue = [UIColor colorWithRed:0.388 green:0.698 blue:0.898 alpha:1];     // from website
    //UIColor *lighterblue = [UIColor colorWithRed:0.29 green:0.573 blue:0.757 alpha:1];    // darker version
    
    self.header.articleLabels.frame = CGRectMake(0, self.header.coverImage.frame.size.height + 70, self.view.frame.size.width, 150);
    [self.header.articleLabels setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.75]];
    
    self.header.articleLabels.titleLabel.text = self.post.title;
    [self.header.articleLabels.titleLabel setTextColor:blue];
    
    self.header.articleLabels.dateLabel.text = self.post.date;
    [self.header.articleLabels.dateLabel setTextColor:blue];
    
    self.header.articleLabels.categoriesLabel.text = [self.post.category componentsJoinedByString:@", "];
    [self.header.articleLabels.categoriesLabel setTextColor:[UIColor whiteColor]];
    [self.header.articleLabels.categoriesLabel setBackgroundColor:lighterblue];
    
    self.header.articleLabels.tagsLabel.text = [self.post.tags componentsJoinedByString:@", "];
    [self.header.articleLabels.tagsLabel setTextColor:blue];
    
    // add underline to authorlabel text by making it a NSMutableAttributeString
    NSString *author = self.post.author.name;
    NSMutableAttributedString *uAuthor = [[NSMutableAttributedString alloc] initWithString:author];
    
    [uAuthor addAttributes:@{
                             NSUnderlineColorAttributeName : blue,
                             NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                             }
                     range:NSMakeRange(0, uAuthor.length)];
    
    [self.header.articleLabels.authorLabel setAttributedText:uAuthor];
    [self.header.articleLabels.authorLabel setTextColor:blue];
}

- (NSString *)setFontSize {
    fontSizeStyle = [NSString stringWithFormat:@"<script> \
                     var all = document.getElementsByTagName(\"p\"); \
                     for (var i = 0; i < all.length; i++) { \
                     var par = all[i]; \
                     par.style.fontSize = '%frem'; \
                     } \
                     \
                     var captions = document.getElementsByTagName(\"figcaption\"); \
                     for (var i = 0; i < captions.length; i++) { \
                     var caption = captions[i]; \
                     caption.style.fontSize = '%frem'; \
                     } \
                     </script>", mainFontSize, captionFontSize];
    return fontSizeStyle;
}

#pragma mark - Web View Functions

- (void)loadWebView {
    NSString *filteredHTML = [self.html stringByAppendingString:[self setFontSize]];
    [self.webView loadHTMLString:filteredHTML baseURL:nil];
    self.webView.frame = CGRectMake(0, initialWebViewYOffset, self.view.frame.size.width, self.view.frame.size.height - initialWebViewYOffset);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        NSString *urlToOpen = [NSString stringWithFormat:@"%@",request.URL];
        NSURL* url = [NSURL URLWithString:urlToOpen];
        
        // Check if image was tapped
        NSString *fileType = [urlToOpen substringFromIndex: [urlToOpen length] - 4];
        if ([fileType isEqualToString:@".jpg"] || [fileType isEqualToString:@".png"]) {
            [self performSegueWithIdentifier:@"showImage" sender:url];
            return NO;
        }
        
        ExternalLinksWebViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LinkController"];
        controller.url = url;
        
        // For push segue
        // [self.navigationController pushViewController:controller animated:YES];
        
        // For modal segue
        [self presentViewController:controller animated:YES completion:nil];
        
        return NO;
        
    }
    
    return YES;
}

- (void)increaseFontSize {
    mainFontSize += 0.1;
    captionFontSize += 0.05;
    [self reflectFontChangesOnHTML];
}

- (void)decreaseFontSize {
    mainFontSize -= 0.1;
    captionFontSize -= 0.05;
    [self reflectFontChangesOnHTML];
}

- (void)share
{
    NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
//    NSArray *excludeActivities = @[UIActivityTypeMail,
//                                   UIActivityTypeMessage,
//                                   UIActivityTypePrint,
//                                   UIActivityTypePostToFacebook,
//                                   UIActivityTypePostToTwitter,
//                                   UIActivityTypePostToWeibo,
//                                   UIActivityTypeCopyToPasteboard];
//    
//    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)reflectFontChangesOnHTML {
    [self storeFontSize];
    
    NSString *alteredHTML = [self.html stringByAppendingString:[self setFontSize]];
    [self.webView loadHTMLString:alteredHTML baseURL:nil];
}

- (void)storeFontSize {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *savedFont = self.font.firstObject;
    
    if (savedFont) {
        // Update existing device
        [savedFont setValue:[NSNumber numberWithFloat:mainFontSize] forKey:@"mainSize"];
        [savedFont setValue:[NSNumber numberWithFloat:captionFontSize] forKey:@"captionSize"];
        
    } else {
        // Create a new managed object
        NSManagedObject *newFont = [NSEntityDescription insertNewObjectForEntityForName:@"Font" inManagedObjectContext:context];
        [newFont setValue:[NSNumber numberWithFloat:mainFontSize] forKey:@"mainSize"];
        [newFont setValue:[NSNumber numberWithFloat:captionFontSize] forKey:@"captionSize"];
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void)bookmarkPost {
    // Pull out all the posts previously bookmarked
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Post"];
    NSArray *bookmarks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    // If post already saved before, notify user and give choice to un-bookmark
    for (id bookmark in bookmarks) {
        int postID = [[bookmark valueForKey:@"id"] intValue];
        if (postID == self.post.ID) {
            return;
        }
    }
    
    // Else if not saved before, save it into core data now
    NSManagedObject *bookmarkedPost = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:managedObjectContext];
    [bookmarkedPost setValue:[NSNumber numberWithInt:self.post.ID] forKey:@"id"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void)loadComments {
    

    // View Comments View Controller
    CommentsViewController *commentVC = [[CommentsViewController alloc] init];
    commentVC.comments = [DataParser DataForCommentsWithThreadID:self.post.disqusThreadID];
    commentVC.delegate = self;
    //Modal
    commentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    commentVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    commentVC.modalTransitionStyle = UIModalPresentationOverFullScreen;
    
    UIView *dimBackground   = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // Tag the dim background
    dimBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    dimBackground.tag             = 1111;
    [self.view addSubview:dimBackground];
    
    [self presentViewController:commentVC animated:YES completion:nil];
    
    
   // [self getCommentCode];
}
- (void)didCloseComments{
    NSLog(@"got back");
    for (UIView *view in [self.view subviews]) {
        if (view.tag == 1111) {
            [view removeFromSuperview];
            
            
        }
    }
}

- (void)getCommentCode {
    NSString *getCodeURL = [NSString stringWithFormat:@"https://disqus.com/api/oauth/2.0/authorize/?client_id=%@&response_type=code&state=TEST&redirect_uri=%@&duration=permanent&scope=read", publicKey, redirectURL];
    
    [self.commentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:getCodeURL]]];
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
        NSLog(@"%@", accessToken);
        
        [self postComment];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)postComment {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *params = @{@"api_key": publicKey,
                             @"access_token": accessToken,
                             @"thread": [NSString stringWithFormat:@"%@", self.post.disqusThreadID],
                             @"message": @"msg" };
    [manager POST:@"https://disqus.com/api/3.0/posts/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successful comment made");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)tappedCoverImage:(UITapGestureRecognizer *)tap {
    [self performSegueWithIdentifier:@"showImage" sender:[NSURL URLWithString:self.post.fullCoverImageURL]];
}

- (void)tappedAuthor:(UITapGestureRecognizer *)tap {
    [self performSegueWithIdentifier:@"showAuthor" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showImage"]) {
        ImageViewController *imgVC = segue.destinationViewController;
        imgVC.photoURL = sender;
    } else if ([segue.identifier isEqualToString:@"showAuthor"]) {
        AuthorViewController *authorVC = segue.destinationViewController;
        authorVC.author = self.post.author;
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset > 0 && !scrolled)
    {
        // then we are at the top
        [UIView animateWithDuration:0.5 animations:^{
            self.webView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60);
        } completion:^(BOOL completed){
            [self.webView.scrollView setContentOffset:CGPointZero animated:YES];
            scrolled = YES;
        }];
        
    }
    else if (scrollOffset < -80) {
        [UIView animateWithDuration:0.5 animations:^{
            self.webView.frame = CGRectMake(0, initialWebViewYOffset, self.view.frame.size.width, self.view.frame.size.height - initialWebViewYOffset);
        } completion:^(BOOL completed){
            scrolled = NO;
        }];
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        // then we are at the end
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    loaded = NO;
    self.progressView.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(loadUpdated) userInfo:nil repeats:YES];
    self.progressView.progress = 0;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:1.5 animations:^{
        self.progressView.progress = 1;
        
        NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
        if ([currentURL containsString:@"code="]) {
            NSRange range = [currentURL rangeOfString:@"code="];
            commentCode = [currentURL substringFromIndex:range.location + 5];
            NSLog(@"%@", commentCode);
            self.commentWebView = nil;
            [self getAccessToken];
        }
    } completion:^(BOOL completed){
        self.progressView.hidden = YES;
        loaded = YES;
        
    }];
}

- (UIWebView *)commentWebView {
    if (!_commentWebView) {
        _commentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:self.commentWebView];
        [self.view bringSubviewToFront:self.commentWebView];
        self.commentWebView.delegate = self;
    }
    return _commentWebView;
}

-(void)loadUpdated {
    if (!loaded) {
        [UIView animateWithDuration:0.1 animations:^{
            self.progressView.progress += 0.02;
        }];
    }
}


@end
