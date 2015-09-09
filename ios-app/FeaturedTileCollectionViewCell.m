//
//  FeaturedTileCollectionViewCell.m
//  ios-app
//
//  Created by Shannon Phu on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "FeaturedTileCollectionViewCell.h"

static const CGFloat excerptHeight = 75.0f;
static const CGFloat titleHeight = 50.0f;

@implementation FeaturedTileCollectionViewCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.bounds.size.height - excerptHeight - titleHeight)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height - excerptHeight - titleHeight, self.contentView.frame.size.width, titleHeight)];
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 3;
    }
    
    return _title;
}

- (UILabel *)excerpt {
    
    if (!_excerpt) {
        _excerpt = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height - excerptHeight, self.contentView.bounds.size.width, excerptHeight)];
        _excerpt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _excerpt.lineBreakMode = NSLineBreakByWordWrapping;
        _excerpt.numberOfLines = 3;
        _excerpt.textAlignment = NSTextAlignmentCenter;
        _excerpt.backgroundColor = [UIColor lightGrayColor];
        [_excerpt setFont:[UIFont systemFontOfSize:14]];
    }
    
    return _excerpt;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.excerpt];
    }
    return self;
}

@end
