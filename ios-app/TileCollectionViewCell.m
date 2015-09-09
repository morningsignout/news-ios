//
//  TileCollectionViewCell.m
//  ios-app
//
//  Created by Shannon Phu on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "TileCollectionViewCell.h"

static const CGFloat titleHeight = 100.0f;

@implementation TileCollectionViewCell

- (UIImageView *)imageView {
    if (!_imageView) {
        CGRect contentBounds = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height - titleHeight);//self.contentView.bounds;
        _imageView = [[UIImageView alloc] initWithFrame:contentBounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

- (UILabel *)title {

    if (!_title) {
        CGRect contentBounds = self.contentView.bounds;
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height - titleHeight, self.contentView.bounds.size.width, titleHeight)];
        _title.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        _title.numberOfLines = 3;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor whiteColor];
    }
    
    return _title;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
        
        self.clipsToBounds = NO;                        //cell's view
        self.contentView.clipsToBounds = NO;            //contentView
        self.contentView.superview.clipsToBounds = NO;  //scrollView
        
        [self.contentView.superview setClipsToBounds:NO];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // reset image property of imageView for reuse
    self.imageView.image = nil;
    //self.title = nil;
    
    // update frame position of subviews
    
    CGRect contentBounds = self.contentView.bounds;
    self.title.frame = CGRectMake(0, self.contentView.bounds.size.height - titleHeight, self.contentView.bounds.size.width, titleHeight);
}

@end
