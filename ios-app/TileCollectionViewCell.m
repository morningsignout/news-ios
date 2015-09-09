//
//  TileCollectionViewCell.m
//  ios-app
//
//  Created by Shannon Phu on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "TileCollectionViewCell.h"

@implementation TileCollectionViewCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

- (UILabel *)title {

    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height / 2, self.contentView.bounds.size.width, self.contentView.bounds.size.height / 2)];
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        _title.numberOfLines = 3;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
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

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // reset image property of imageView for reuse
    self.imageView.image = nil;
    self.title.text = nil;
    
    // update frame position of subviews
    self.imageView.frame = self.contentView.bounds;
    self.title.frame = CGRectMake(0, self.contentView.bounds.size.height / 2, self.contentView.bounds.size.width, self.contentView.bounds.size.height / 2);
}

@end
