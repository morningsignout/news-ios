//
//  FeaturedTileCollectionViewCell.m
//  ios-app
//
//  Created by Shannon Phu on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "FeaturedTileCollectionViewCell.h"

static const float IMAGE_TO_TILE_HEIGHT_PROPORTION = 0.75;

@implementation FeaturedTileCollectionViewCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 3 * self.contentView.frame.size.height / 4)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.frame.size.height, self.contentView.frame.size.width, (1 - IMAGE_TO_TILE_HEIGHT_PROPORTION - 0.05) * self.contentView.frame.size.height)];
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 3;
    }
    
    return _title;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
    }
    return self;
}

@end
