//
//  TileCollectionViewCellB.m
//  ios-app
//
//  Created by Shannon Phu on 9/9/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "TileCollectionViewCellB.h"

static const CGFloat titleHeight = 60.0f;
static const CGFloat excerptHeight = 75.0f;

@implementation TileCollectionViewCellB
- (UIImageView *)imageView {
    if (!_imageView) {
        CGRect contentBounds = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height - titleHeight - excerptHeight);
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
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height - titleHeight - excerptHeight, self.contentView.bounds.size.width, titleHeight)];
        _title.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        _title.numberOfLines = 3;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _title;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.excerpt];
        
        self.clipsToBounds = NO;                        //cell's view
        self.contentView.clipsToBounds = NO;            //contentView
        self.contentView.superview.clipsToBounds = NO;  //scrollView
        
        [self.contentView.superview setClipsToBounds:NO];
    }
    return self;
}

- (UILabel *)excerpt {
    
    if (!_excerpt) {
        _excerpt = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height - excerptHeight, self.contentView.bounds.size.width, excerptHeight)];
        _excerpt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _excerpt.lineBreakMode = NSLineBreakByWordWrapping;
        _excerpt.numberOfLines = 3;
        _excerpt.textAlignment = NSTextAlignmentCenter;
        _excerpt.backgroundColor = [UIColor whiteColor];
        [_excerpt setFont:[UIFont systemFontOfSize:12]];
    }
    
    return _excerpt;
}

@end
