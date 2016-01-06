//
//  Author.h
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDAuthor.h"

@interface Author : NSObject

@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *name; // includes full name when object-mapping
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSString *email;

// will use ID to get array of posts author has written

- (instancetype)initWith:(int)ID Name:(NSString *)name About:(NSString *)about AndEmail:(NSString *)email;
- (void)printInfo;
+ (Author *)authorFromCDAuthor:(CDAuthor *)cAuthor;

@end
