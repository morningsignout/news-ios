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

@implementation UIColor (Extensions)

// Nav Colors
+ (UIColor*) kNavBackgroundColor {
    return [UIColor darkGrayColor];
}

+ (UIColor*) kNavTextColor {
    return [UIColor whiteColor];
}

// Collection View Color
+ (UIColor*) kCollectionViewBackgroundColor {
    return [UIColor colorWithWhite:0.9 alpha:0.7];
}

// Tile Colors
+ (UIColor*) kTileTitleBackgroundColor {
    return [UIColor whiteColor];
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

@implementation UIFont (Extensions)

// Nav Bar Font
+ (UIFont *) kNavFont {
    return nil;
}

@end

// Nav Bar Styles
UIFont *const kNavFont;

// Tile Styles
UIFont *const kTileTitleFont;
CGFloat const kTileTitleHeight_A = 90.0f;
CGFloat const kTileTitleHeight_B = 75.0f;
CGFloat const kTileTitleHeight_C = 60.0f;
CGFloat const kFeaturedTileTitleHeight = 50.0f;
CGFloat const kFeaturedTileExcerptHeight = 60.0f;

// Full Post View Styles
UIFont *const kFullPostTitleFont;
UIFont *const kFullPostAuthorFont;
UIFont *const kFullPostDateFont;
UIFont *const kFullPostCategoryFont;
UIFont *const kFullPostTagFont;

// Bookmarks View Styles
UIFont *const kBookmarkTitleFont;
UIFont *const kBookmarkExcerptFont;

// Category View Styles
UIFont *const kCategoryButtonTextFont;
