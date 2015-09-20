//
//  TileCollectionViewCellC.m
//  ios-app
//
//  Created by Shannon Phu on 9/9/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "TileCollectionViewCellC.h"

@implementation TileCollectionViewCellC

- (id)initWithFrame:(CGRect)frame {
    self.titleHeight = kTileTitleHeight_C;
    self.excerptHeight = 0;
    self = [super initWithFrame:frame];
    return self;
}

@end
