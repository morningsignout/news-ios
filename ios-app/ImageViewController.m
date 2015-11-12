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
@property (weak, nonatomic) IBOutlet UILabel *contentUnavailableLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIImage *img;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentUnavailableLabel.hidden = YES;
    [self startDownload];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.scrollView addGestureRecognizer:doubleTap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.userInteractionEnabled = YES;
        _imgView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        _imgView.contentMode = UIViewContentModeCenter;
        [_imgView sizeToFit];
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
    self.scrollView.minimumZoomScale = self.scrollView.bounds.size.width / self.imgView.image.size.width;
    if (self.scrollView.zoomScale < self.scrollView.minimumZoomScale)
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    
    CGFloat ratio = CGRectGetWidth(self.scrollView.bounds) / img.size.width;
    
    self.imgView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), img.size.height * ratio);
    self.imgView.center = CGPointMake(CGRectGetMidX(self.scrollView.bounds), CGRectGetMidY(self.scrollView.bounds));

    self.scrollView.contentSize = self.imgView.bounds.size;
    self.scrollView.zoomScale = 1.0;

    [self.scrollView setContentSize:CGSizeMake(self.imgView.frame.size.width, self.imgView.frame.size.height)];
    
    if (self.imgView.bounds.size.width > img.size.width && self.imgView.bounds.size.height > img.size.height) {
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    _scrollView.contentSize = self.imgView.bounds.size;
    NSLog(@"set image");

}

-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;

    // setting up zooming for scrollView
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 5.0;
    
    _scrollView.delegate = self;
    _scrollView.contentSize = self.imgView.bounds.size;
    _scrollView.clipsToBounds = YES;
    NSLog(@"set scrollview");
}

- (void)startDownload
{
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.photoURL];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.img = responseObject;
        self.imgView.image = responseObject;
        [self.scrollView addSubview:self.imgView];
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
        NSLog(@"done requesting");
        [self setImg:self.img];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        self.contentUnavailableLabel.hidden = NO;
        self.spinner.hidden = YES;
    }];
    [requestOperation start];
    
}

#pragma mark - UIScrollView delegate
// required zooming method in UIScrollViewDelegate protocol
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imgView;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    NSLog(@"did scroll");
    
    CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)?
    (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height)?
    (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imgView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                      self.scrollView.contentSize.height * 0.5 + offsetY);

}

- (IBAction)dismissImage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITapGestureRecognizer
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {

    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    else{
        CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
        CGSize scrollViewSize = self.scrollView.bounds.size;
        CGFloat w = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat h = scrollViewSize.height / self.scrollView.maximumZoomScale;
        CGFloat x = touchPoint.x - (w/2.0);
        CGFloat y = touchPoint.y - (h/2.0);
        CGRect rectTozoom = CGRectMake(x, y, w, h);
        [self.scrollView zoomToRect:rectTozoom animated:YES];
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
