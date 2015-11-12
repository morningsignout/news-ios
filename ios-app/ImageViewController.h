//
//  ImageViewController.h
//  ios-app
//
//  Created by Shannon Phu on 9/12/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (strong, nonatomic) NSURL *photoURL;
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;
@end
