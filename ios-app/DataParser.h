//
//  DataParser.h
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "Author.h"

@interface DataParser : NSObject

// Get specific content with post or author ID
+ (Post *)DataForPostID:(int)ID;
+ (NSArray *)DataForAuthorInfoAndPostsWithAuthorID:(int)ID;


// Get many posts with certain tag or category
+ (NSArray *)DataForPostWithTag:(NSString *)tagSlug AndPageNumber:(int)page;
+ (NSArray *)DataForCategory:(NSString *)categorySlug AndPageNumber:(int)page;


// Get home page, recent, featured posts, or all author info
+ (NSArray *)DataForIndexPosts;
+ (NSArray *)DataForRecentPostsWithPageNumber:(int)page;
+ (NSArray *)DataForFeaturedPostsWithPageNumber:(int)page;
+ (NSArray *)DataForAllAuthors; //array of authors


// Get posts organized by dates
+ (NSArray *)DataForPostsInYear:(int)year AndInPage:(int)page;
+ (NSArray *)DataForPostsInMonth:(int)month Year:(int)year AndPage:(int)page;


// Get navigation-related info, including search-bar URL
+ (NSArray *)DataForCategories;
+ (NSArray *)DataForIndexNavigation;
+ (NSArray *)DataForSearchTerm:(NSString *)query InPage:(int)page;


@end
