//
//  TestViewController.m
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "TestViewController.h"
#import "DataParser.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad) name:@"dataLoaded" object:nil];
    
    // Stress testing for performance. In the console after all output logged,
    // Ctrl-F for "SUCCESS" and find time difference to estimate average time requests take.
    
    //NSLog(@"Start");
    
    Post*a = [DataParser DataForPostID:30562];
    //NSArray *c = [DataParser DataForPostWithTag:@"health" AndPageNumber:1];
    //NSArray *a = [DataParser DataForPostsInMonth:11 Year:2014 AndPage:1];
    [a printInfo];
    
    /*
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
     */

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
