//
//  BookmarkTableViewCell.m
//  ios-app
//
//  Created by Shannon Phu on 9/15/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "BookmarkTableViewCell.h"

@implementation BookmarkTableViewCell

@synthesize imageView = _imageView;

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithRed:242/255.0
                                           green:242/255.0
                                            blue:242/255.0
                                           alpha:1.0];
    
    // Set up image shadows
    self.imageView.layer.masksToBounds = NO;
    self.imageView.layer.cornerRadius = 4;
    self.imageView.layer.shadowRadius = 1;
    self.imageView.layer.shadowOffset = CGSizeMake(0, 1);
    self.imageView.layer.shadowOpacity = 0.25;
    // Set up container
    self.imageContainerView.layer.masksToBounds = NO;
    self.imageContainerView.layer.cornerRadius = 4;
    self.imageContainerView.layer.shadowRadius = 1;
    self.imageContainerView.layer.shadowOffset = CGSizeMake(0, 1);
    self.imageContainerView.layer.shadowOpacity = 0.25;
    // Set up fonts
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20];
    self.titleLabel.textColor = [UIColor blackColor];
    self.excerptLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12];
    self.excerptLabel.textColor = [UIColor blackColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
