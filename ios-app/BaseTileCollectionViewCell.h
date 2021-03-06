//
//  BaseTileCollectionViewCell.h
//  ios-app
//
//  Created by Shannon Phu on 9/9/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface BaseTileCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UITextView *excerpt;

@property (nonatomic) CGFloat titleHeight;
@property (nonatomic) CGFloat excerptHeight;

@end
