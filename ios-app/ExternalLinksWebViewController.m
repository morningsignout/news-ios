//
//  WebLinksViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/7/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "ExternalLinksWebViewController.h"
#import <UIWebView+AFNetworking.h>
#import <AFNetworking.h>
#import "Constants.h"

@interface ExternalLinksWebViewController () <UIWebViewDelegate> {
    BOOL loaded;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *statusBarBackground;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ExternalLinksWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarTintColor:[UIColor kNavBackgroundColor]];
    self.statusBarBackground.backgroundColor = rgba(137, 191, 231, 1);
    
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Uncomment if want to create push segue for every link tapped
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
//        NSString *urlToOpen = [NSString stringWithFormat:@"%@",request.URL];
//        NSURL* url = [NSURL URLWithString:urlToOpen];
//        
//        WebLinksViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LinkController"];
//        [self.navigationController pushViewController:controller animated:YES];
//        controller.url = url;
//        
//        return NO;
//    } else {
//        return YES;
//    }
//}

- (IBAction)returnToApp:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
