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
    // Do any additional setup after loading the view, typically from a nib.
    
    /*// Some stress testing
    for (int i = 1; i < 5; i++) {
        [DataParser postsWithTag:@"health" InPage:i];
    }*/

    //
    //[DataParser DataForPostID:30562];
    //Post* post = [DataParser DataForPostID:30562];
    //NSLog(@"%@",[post title]);
    NSArray * posts = [DataParser DataForPostsInMonth:11 andYear:2014];
    for(int i = 0; i<[posts count]; i++)
    {
        NSLog(@"%@",[posts[i] title]);
    }
    //[DataParser DataForPostWithTag:@"empathy"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
