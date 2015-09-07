//
//  Tile.h
//  ios-app
//
//  Created by Shannon Phu on 9/5/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;

@interface Tile : UIView
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) Post *post;
@end
