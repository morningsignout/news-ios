//
//  DataParser.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "DataParser.h"
#import "URLParser.h"
#import "Author.h"
#import "PhotoInfo.h"
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
    // Always return 25 post objects!
    NSString *URLWithCount = [URLParser URLForQuery:url WithCountLimit:25];
    
    __block NSDictionary * data = [[NSDictionary alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [manager GET:URLWithCount
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
            data = (NSDictionary *)responseObject;
            NSLog(@"SUCCESS");
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
    for(int i=0;i<[authorsData count];i++){
        [authors addObject:[self parseAuthorFromDictionary:authorsData[i]]];
    }
    return [authors copy];
}

//provided a dictionary with info for a post.  Return a post object
//with that info.
+ (Post *)parsePostFromDictionary:(NSDictionary*)parseData{

    // Get ID
    int postid = (int)[parseData valueForKey:@"id"];
    
    // Get title
    NSString* title = [parseData valueForKey:@"title"];
    
    // Get author
    NSDictionary *authorDict = [parseData valueForKey:@"author"];
    Author *author = [[Author alloc] initWith:(int)[authorDict valueForKey:@"id"] Name:[authorDict valueForKey:@"name"] About:[authorDict valueForKey:@"description"]];
    
    // Get content
    NSString* content = [parseData valueForKey:@"content"];
    
    // Get URL
    NSString* postUrl = [parseData valueForKey:@"url"];
    
    // Get excerpt
    NSString* excerpt = [parseData valueForKey:@"excerpt"];
    
    // Get formatted date
        // format date from string into NSDate object
    NSString *fullDate = [parseData valueForKey:@"date"];
    NSDate *dateObj = [stringToDateFormatter dateFromString: fullDate];
        // convert date object back into MMMM dd, yyyy format
    NSString *date = [dateToStringFormatter stringFromDate:dateObj];
    
    // Get categories
    NSArray* data = [parseData valueForKey:@"categories"];
    NSMutableArray *category = [[NSMutableArray alloc] init];
    for(int i = 0; i < [data count]; i++){
        [category addObject:[data[i] valueForKey:@"title"]];
    }
    
    // Get tags
    NSArray* tagData = [parseData valueForKey:@"tags"];
    NSMutableArray *tags = [NSMutableArray array];
    for (int i = 0; i < [tagData count]; i++) {
        [tags addObject:[tagData[i] valueForKey:@"slug"]];
    }
    
    // Get thumbnail and full cover image
    NSString *thumbnailImageURL = [parseData valueForKey:@"thumbnail"];
    NSString *fullImageURL = [[[parseData valueForKey:@"thumbnail_images"] valueForKey:@"full"] valueForKey:@"url"];
    
    // Create a post with data
    Post *post = [[Post alloc] initWith:postid Title:title Author:author Body:content URL:postUrl Excerpt:excerpt Date:date Category:category Tags:tags ThumbnailCoverImage:thumbnailImageURL FullCoverImage:fullImageURL];
    
    return post;
 
}

//returns an array of Posts, given a Dictionary of Posts
+(NSArray*)parsePostsFromDictionaries:(NSDictionary*)postArray{
    NSArray* postsData = [postArray valueForKey:@"posts"];//array of dictionaries of posts
    
    NSMutableArray* posts = [[NSMutableArray alloc] init]; // array of Posts

    for(int i = 0; i < [postsData count]; i++){
        [posts addObject:[self parsePostFromDictionary:postsData[i]]];
    }
    
    return [posts copy];
}

+ (Post *)DataForPostID:(int)ID{  //checked
    NSString *url = [URLParser URLForPostID:ID];
    NSDictionary* parseData = [self parseDataFromURL:url];
    
    return [self parsePostFromDictionary:[parseData valueForKey:@"post"]];
}

+ (NSArray *)DataForAuthorInfoAndPostsWithAuthorID:(int)ID{  //checked
    NSString *url = [URLParser URLForAuthorInfoAndPostsWithAuthorID:ID];
    NSDictionary* parseData = [self parseDataFromURL:url];
    NSArray* stuff = [self parsePostsFromDictionaries:parseData];
    //NSLog(@"%@",stuff);
    return stuff; //an array of posts by a give author
}

// Get many posts with certain tag
+ (NSArray *)DataForPostWithTag:(NSString *)tagSlug AndPageNumber:(int)page { //checked
    NSString *url = [URLParser URLForQuery:[URLParser URLForPostWithTag:tagSlug] WithPageNumber:page];
    NSDictionary* parseData = [self parseDataFromURL:url];
    return [self parsePostsFromDictionaries:parseData];
}

// Get many posts with certain category
+ (NSArray *)DataForCategory:(NSString *)categorySlug AndPageNumber:(int)page { //checked
    NSString *url = [URLParser URLForQuery:[URLParser URLForCategory:categorySlug] WithPageNumber:page];
    NSDictionary* parseData = [self parseDataFromURL:url];
    return [self parsePostsFromDictionaries:parseData];
}


// Get home page, recent, featured posts, or all author info
+ (NSArray *)DataForIndexPosts{  //checked
    NSString *url = [URLParser URLForIndexPosts];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForRecentPosts{   //checked
    NSString *url = [URLParser URLForRecentPosts];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForFeaturedPosts{   //checked
    NSString *url = [URLParser URLForFeaturedPosts];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForAllAuthors{  // returns an array of authors   //checked
    NSString *url = [URLParser URLForAllAuthors];
    NSDictionary *parseData = [self parseDataFromURL:url];

    return [self parseAuthorsFromDictionaries:parseData];
}

// Get posts organized by dates
+ (NSArray *)DataForPostsInYear:(int)year{  //checked
    NSString *url = [URLParser URLForPostsInYear:year];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForPostsInMonth:(int)month andYear:(int)year{   //checked
    NSString *url = [URLParser URLForPostsInMonth:month andYear:year];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}


// Get navigation-related info, including search-bar URL
+ (NSArray *)DataForCategories{  //checked
    NSString *url = [URLParser URLForCategories];
    NSDictionary *parseData = [self parseDataFromURL:url];
    NSArray * data = [parseData valueForKey:@"categories"];
    NSMutableArray * titles = [[NSMutableArray alloc] init];
    for(int i =0;i<[data count] ;i ++){
        [titles addObject:[data[i] valueForKey:@"title"]];
    }
    
    return titles;  //string names of categories
}

+ (NSArray *)DataForIndexNavigation{  //not good  //key is "pages"
    NSString *url = [URLParser URLForIndexNavigation];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForSearchTerm:(NSString *)query{  //checked
    NSString *url = [URLParser URLForSearchTerm:query];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

@end
