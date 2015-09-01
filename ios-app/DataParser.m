//
//  DataParser.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "DataParser.h"
#import "URLParser.h"
#import <AFNetworking.h>

@implementation DataParser

// Example function ONLY. On average takes 1.3s to print out JSON from URL.
+ (NSArray *)postsWithTag:(NSString *)tag {
    NSString *url = [URLParser URLForPostWithTag:tag];
    NSLog(@"URL: %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    
    return nil;
}

@end
