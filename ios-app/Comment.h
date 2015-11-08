//
//  Comment.h
//  ios-app
//
//  Created by Shannon Phu on 11/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *date;

- (instancetype)initWithName:(NSString *)name Message:(NSString *)message AndDate:(NSString *)date;
- (void)print;

@end
