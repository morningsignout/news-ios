//
//  WebLinksViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/7/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "WebLinksViewController.h"

@interface WebLinksViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebLinksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        NSString *urlToOpen = [NSString stringWithFormat:@"%@",request.URL];
        NSURL* url = [NSURL URLWithString:urlToOpen];
        
        WebLinksViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LinkController"];
        [self.navigationController pushViewController:controller animated:YES];
        controller.url = url;
        
        return NO;
    } else {
        return YES;
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
