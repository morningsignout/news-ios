//
//  PhotoInfo.m
//  ios-app
//
//  Created by Stella Chung on 9/2/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "PhotoInfo.h"

@implementation PhotoInfo

- (instancetype)initWithURL:(NSString *)url AndCaption:(NSString *)caption {
    if (self = [super init]) {
        _photoURL = url;
        _caption = caption;
    }
    return self;
}

@end
