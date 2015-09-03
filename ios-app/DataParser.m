//
//  DataParser.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "DataParser.h"
#import "URLParser.h"
//#import "Post.h"
#import "Author.h"
#import "PhotoInfo.h"
#import <AFNetworking.h>

AFHTTPRequestOperationManager *manager;

@implementation DataParser


+(void)initialize{
    manager = [AFHTTPRequestOperationManager manager];
}

//Returns a dictionary parsed from the JSON returned
//after sending an api call
+(NSDictionary*)parseDataFromURL:(NSString *)url{
    //NSURL *url = [NSURL URLWithString:string];
    __block NSDictionary * data = [[NSDictionary alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //NSLog(@"JSON: %@", responseObject);
             
             dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
             dispatch_async(myQueue, ^{
                 data = (NSDictionary *)responseObject;
             });
             
             NSLog(@"SUCCESS");
             dispatch_semaphore_signal(semaphore);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             dispatch_semaphore_signal(semaphore);
         }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
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
+(Post *)parsePostFromDictionary:(NSDictionary*)parseData{
     dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    __block Post *post = nil;
    
    dispatch_sync(myQueue, ^{
        int postid = (int)[parseData valueForKey:@"id"];
        NSString* title = [parseData valueForKey:@"title"];
        
        NSDictionary *authorDict = [parseData valueForKey:@"author"];
        Author *author = [[Author alloc] initWith:(int)[authorDict valueForKey:@"id"] Name:[authorDict valueForKey:@"name"] About:[authorDict valueForKey:@"description"]];
        
        NSString* content = [parseData valueForKey:@"content"];
        NSString* postUrl = [parseData valueForKey:@"url"];
        NSString* excerpt = [parseData valueForKey:@"excerpt"];
        NSString *date = [parseData valueForKey:@"date"];
        
        NSArray* data = [parseData valueForKey:@"categories"];
        NSMutableArray *category = [[NSMutableArray alloc] init];
            for(int i = 0; i < [data count]; i++){
                [category addObject:[data[i] valueForKey:@"title"]];
            }
        
        NSArray* tagData = [parseData valueForKey:@"tags"];
        NSMutableArray *tags = [NSMutableArray array];
        for (int i = 0; i < [tagData count]; i++) {
            [tags addObject:[tagData[i] valueForKey:@"slug"]];
        }
        
        NSArray* images = [parseData valueForKey:@"images"];
        
        post = [[Post alloc] initWith:postid Title:title Author:author Body:content URL:postUrl Excerpt:excerpt Date:date Category:[category copy] Tags:tags Images:images];
    
    });
    
    return post;
 
}

//returns an array of Posts, given a Dictionary of Posts
+(NSArray*)parsePostsFromDictionaries:(NSDictionary*)postArray{
    NSArray* postsData = [postArray valueForKey:@"posts"];//array of dictionaries of posts
    
    NSMutableArray* posts = [[NSMutableArray alloc] init]; // array of Posts
    for(int i =0;i<[postsData count];i++){
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

// Get many posts with certain tag or category
+ (NSArray *)DataForPostWithTag:(NSString *)tagSlug{ //checked
    NSString *url = [URLParser URLForPostWithTag:tagSlug];
    NSDictionary* parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

//get posts related to a certain category i'm guessing
+ (NSArray *)DataForCategory:(NSString *)categorySlug{ //checked
    NSString *url = [URLParser URLForCategory:categorySlug];
    //NSLog(@"%@",url);
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
+ (NSArray *)DataForCategories{  //checked  is this correct though?
    NSString *url = [URLParser URLForCategories];
    NSDictionary *parseData = [self parseDataFromURL:url];
    NSArray * data = [parseData valueForKey:@"categories"];
    NSMutableArray * titles = [[NSMutableArray alloc] init];
    for(int i =0;i<[data count] ;i ++){
        [titles addObject:[data[i] valueForKey:@"title"]];
    }
    
    return [titles copy];  //string names of categories
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
