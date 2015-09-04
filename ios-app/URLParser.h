//
//  URLParser.h
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject

// Get specific content with post or author ID
+ (NSString *)URLForPostID:(int)ID;
+ (NSString *)URLForAuthorInfoAndPostsWithAuthorID:(int)ID;


// Get many posts with certain tag or category
+ (NSString *)URLForPostWithTag:(NSString *)tagSlug;
+ (NSString *)URLForCategory:(NSString *)categorySlug;


// Get home page, recent, featured posts, or all author info
+ (NSString *)URLForIndexPosts;
+ (NSString *)URLForRecentPosts;
+ (NSString *)URLForFeaturedPosts;
+ (NSString *)URLForAllAuthors;


// Get posts organized by dates
+ (NSString *)URLForPostsInYear:(int)year;
+ (NSString *)URLForPostsInMonth:(int)month andYear:(int)year;


// Get navigation-related info, including search-bar URL
+ (NSString *)URLForCategories;
+ (NSString *)URLForIndexNavigation;
+ (NSString *)URLForSearchTerm:(NSString *)query;


// Get URLs for above URL plus more search filtering by count, sorting, or page number
+ (NSString *)URLForQuery:(NSString *)OLD_URL WithCountLimit:(int)count;
+ (NSString *)URLForQuery:(NSString *)OLD_URL WithOrdering:(NSString *)orderParam;
+ (NSString *)URLForQuery:(NSString *)OLD_URL WithPageNumber:(int)page;

@end
