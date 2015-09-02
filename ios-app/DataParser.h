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

+ (NSArray *)postsWithTag:(NSString *)tag;

// Get specific content with post or author ID
+ (Post *)DataForPostID:(int)ID;
+ (NSArray *)DataForAuthorInfoAndPostsWithAuthorID:(int)ID;


// Get many posts with certain tag or category
+ (NSArray *)DataForPostWithTag:(NSString *)tagSlug;
+ (NSArray *)DataForCategory:(NSString *)categorySlug;


// Get home page, recent, featured posts, or all author info
+ (NSArray *)DataForIndexPosts;
+ (NSArray *)DataForRecentPosts;
+ (NSArray *)DataForFeaturedPosts;
+ (NSArray *)DataForAllAuthors;

@end
