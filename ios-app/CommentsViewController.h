//
//  CommentsViewController.h
//  ios-app
//
//  Created by Vincent Chau on 11/19/15.
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentsViewControllerDelegate <NSObject>

- (void)didCloseComments;

@end
@interface CommentsViewController : UIViewController

@property (strong, nonatomic) NSArray *comments;

@property (weak, nonatomic) id<CommentsViewControllerDelegate> delegate;

@end
