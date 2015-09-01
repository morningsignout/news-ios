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


@end
