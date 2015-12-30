//
//  BookmarkTableViewCell.m
//  ios-app
//
//  Created by Shannon Phu on 9/15/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "BookmarkTableViewCell.h"
#import "Constants.h"
#import <IonIcons.h>
@implementation BookmarkTableViewCell

@synthesize imageView = _imageView;

- (void)awakeFromNib {
    // Initialization code
    
    // Optimize shadows
    self.imageContainerView.opaque  = YES;
    self.imageView.opaque           = YES;
    self.layer.shouldRasterize      = YES;
    self.layer.rasterizationScale   = [UIScreen mainScreen].scale;
//    self.backgroundColor            = [UIColor colorWithRed:242/255.0
//                                                      green:242/255.0
//                                                       blue:242/255.0
//                                                      alpha:1.0];

    [self.removeButton setImage:[IonIcons imageWithIcon:ion_close_circled
                                                   size:20.0f
                                                  color:[UIColor colorWithRed:1.0
                                                                        green:1.0
                                                                         blue:1.0
                                                                        alpha:0.6]]
                       forState:UIControlStateNormal];

    // Hints the OS for finding size of cell
    self.imageView.layer.shadowPath          = [[UIBezierPath bezierPathWithRect:self.imageView.bounds]CGPath ];
    self.imageView.layer.masksToBounds = NO;
    
    // Set up container
    self.imageContainerView.layer.masksToBounds = NO;
    
    // Set up fonts
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.authorLabel.font = [UIFont systemFontOfSize:10];
    self.categoryLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor kCollectionViewBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
