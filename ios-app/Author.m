//
//  Author.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "Author.h"

@implementation Author

- (instancetype)initWith:(int)ID Name:(NSString *)name About:(NSString *)about AndEmail:(NSString *)email {
    if (self = [super init]) {
        _ID = ID;
        _name = name;
        _about = about;
        _email = email;
    }
    return self;
}

- (void)printInfo {
    NSLog(@"ID: %d", self.ID);
    NSLog(@"Name: %@", self.name);
    NSLog(@"About: %@", self.about);
    NSLog(@"Email: %@", self.email);
}

@end
