//
//  ViewController.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "ViewController.h"
#import "DataParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Start");
    
    NSArray *a = [DataParser DataForPostsInMonth:11 andYear:2014];
    [self dump:a];
    
    Post *b = [DataParser DataForPostID:9575];
    [b printInfo];
    
    NSArray *c = [DataParser DataForPostWithTag:@"health"];
    [self dump:c];
    
    NSArray *d = [DataParser DataForCategory:@"medicine"];
    [self dump:d];
    
    NSArray *e = [DataParser DataForAuthorInfoAndPostsWithAuthorID:238];
    [self dump:e];
    
    NSArray *f = [DataParser DataForFeaturedPosts];
    [self dump:f];
}

- (void)dump:(NSArray *)postArr {
    for (Post *post in postArr) {
        [post printInfo];
        NSLog(@"==================================");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
