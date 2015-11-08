//
//  Comment.m
//  ios-app
//
//  Created by Shannon Phu on 11/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (instancetype)initWithName:(NSString *)name Message:(NSString *)message AndDate:(NSString *)date {
    if (self = [super init]) {
        _senderName = name;
        _message = message;
        
        
        NSDateFormatter *stringToDateFormatter = [[NSDateFormatter alloc] init];
        [stringToDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDateFormatter *dateToStringFormatter = [[NSDateFormatter alloc] init];
        [dateToStringFormatter setDateFormat:@"MMMM dd, yyyy"];
        
        NSDate *dateObj = [stringToDateFormatter dateFromString:date];
        
        // convert date object back into MMMM dd, yyyy format
        _date = [dateToStringFormatter stringFromDate:dateObj];
    }
    return self;
}

- (void)print {
    NSLog(@"Sender: %@\nDate: %@\nMessage: %@", self.senderName, self.date, self.message);
}

@end
