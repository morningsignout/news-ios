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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad) name:@"dataLoaded" object:nil];
    
    NSLog(@"Start");
    
    NSArray *a = [DataParser DataForPostsInMonth:11 Year:2014 AndPage:1];
    [self dump:a];
    
    Post *b = [DataParser DataForPostID:9575];
    [b printInfo];
    
    for (int i = 0; i < 3; i++) {
        NSArray *c = [DataParser DataForPostWithTag:@"health" AndPageNumber:i];
        NSLog(@"%d", (int)c.count);
        [self dump:c];
    }
   
    for (int i = 0; i < 5; i++) {
        NSArray *d = [DataParser DataForCategory:@"medicine" AndPageNumber:i];
        NSLog(@"%d", (int)d.count);
        [self dump:d];
    }
    
    NSArray *e = [DataParser DataForAuthorInfoAndPostsWithAuthorID:238];
    [self dump:e];
    
    NSArray *f = [DataParser DataForFeaturedPostsWithPageNumber:1];
    [self dump:f];
    
    NSArray *h = [DataParser DataForPostsInYear:2015 AndInPage:1];
    [self dump:h];
    NSLog(@"***");
    NSArray *i = [DataParser DataForAuthorInfoAndPostsWithAuthorID:238];
    [self dump:i];
}

- (void)dataDidLoad {
    NSLog(@"SUCCESS");
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
