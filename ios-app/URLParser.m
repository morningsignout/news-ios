//
//  URLParser.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "URLParser.h"

static NSString * const BASE_URL = @"http://morningsignout.com/?json=";
static NSString * const AUTHOR_EMAIL_QUERY = @"&author_meta=email";

static NSString * const DISQUS_BASE_URL = @"https://disqus.com/api/3.0/threads/listPosts.json?api_key=CaEN4GfINnGs2clsprUxiFw1Uj2IGhtpAtRpGSOH7OenWsZN0HxaAqyE5vgu9aP2&forum=morningsignout&thread=";

@implementation URLParser


+ (NSString *)URLForPostID:(int)ID {
    return [NSString stringWithFormat:@"%@get_post&post_id=%d", BASE_URL, ID];
    // ie: "http://morningsignout.com/?json=get_post&post_id=30562" where ID = 30562
}

+ (NSString *)URLForRecentPosts {
    return [NSString stringWithFormat:@"%@get_recent_posts%@", BASE_URL, AUTHOR_EMAIL_QUERY];
}

+ (NSString *)URLForPostWithTag:(NSString *)tagSlug {
    return [NSString stringWithFormat:@"%@get_tag_posts&tag_slug=%@%@", BASE_URL, tagSlug, AUTHOR_EMAIL_QUERY];
}

+ (NSString *)URLForCategory:(NSString *)categorySlug {
    return [NSString stringWithFormat:@"%@get_category_posts&category_slug=%@%@", BASE_URL, categorySlug, AUTHOR_EMAIL_QUERY];
}

+ (NSString *)URLForFeaturedPosts {
    return [self URLForCategory:@"featured"];
}

+ (NSString *)URLForSearchTerm:(NSString *)query {
    // If search term has a space in it
    NSString *parsedQuery = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    return [NSString stringWithFormat:@"%@get_search_results&search=%@%@", BASE_URL, parsedQuery, AUTHOR_EMAIL_QUERY];
}

+ (NSString *)URLForAuthorInfoAndPostsWithAuthorID:(int)ID {
    return [NSString stringWithFormat:@"%@get_author_posts&id=%d&author_meta=email", BASE_URL, ID];
}

+ (NSString *)URLForPostsInYear:(int)year {
    return [NSString stringWithFormat:@"%@get_date_posts&date=%d%@", BASE_URL, year, AUTHOR_EMAIL_QUERY];
}

+ (NSString *)URLForPostsInMonth:(int)month andYear:(int)year {
    
    // If month is a single digit, add a '0' in front of it
    NSString *monthString = [NSString stringWithFormat:@"%d", month];
    if ([monthString length] == 1) {
        monthString = [NSString stringWithFormat:@"0%@", monthString];
    }
    
    NSString *yearURL = [NSString stringWithString:[self URLForPostsInYear:year]];
    NSString *appendedMonth = [NSString stringWithFormat:@"-%@", monthString];
    return [yearURL stringByAppendingString:appendedMonth];
}

+ (NSString *)URLForCategories {
    return [NSString stringWithFormat:@"%@get_category_index", BASE_URL];
}

+ (NSString *)URLForAllAuthors {
    return [NSString stringWithFormat:@"%@get_author_index", BASE_URL];
}

+ (NSString *)URLForIndexPosts {
    return [NSString stringWithFormat:@"%@1", BASE_URL];
}

+ (NSString *)URLForIndexNavigation {
    return [NSString stringWithFormat:@"%@get_page_index", BASE_URL];
}

+ (NSString *)URLForQuery:(NSString *)OLD_URL WithCountLimit:(int)count {
    return [NSString stringWithFormat:@"%@&count=%d", OLD_URL, count];
}

+ (NSString *)URLForQuery:(NSString *)OLD_URL WithOrdering:(NSString *)orderParam {
    return [NSString stringWithFormat:@"%@&order_by=%@", OLD_URL, orderParam];
}

+ (NSString *)URLForQuery:(NSString *)OLD_URL WithPageNumber:(int)page {
    return [NSString stringWithFormat:@"%@&page=%d", OLD_URL, page];
}

+ (NSString *)URLForDisqusThreadWithThreadID:(NSString *)threadID {
    return [NSString stringWithFormat:@"%@%@", DISQUS_BASE_URL, threadID];
}

@end
