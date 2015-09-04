//
//  Author.h
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Author : NSObject

@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *name; // includes full name when object-mapping
@property (strong, nonatomic) NSString *about;

// will use ID to get array of posts author has written

- (instancetype)initWith:(int)ID Name:(NSString *)Name About:(NSString *)About;
- (void)printInfo;

@end
