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
    return [UIColor darkGrayColor];
}

+ (UIColor*) kNavTextColor {
    return [UIColor whiteColor];
}

// Collection View Color
+ (UIColor*) kCollectionViewBackgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
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
+ (UIColor*) kFullPostTitleTextColor {
    return  nil;
}

+ (UIColor*) kFullPostAuthorTextColor {
    return  nil;
}

+ (UIColor*) kFullPostDateTextColor {
    return  nil;
}

+ (UIColor*) kFullPostCategoryTextColor {
    return  nil;
}

+ (UIColor*) kFullPostTagTextColor {
    return  nil;
}

+ (UIColor*) kFullPostInfoBackgroundColor {
    return  nil;
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
