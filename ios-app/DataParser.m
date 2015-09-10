//
//  DataParser.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "DataParser.h"
#import "URLParser.h"
#import "NSString+HTML.h"
#import <AFNetworking.h>

AFHTTPRequestOperationManager *manager;
NSDateFormatter *stringToDateFormatter;
NSDateFormatter *dateToStringFormatter;

@implementation DataParser


+ (void)initialize{
    manager = [AFHTTPRequestOperationManager manager];
    
    stringToDateFormatter = [[NSDateFormatter alloc] init];
    [stringToDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    dateToStringFormatter = [[NSDateFormatter alloc] init];
    [dateToStringFormatter setDateFormat:@"MMMM dd, yyyy"];
}

//Returns a dictionary parsed from the JSON returned
//after sending an api call
+(NSDictionary*)parseDataFromURL:(NSString *)url{
    // Always return 28 post objects!
    NSString *URLWithCount = [URLParser URLForQuery:url WithCountLimit:28];
    
    __block NSDictionary * data = [[NSDictionary alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [manager GET:URLWithCount
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            data = (NSDictionary *)responseObject;

            [[NSNotificationCenter defaultCenter] postNotificationName:@"dataLoaded" object:nil];
            dispatch_semaphore_signal(semaphore);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             dispatch_semaphore_signal(semaphore);
         }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return data;
}

+ (NSDictionary *)parseDataFromURL:(NSString *)url WithPageNumber:(int)page {
    NSDictionary *data = [self parseDataFromURL:[URLParser URLForQuery:url WithPageNumber:page]];
    return data;
}

+(Author *)parseAuthorFromDictionary:(NSDictionary*)authorData{
    int authorId = (int)[authorData valueForKey:@"id"];
    NSString* name = [authorData valueForKey:@"name"];
    NSString* about = [authorData valueForKey:@"description"];
    return [[Author alloc] initWith:authorId Name:name About:about];
}

+(NSArray *)parseAuthorsFromDictionaries:(NSDictionary*)authorArray{
    NSArray* authorsData = [authorArray valueForKey:@"authors"];
    NSMutableArray* authors = [[NSMutableArray alloc] init];
    int total = (int)[authorsData count];
    for (int i = 0; i < total; i++){
        [authors addObject:[self parseAuthorFromDictionary:authorsData[i]]];
    }
    return authors;
}

//provided a dictionary with info for a post.  Return a post object
//with that info.
+ (Post *)parsePostFromDictionary:(NSDictionary*)parseData{

    // Get ID
    int postid = (int)[parseData valueForKey:@"id"];
    
    // Get title
    NSString* title = [[parseData valueForKey:@"title_plain"] stringByDecodingHTMLEntities];
    
    // Get author
    NSDictionary *authorDict = [parseData valueForKey:@"author"];
    Author *author = [[Author alloc] initWith:(int)[authorDict valueForKey:@"id"] Name:[authorDict valueForKey:@"name"] About:[authorDict valueForKey:@"description"]];
    
    // Get content
    NSString* content = [parseData valueForKey:@"content"];
    
    // Get URL
    NSString* postUrl = [parseData valueForKey:@"url"];
    
    // Get excerpt
    NSString* excerpt = [[parseData valueForKey:@"excerpt"] stringByConvertingHTMLToPlainText];
    
    // Get formatted date
        // format date from string into NSDate object
    NSString *fullDate = [parseData valueForKey:@"date"];
    NSDate *dateObj = [stringToDateFormatter dateFromString: fullDate];
        // convert date object back into MMMM dd, yyyy format
    NSString *date = [dateToStringFormatter stringFromDate:dateObj];
    
    // Get categories
    NSArray* data = [parseData valueForKey:@"categories"];
    NSMutableArray *category = [[NSMutableArray alloc] init];
    int dataCount = (int)[data count];
    for(int i = 0; i < dataCount; i++){
        [category addObject:[data[i] valueForKey:@"title"]];
    }
    
    // Get tags
    NSArray* tagData = [parseData valueForKey:@"tags"];
    NSMutableArray *tags = [NSMutableArray array];
    int tagCount = (int)[tagData count];
    for (int i = 0; i < tagCount; i++) {
        [tags addObject:[tagData[i] valueForKey:@"slug"]];
    }
    
    // Get thumbnail and full cover image
    NSString *thumbnailImageURL = [parseData valueForKey:@"thumbnail"];
    NSString *fullImageURL = [[[parseData valueForKey:@"thumbnail_images"] valueForKey:@"full"] valueForKey:@"url"];
    if (thumbnailImageURL == (id)[NSNull null] || title.length == 0 )
        thumbnailImageURL = fullImageURL;
    
    
    // Create a post with data
    Post *post = [[Post alloc] initWith:postid Title:title Author:author Body:content URL:postUrl Excerpt:excerpt Date:date Category:category Tags:tags ThumbnailCoverImage:thumbnailImageURL FullCoverImage:fullImageURL];
    
    return post;
 
}

//returns an array of Posts, given a Dictionary of Posts
+(NSArray*)parsePostsFromDictionaries:(NSDictionary*)postArray{
    NSArray* postsData = [postArray valueForKey:@"posts"];//array of dictionaries of posts
    
    NSMutableArray* posts = [[NSMutableArray alloc] init]; // array of Posts

    int postCount = (int)[postsData count];
    for(int i = 0; i < postCount; i++){
        [posts addObject:[self parsePostFromDictionary:postsData[i]]];
    }
    
    return posts;
}

// Returns one Post searched by its Post ID
+ (Post *)DataForPostID:(int)ID{
    NSString *url = [URLParser URLForPostID:ID];
    NSDictionary* parseData = [self parseDataFromURL:url];
    
    return [self parsePostFromDictionary:[parseData valueForKey:@"post"]];
}

// Returns an array of Posts by a given author
+ (NSArray *)DataForAuthorInfoAndPostsWithAuthorID:(int)ID{
    NSString *url = [URLParser URLForAuthorInfoAndPostsWithAuthorID:ID];
    NSDictionary* parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

// Returns an array of Posts filtered by tag
+ (NSArray *)DataForPostWithTag:(NSString *)tagSlug AndPageNumber:(int)page {
    NSString *url = [URLParser URLForQuery:[URLParser URLForPostWithTag:tagSlug] WithPageNumber:page];
    NSDictionary* parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

// Returns an array of Posts filtered by category
+ (NSArray *)DataForCategory:(NSString *)categorySlug AndPageNumber:(int)page {
    NSString *url = [URLParser URLForQuery:[URLParser URLForCategory:categorySlug] WithPageNumber:page];
    NSDictionary* parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}


// Get home page, recent, featured posts, or all author info

// Returns an array of Posts
+ (NSArray *)DataForIndexPosts{  //checked
    NSString *url = [URLParser URLForIndexPosts];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

// Returns an array of Posts sorted by recent
+ (NSArray *)DataForRecentPostsWithPageNumber:(int)page {
    NSString *url = [URLParser URLForQuery:[URLParser URLForRecentPosts] WithPageNumber:page];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

// Returns an array of Posts sorted by featured
+ (NSArray *)DataForFeaturedPostsWithPageNumber:(int)page {
    NSString *url = [URLParser URLForQuery:[URLParser URLForFeaturedPosts] WithPageNumber:page];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

// Returns an array of Authors
+ (NSArray *)DataForAllAuthors{    //checked
    NSString *url = [URLParser URLForAllAuthors];
    NSDictionary *parseData = [self parseDataFromURL:url];

    return [self parseAuthorsFromDictionaries:parseData];
}

// Get posts organized by dates

// Returns an array of posts from a given year
+ (NSArray *)DataForPostsInYear:(int)year AndInPage:(int)page {
    NSString *url = [URLParser URLForQuery:[URLParser URLForPostsInYear:year] WithPageNumber:page];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

// Returns an array of posts from a given month and year
+ (NSArray *)DataForPostsInMonth:(int)month Year:(int)year AndPage:(int)page {
    NSString *url = [URLParser URLForQuery:[URLParser URLForPostsInMonth:month andYear:year] WithPageNumber:page];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}


// Get navigation-related info, including search-bar URL

// Returns an array of String names of the categories
+ (NSArray *)DataForCategories{  //checked
    NSString *url = [URLParser URLForCategories];
    NSDictionary *parseData = [self parseDataFromURL:url];
    NSArray * data = [parseData valueForKey:@"categories"];
    NSMutableArray * titles = [[NSMutableArray alloc] init];
    int dataCount = (int)[data count];
    for(int i = 0; i < dataCount; i++){
        [titles addObject:[data[i] valueForKey:@"title"]];
    }
    
    return titles;  //string names of categories
}

// Returns an array of posts
+ (NSArray *)DataForIndexNavigation {  // returns key "pages" instead of posts
    NSString *url = [URLParser URLForIndexNavigation];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

// Returns an array of posts related to the query passed in
+ (NSArray *)DataForSearchTerm:(NSString *)query InPage:(int)page {
    if ([query isEqualToString:@""] || !query) {
        return nil;
    }
    NSString *url = [URLParser URLForQuery:[URLParser URLForSearchTerm:query] WithPageNumber:page];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForSearchTerm:(NSString *)query InPage:(int)page WithCount:(int)count {
    if ([query isEqualToString:@""] || !query) {
        return nil;
    }
    NSString *url = [URLParser URLForQuery:[URLParser URLForSearchTerm:query] WithPageNumber:page];
    url = [URLParser URLForQuery:url WithCountLimit:count];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

@end
