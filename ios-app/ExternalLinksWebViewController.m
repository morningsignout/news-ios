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

@interface ExternalLinksWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ExternalLinksWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    
    NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *stringResponse = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        [self.webView loadHTMLString:stringResponse baseURL:nil];
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.webView loadHTMLString:error.localizedDescription baseURL:nil];
        
    }];
    
    [operation start];
    
    

    //NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    //[self.webView loadRequest:request];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
