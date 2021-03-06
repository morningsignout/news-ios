//
//  FeatureCollectionViewController.h
//  ios-app
//
//  Created by Shannon Phu on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CHTCollectionViewWaterfallLayout.h"
#import "BaseTiledCollectionViewController.h"

@interface FeatureCollectionViewController : BaseTiledCollectionViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@end