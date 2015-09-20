//
//  TileCollectionViewCellB.m
//  ios-app
//
//  Created by Shannon Phu on 9/9/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "TileCollectionViewCellB.h"

//static const CGFloat excerptHeight = 50;

@implementation TileCollectionViewCellB

- (id)initWithFrame:(CGRect)frame {
    self.titleHeight = kTileTitleHeight_B;
    self.excerptHeight = 0;
    self = [super initWithFrame:frame];
    return self;
}

@end
