//
//  Post.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "Post.h"

@implementation Post

+ (instancetype)initWith:(int)ID
                   Title:(NSString *)Title
                  Author:(Author *)Author
                    Body:(NSString *)Content
                     URL:(NSString *)URL
                 Excerpt:(NSString *)Excerpt
                Category:(NSArray *)Category
                    Tags:(NSArray *)Tags
                  Images:(NSArray *)Images{
    if(self = [super init]){
    _title = Title;
    _author = Author;
    _body =  Content;
    _url = URL;
    _excerpt = Excerpt;
    _category = Category;
    _tags = Tags;
    _images = Images;
    }
    return self;
}


@end
