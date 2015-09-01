//
//  Author.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "Author.h"

@implementation Author

- (instancetype)initWith:(int)ID Name:(NSString *)Name About:(NSString *)About {
    if (self = [super init]) {
        _ID = ID;
        _name = Name;
        _about = About;
    }
    return self;
}

@end
