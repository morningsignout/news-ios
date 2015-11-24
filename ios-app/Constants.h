//
//  Constants.h
//  ios-app
//
//  Created by Shannon Phu on 9/19/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#ifndef ios_app_Constants_h
#define ios_app_Constants_h

#pragma mark - Colors

@interface UIColor (Extensions)

// Nav Colors
+ (UIColor*) kNavBackgroundColor;
+ (UIColor*) kNavTextColor;

// Collection View Color
+ (UIColor*) kCollectionViewBackgroundColor;

// Tile Colors
+ (UIColor*) kTileTitleBackgroundColor;
+ (UIColor*) kTileTitleTextColor;

// Spinner Color
+ (UIColor*) kBottomSpinnerBackgroundColor;

// Full Post Colors
+ (UIColor*) kFullPostMainTextColor;
+ (UIColor*) kFullPostCategoryTextColor;
+ (UIColor*) kFullPostCategoryBackgroundColor;
+ (UIColor*) kFullPostInfoBackgroundColor;

// Category Colors
+ (UIColor*) kCategoryButtonTextColor;
+ (UIColor*) kCategoryButtonBackgroundColor;

@end

#pragma mark - Fonts

@interface UIFont (Extensions)

// Nav Bar Font
+ (UIFont *) kNavFont;

// Tile Font
+ (UIFont *) kTileTitleFont;

// Full Post Font
+ (UIFont *) kFullPostTitleFont;
+ (UIFont *) kFullPostAuthorFont;
+ (UIFont *) kFullPostDateFont;
+ (UIFont *) kFullPostTagFont;
+ (UIFont *) kFullPostCategoryFont;

// Bookmark Fonts
// Note: change cell height on storyboard
+ (UIFont *) kBookmarkTitleFont;
+ (UIFont *) kBookmarkExcerptFont;

// Category Font
+ (UIFont *) kCategoryButtonTextFont;

@end

#pragma mark - Numerical Constants

// Tile Styles
FOUNDATION_EXPORT CGFloat const kTileTitleHeight_A;
FOUNDATION_EXPORT CGFloat const kTileTitleHeight_B;
FOUNDATION_EXPORT CGFloat const kTileTitleHeight_C;
FOUNDATION_EXPORT CGFloat const kFeaturedTileTitleHeight;
FOUNDATION_EXPORT CGFloat const kFeaturedTileExcerptHeight;

#endif
