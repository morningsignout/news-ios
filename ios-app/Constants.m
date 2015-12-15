//
//  Constants.m
//  ios-app
//
//  Created by Shannon Phu on 9/19/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

#define rgba(r, g, b, a)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:a]

@implementation UIColor (Extensions)

// Nav Colors
+ (UIColor*) kNavBackgroundColor {
    return rgba(115, 179, 226, 1);
}

+ (UIColor*) kNavTextColor {
    return [UIColor whiteColor];
}

// Collection View Color
+ (UIColor*) kCollectionViewBackgroundColor {
    return rgba(216, 228, 243, 1);
    //return [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

// Tile Colors
+ (UIColor*) kTileTitleBackgroundColor {
    return [UIColor colorWithWhite:1 alpha:0.7];
}

+ (UIColor*) kTileTitleTextColor {
    return [UIColor blackColor];
}

// Spinner Color
+ (UIColor*) kBottomSpinnerBackgroundColor {
    return [UIColor colorWithWhite:1 alpha:0.85];
}

// Full Post Colors
+ (UIColor*) kFullPostMainTextColor {
    return  [UIColor colorWithRed:0.11 green:0.38 blue:0.541 alpha:1];
}

+ (UIColor*) kFullPostCategoryTextColor {
    return  [UIColor whiteColor];
}

+ (UIColor*) kFullPostCategoryBackgroundColor {
    return [UIColor colorWithRed:0.388 green:0.698 blue:0.898 alpha:1];
}

+ (UIColor*) kFullPostInfoBackgroundColor {
    return  [UIColor colorWithRed:1 green:1 blue:1 alpha:0.75];
}

// Category Colors
+ (UIColor*) kCategoryButtonTextColor {
    return  nil;
}

+ (UIColor*) kCategoryButtonBackgroundColor {
    return  nil;
}

@end

// Tile Styles
UIFont *const kTileTitleFont;
CGFloat const kTileTitleHeight_A = 90.0f;
CGFloat const kTileTitleHeight_B = 75.0f;
CGFloat const kTileTitleHeight_C = 60.0f;
CGFloat const kFeaturedTileTitleHeight = 50.0f;
CGFloat const kFeaturedTileExcerptHeight = 60.0f;

