//
//  Post.h
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author.h"

@interface Post : NSObject

@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) Author *author;

@property (strong, nonatomic) NSString *body; // could be renamed to content, will be passed to UIWebView

@property (strong, nonatomic) NSString *date; // will have to be string manipulated from JSON
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *excerpt;

@property (strong, nonatomic) NSArray *category; // array of strings for categories
@property (strong, nonatomic) NSArray *tags; // array of strings for tags

@property (strong, nonatomic) NSArray *images; // tentative; may be used to deal with image+caption pair loading


- (instancetype)initWith:(int)ID
                   Title:(NSString *)Title
                  Author:(Author *)Author
                    Body:(NSString *)Content
                     URL:(NSString *)URL
                 Excerpt:(NSString *)excerpt
                Category:(NSArray *)Category
                    Tags:(NSArray *)Tags
                    Images:(NSArray *)Images;

@end
