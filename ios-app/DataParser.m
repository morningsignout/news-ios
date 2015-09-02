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
    return [Post initWith:postid Title:title Author:author Body:content URL:postUrl Excerpt:excerpt Category:category Tags:tags Images:images];
}

// Example function ONLY. On average takes 1.3s to print out JSON from URL.
/*+ (NSArray *)postsWithTag:(NSString *)tag {
    NSString *url = [URLParser URLForPostWithTag:tag];
    NSDictionary * parseData = [self parseDataFromURL:url];
    
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
    NSArray* postsData = [parseData valueForKey:@"attachments"];//array of dictionaries
    NSMutableArray* posts; // array of Posts
    for(int i =0;i<[postsData count];i++){
        [posts addObject:[self parsePostFromDictionary:postsData[i]]];
    }
    return posts;
}

//get posts related to a certain category i'm guessing
+ (NSArray *)DataForCategory:(NSString *)categorySlug{
    NSString *url = [URLParser URLForCategory:categorySlug];
    return nil;
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
