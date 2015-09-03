//
//  Post.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "Post.h"
#import "Author.h"

@implementation Post

- (instancetype)initWith:(int)ID
                   Title:(NSString *)Title
                  Author:(Author *)Author
                    Body:(NSString *)Content
                     URL:(NSString *)URL
                 Excerpt:(NSString *)excerpt
                    Date:(NSString *)date
                Category:(NSArray *)Category
                    Tags:(NSArray *)Tags
                  Images:(NSArray *)Images {
    if(self = [super init]) {
        _ID = ID;
        _title = Title;
        _author = Author;
        _body =  Content;
        _url = URL;
        _excerpt = excerpt;
        _date = date;
        _category = Category;
        _tags = Tags;
        _images = Images;
    }
    return self;
}

- (void)printInfo {
    NSLog(@"Title: %@", self.title);
    NSLog(@"Author:");
    [self.author printInfo];
    NSLog(@"Content: %@", self.body);
    NSLog(@"URL: %@", self.url);
    NSLog(@"Excerpt: %@", self.excerpt);
    NSLog(@"Date: %@", self.date);
    
    for (NSString *category in self.category) {
        NSLog(@"Category: %@", category);
    }
    
    for (NSString *tag in self.tags) {
        NSLog(@"Tag: %@", tag);
    }
    
    for (id image in self.images) {
        NSLog(@"Image: %@", image);
    }
}


@end
