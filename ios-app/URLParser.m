//
//  URLParser.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "URLParser.h"

static NSString * const BASE_URL = @"http://morningsignout.com/?json=";

@implementation URLParser


+ (NSString *)URLForPostID:(int)ID {
    return [NSString stringWithFormat:@"%@get_post&post_id=%d", BASE_URL, ID];
    // ie: "http://morningsignout.com/?json=get_post&post_id=30562" where ID = 30562
}

+ (NSString *)URLForRecentPosts {
    return [NSString stringWithFormat:@"%@get_recent_posts", BASE_URL];
}

+ (NSString *)URLForPostWithTag:(NSString *)tagSlug {
    return [NSString stringWithFormat:@"%@get_tag_posts&tag_slug=%@", BASE_URL, tagSlug];
}

+ (NSString *)URLForCategory:(NSString *)categorySlug {
    return [NSString stringWithFormat:@"%@category_slug=%@", BASE_URL, categorySlug];
}

+ (NSString *)URLForFeaturedPosts {
    return [self URLForCategory:@"feature"];
}

+ (NSString *)URLForSearchTerm:(NSString *)query {
    // If search term has a space in it
    NSString *parsedQuery = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    // TODO: Deal with other cases of user input into search bar
    
    return [NSString stringWithFormat:@"%@get_search_results&search=%@", BASE_URL, parsedQuery];
}

+ (NSString *)URLForAuthorsPost:(int)ID{
    return [NSString stringWithFormat:@"%@get_author_posts&id=%d", BASE_URL, ID];
}

+ (NSString *)URLForAuthorsInfo {
    return [NSString stringWithFormat:@"%@get_author_index", BASE_URL];
}

+ (NSString *)URLForCategories {
    return [NSString stringWithFormat:@"%@get_category_index", BASE_URL];
}

+ (NSString *)URLForDate:(int)date {
    return [NSString stringWithFormat:@"%@get_date_posts&date=%d", BASE_URL, date];
}

+ (NSString *)URLForIndexPosts {
    return [NSString stringWithFormat:@"%@1", BASE_URL];
}

+ (NSString *)URLForNavigation {
    return [NSString stringWithFormat:@"%@get_page_index", BASE_URL];
}

+ (NSString *)URLFor:(NSString *)OLD_URL CountLimit:(int)count{
    return [NSString stringWithFormat:@"%@&count=%d", OLD_URL, count];
}

+ (NSString *)URLFor:(NSString *)OLD_URL Ordering:(NSString *)orderParam{
    return [NSString stringWithFormat:@"%@&order_by=%@", OLD_URL, orderParam];
}




@end
