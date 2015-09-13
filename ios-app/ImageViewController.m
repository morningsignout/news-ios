//
//  ImageViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/12/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "ImageViewController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIImage *img;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startDownload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UIImage *)img
{
    return _imgView.image;
}

- (void)setImg:(UIImage *)img
{
    self.imgView.image = img;
    self.imgView.frame = CGRectMake(0, 100, self.img.size.width, self.img.size.height);
//    self.imgView.center = self.scrollView.center;
    
    self.imgView.contentMode = UIViewContentModeCenter;
    if (self.imgView.bounds.size.width > img.size.width && self.imgView.bounds.size.height > img.size.height) {
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    _scrollView.zoomScale = 2;
}

-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    // setting up zooming for scrollView
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 5.0;
    
    _scrollView.delegate = self;
    _scrollView.contentSize = self.imgView.bounds.size;
}

- (void)startDownload
{
    [self.spinner startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.photoURL];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.img = responseObject;
        self.imgView.image = responseObject;
        [self.scrollView addSubview:self.imgView];
        [self.spinner stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
}

#pragma mark - UIScrollView delegate
// required zooming method in UIScrollViewDelegate protocol
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imgView;
}

- (IBAction)dismissImage:(id)sender {
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
