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
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             data = (NSDictionary *)responseObject;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
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
    NSMutableArray* authors;
    for(int i=0;i<[authorsData count];i++){
        [authors addObject:[self parseAuthorFromDictionary:authorsData[i]]];
    }
    return [authors copy];
}

//provided a dictionary with info for a post.  Return a post object
//with that info.
+(Post *)parsePostFromDictionary:(NSDictionary*)parseData{
    int postid = (int)[parseData valueForKey:@"id"];
    NSString* title = [parseData valueForKey:@"title"];
    Author* author = [parseData valueForKey:@"author"];
    NSString* content = [parseData valueForKey:@"content]"];
    NSString* postUrl = [parseData valueForKey:@"url"];
    NSString* excerpt = [parseData valueForKey:@"excerpt"];
    NSArray* category = [parseData valueForKey:@"categories"];
    NSArray* tags = [parseData valueForKey:@"tags"];
    NSArray* images = [parseData valueForKey:@"images"];
    return [[Post alloc] initWith:postid Title:title Author:author Body:content URL:postUrl Excerpt:excerpt Category:category Tags:tags Images:images];
 
}

//returns an array of Posts, given a Dictionary of Posts
+(NSArray*)parsePostsFromDictionaries:(NSDictionary*)postArray{
    NSArray* postsData = [postArray valueForKey:@"attachments"];//array of dictionaries of posts
    NSMutableArray* posts; // array of Posts
    for(int i =0;i<[postsData count];i++){
        [posts addObject:[self parsePostFromDictionary:postsData[i]]];
    }
    return [posts copy];
}

+ (Post *)DataForPostID:(int)ID{
    NSString *url = [URLParser URLForPostID:ID];
    NSDictionary* parseData = [self parseDataFromURL:url];
    
    return [self parsePostFromDictionary:parseData];
}

+ (NSArray *)DataForAuthorInfoAndPostsWithAuthorID:(int)ID{
    
    
    return nil;
}

// Get many posts with certain tag or category
+ (NSArray *)DataForPostWithTag:(NSString *)tagSlug{
    NSString *url = [URLParser URLForPostWithTag:tagSlug];
    NSDictionary* parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

//get posts related to a certain category i'm guessing
+ (NSArray *)DataForCategory:(NSString *)categorySlug{
    NSString *url = [URLParser URLForCategory:categorySlug];
    NSLog(@"%@",url);
    NSDictionary* parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}


// Get home page, recent, featured posts, or all author info
+ (NSArray *)DataForIndexPosts{
    NSString *url = [URLParser URLForIndexPosts];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForRecentPosts{
    NSString *url = [URLParser URLForRecentPosts];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForFeaturedPosts{
    NSString *url = [URLParser URLForFeaturedPosts];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForAllAuthors{  // returns an array of authors
    NSString *url = [URLParser URLForAllAuthors];
    NSDictionary *parseData = [self parseDataFromURL:url];

    return [self parseAuthorsFromDictionaries:parseData];
}

// Get posts organized by dates
+ (NSArray *)DataForPostsInYear:(int)year{
    NSString *url = [URLParser URLForPostsInYear:year];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForPostsInMonth:(int)month andYear:(int)year{
    NSString *url = [URLParser URLForPostsInMonth:month andYear:year];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}


// Get navigation-related info, including search-bar URL
+ (NSArray *)DataForCategories{
    NSString *url = [URLParser URLForCategories];
    NSDictionary *parseData = [self parseDataFromURL:url];
    NSArray * data = [parseData valueForKey:@"categories"];
    return nil;
}

+ (NSArray *)DataForIndexNavigation{
    NSString *url = [URLParser URLForIndexNavigation];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

+ (NSArray *)DataForSearchTerm:(NSString *)query{
    NSString *url = [URLParser URLForSearchTerm:query];
    NSDictionary *parseData = [self parseDataFromURL:url];
    
    return [self parsePostsFromDictionaries:parseData];
}

@end
