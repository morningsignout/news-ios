//
//  FeaturedStoryTableViewCell.h
//  ios-app
//
//  Created by Shannon Phu on 9/4/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;

@interface FeaturedStoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView * image;
@property (strong, nonatomic) Post *post;
@end
