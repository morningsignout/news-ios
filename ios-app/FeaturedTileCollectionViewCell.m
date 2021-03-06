//
//  FeaturedTileCollectionViewCell.m
//  ios-app
//
//  Created by Shannon Phu on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "FeaturedTileCollectionViewCell.h"

@implementation FeaturedTileCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self.titleHeight = kFeaturedTileTitleHeight;
    self.excerptHeight = kFeaturedTileExcerptHeight;
    self = [super initWithFrame:frame];
    [self redoFrames];
    [self.contentView addSubview:self.excerpt];
    self.title.backgroundColor = [UIColor kCollectionViewBackgroundColor];
    return self;
}

- (void)redoFrames {
    CGSize contentSize = self.contentView.bounds.size;
    self.title.frame = CGRectMake(0, contentSize.height - self.excerptHeight - self.titleHeight, contentSize.width, self.titleHeight);
    
    self.excerpt = [[UITextView alloc] initWithFrame:CGRectMake(0, contentSize.height - self.excerptHeight, contentSize.width, self.excerptHeight)];
    self.excerpt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.excerpt.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 0);
    self.excerpt.scrollEnabled = YES;
    self.excerpt.textAlignment = NSTextAlignmentCenter;
    self.excerpt.backgroundColor = [UIColor kCollectionViewBackgroundColor];
    [self.excerpt setFont:[UIFont systemFontOfSize:13]];
    [self.excerpt setEditable:NO];
}

@end
