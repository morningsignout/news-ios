//
//  TiledCellTypeA.h
//  ios-app
//
//  Created by Shannon Phu on 9/4/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Tile;

@interface TiledCellTypeA : UITableViewCell
@property (strong, nonatomic) Tile *tileLeft;
@property (strong, nonatomic) Tile *tileRight;
@end
