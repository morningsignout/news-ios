//
//  BaseTileCollectionViewCell.m
//  ios-app
//
//  Created by Shannon Phu on 9/9/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "BaseTileCollectionViewCell.h"

@implementation BaseTileCollectionViewCell

- (UIImageView *)imageView {
    if (!_imageView) {
        CGSize contentSize = self.contentView.bounds.size;
        CGRect contentBounds = CGRectMake(0, 0, contentSize.width, contentSize.height - self.titleHeight - self.excerptHeight);
        
        _imageView = [[UIImageView alloc] initWithFrame:contentBounds];
        
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

- (UILabel *)title {
    
    if (!_title) {
        CGSize contentSize = self.contentView.bounds.size;
        CGRect contentBounds = CGRectMake(0, contentSize.height - self.titleHeight - self.excerptHeight, contentSize.width, self.titleHeight - self.excerptHeight);
        
        _title = [[UILabel alloc] initWithFrame:contentBounds];
        
        _title.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.numberOfLines = 4;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor kTileTitleBackgroundColor];
        _title.adjustsFontSizeToFitWidth = YES;
    }
    
    return _title;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
    }
    return self;
}


@end
