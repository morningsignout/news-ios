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
#import <Social/Social.h>
#import "ArticleLabels.h"
#import "Constants.h"
#import "PostHeaderInfo.h"
#include "AuthorViewController.h"
#include <IonIcons.h>
#import "DataParser.h"
#include "Comment.h"
#include "MDDisqusComponent.h"
//#import "IADisquser.h"

static NSString * const header = @"<!-- Latest compiled and minified CSS --><link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css\"><!-- Optional theme --><link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css\"><!-- Latest compiled and minified JavaScript --><script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js\"></script><!-- Yeon's CSS --><link rel=\"stylesheet\" href=\"http://morningsignout.com/wp-content/themes/mso/style.css?ver=4.3\"><meta charset=\"utf-8\"> \
    <style type=\"text/css\">.ssba {}.ssba img { width: 30px !important; padding: 0px; border:  0; box-shadow: none !important; display: inline !important; vertical-align: middle; } .ssba, .ssba a {text-decoration:none;border:0;background: none;font-family: Indie Flower;font-size: 20px;}</style><div style=\"padding:5px;background-color:white;box-shadow:none;\"></div>";

static const CGFloat initialWebViewYOffset = 450;

@interface FullPostViewController () <UIWebViewDelegate, UIScrollViewDelegate> {
    NSString *fontSizeStyle;
    int fontLevel;
    bool scrolled, loaded;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
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
        NSNumber *lev = [self.font.firstObject valueForKey:@"fontLevel"];
        fontLevel = [lev intValue];
        
    } else {
        fontLevel = 1;
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
    UIBarButtonItem *bookmarkItem = [[UIBarButtonItem alloc] initWithImage:[IonIcons imageWithIcon:ion_ios_bookmarks_outline size:32.0f color:[UIColor whiteColor]] style:UIBarButtonItemStylePlain target:self action:@selector(bookmarkPost)];
    UIBarButtonItem *fontItem = [[UIBarButtonItem alloc] initWithImage:[IonIcons imageWithIcon:ion_ios_glasses_outline size:32.0f color:[UIColor whiteColor]] style:UIBarButtonItemStylePlain target:self action:@selector(changeFont)];
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithImage:[IonIcons imageWithIcon:ion_ios_chatboxes_outline size:32.0f color:[UIColor whiteColor]] style:UIBarButtonItemStylePlain target:self action:@selector(loadComments)];
    
    NSArray *actionButtonItems = @[shareItem, bookmarkItem, commentItem, fontItem];

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
    self.header.articleLabels.frame = CGRectMake(0, self.header.coverImage.frame.size.height + 70, self.view.frame.size.width, 150);
    [self.header.articleLabels setBackgroundColor:[UIColor kFullPostInfoBackgroundColor]];
    
    self.header.articleLabels.titleLabel.text = self.post.title;
    [self.header.articleLabels.titleLabel setTextColor:[UIColor kFullPostMainTextColor]];
    
    self.header.articleLabels.categoriesLabel.text = [self.post.category componentsJoinedByString:@", "];
    [self.header.articleLabels.categoriesLabel setTextColor:[UIColor kFullPostCategoryTextColor]];
    [self.header.articleLabels.categoriesLabel setBackgroundColor:[UIColor kFullPostCategoryBackgroundColor]];
    
    self.header.articleLabels.authorLabel.text = [NSString stringWithFormat:@"%@ | %@", self.post.author.name, self.post.date];
    [self.header.articleLabels.authorLabel setTextColor:[UIColor kFullPostMainTextColor]];
    
//    self.header.articleLabels.dateLabel.text = self.post.date;
//    [self.header.articleLabels.dateLabel setTextColor:blue];
    
//    self.header.articleLabels.tagsLabel.text = [self.post.tags componentsJoinedByString:@", "];
//    [self.header.articleLabels.tagsLabel setTextColor:blue];
    
    // add underline to authorlabel text by making it a NSMutableAttributeString
//    NSString *author = self.post.author.name;
//    NSMutableAttributedString *uAuthor = [[NSMutableAttributedString alloc] initWithString:author];
//    
//    [uAuthor addAttributes:@{
//                             NSUnderlineColorAttributeName : blue,
//                             NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
//                             }
//                     range:NSMakeRange(0, uAuthor.length)];
//    
//    [self.header.articleLabels.authorLabel setAttributedText:uAuthor];
//    [self.header.articleLabels.authorLabel setTextColor:blue];
}

- (NSString *)setFontSize {
    float mainFontSize = [self getMainFontFromLevel:fontLevel];
    float captionFontSize = [self getCaptionFontFromLevel:fontLevel];
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

- (void)changeFont {
    if (fontLevel == 3) {
        fontLevel = 1;
    } else {
        ++fontLevel;
    }
    
    [self storeFontSize];
    [self reflectFontChangesOnHTML];
}

- (float)getMainFontFromLevel:(int)level {
    switch (level) {
        case 1:
            return 1.5;
            break;
        case 2:
            return 1.7;
            break;
        case 3:
            return 1.9;
            break;
    }
    return 1.7;
}

- (float)getCaptionFontFromLevel:(int)level {
    switch (level) {
        case 1:
            return 1.2;
            break;
        case 2:
            return 1.25;
            break;
        case 3:
            return 1.3;
            break;
    }
    return 1.25;
}

- (void)share
{
    NSString *textToShare = @"Check out this article!\n";

    NSArray *objectsToShare = @[textToShare, self.post.url];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[
                                    UIActivityTypeAddToReadingList,
                                    UIActivityTypeAirDrop,
                                    UIActivityTypeAssignToContact,
                                    UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeOpenInIBooks,
                                    UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypePrint,
                                  ];
    activityVC.excludedActivityTypes = excludeActivities;

    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)reflectFontChangesOnHTML {
    NSString *alteredHTML = [self.html stringByAppendingString:[self setFontSize]];
    [self.webView loadHTMLString:alteredHTML baseURL:nil];
}

- (void)storeFontSize {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *savedFont = self.font.firstObject;
    
    if (savedFont) {
        // Update existing device
        [savedFont setValue:[NSNumber numberWithFloat:fontLevel] forKey:@"fontLevel"];
        
    } else {
        // Create a new managed object
        NSManagedObject *newFont = [NSEntityDescription insertNewObjectForEntityForName:@"Font" inManagedObjectContext:context];
        [newFont setValue:[NSNumber numberWithFloat:fontLevel] forKey:@"fontLevel"];
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
    NSArray *comments = [DataParser DataForCommentsWithThreadID:self.post.disqusThreadID];
    for (Comment *comment in comments) {
        [comment print];
    }
    
    NSString *publicKey = @"CaEN4GfINnGs2clsprUxiFw1Uj2IGhtpAtRpGSOH7OenWsZN0HxaAqyE5vgu9aP2";
    NSString *secretKey = @"IVGGJxysqN5GgoMRc0qHtBzUYiOw6Ma77hkWFTytB42kUicNSHyKrmcnsusxKNBH";
    NSString *accessToken = @"bcfa82449d3b48569efb1f9f69c23b81";
    
    NSString *getCodeURL = [NSString stringWithFormat:@"https://disqus.com/api/oauth/2.0/authorize/?client_id=%@&scope=read,write&response_type=code&redirect_uri=http://www.morningsignout.com/", publicKey];
    NSString *code = @"c68bbd5cbf894d8c91374a808365e3ab";
    
    AFHTTPRequestOperation *requestOperation=[[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:getCodeURL]]];
    [requestOperation setRedirectResponseBlock:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
        if (redirectResponse) {
            //this is the redirected url
            NSLog(@"%@",request.URL);
        } else {
            NSLog(@"%@", connection.debugDescription);
            NSLog(@"%@", request.debugDescription);
            NSLog(@"%@", redirectResponse.description);
        }
        return request;
    }];
    [requestOperation start];
    
    
//    Functional code posting through Shannon's account
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSDictionary *params = @{@"api_key": publicKey,
//                             @"access_token": accessToken,
//                             @"thread": [NSString stringWithFormat:@"%@", self.post.disqusThreadID],
//                             @"message": @"msg" };
//    [manager POST:@"https://disqus.com/api/3.0/posts/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    
    // View Comments View Controller
    CommentsViewController *commentVC = [[CommentsViewController alloc] init];
    //Modal
    commentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    commentVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    commentVC.modalTransitionStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:commentVC animated:YES completion:nil];
    
    
    //[self.navigationController pushViewController:commentVC animated:NO];

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
    } completion:^(BOOL completed){
        self.progressView.hidden = YES;
        loaded = YES;
    }];
}

-(void)loadUpdated {
    if (!loaded) {
        [UIView animateWithDuration:0.1 animations:^{
            self.progressView.progress += 0.02;
        }];
    }
}


@end
