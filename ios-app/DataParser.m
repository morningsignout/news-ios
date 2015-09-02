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

/*// Example function ONLY.
// On average takes 1.2-1.3s to print out JSON from URL if only 10 posts.
+ (NSArray *)postsWithTag:(NSString *)tag InPage:(int)page {
    // if any number below 1 passed in, make it 1 for pagination
    int revisedPageNum = page;
    if (revisedPageNum < 1) {
        revisedPageNum = 0;
    }


    return nil;
}*/

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
    return nil;
}
+ (NSArray *)DataForRecentPosts{
    return nil;
}
+ (NSArray *)DataForFeaturedPosts{
    return nil;
}
+ (NSArray *)DataForAllAuthors{

    return nil;
}

@end
