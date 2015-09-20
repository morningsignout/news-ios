//
//  PostHeaderInfo.h
//  ios-app
//
//  Created by Shannon Phu on 9/20/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArticleLabels;

@interface PostHeaderInfo : UIView

@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet ArticleLabels *articleLabels;

@end
