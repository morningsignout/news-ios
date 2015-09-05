//
//  FeaturedViewController.m
//  ios-app
//
//  Created by Brandon Pon on 9/4/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "FeaturedViewController.h"
#import "FeatureTableViewController.h"
#import "FeatureCellViewController.h"
#import "FeaturedView.h"

@interface FeaturedViewController ()

@end

FeatureTableViewController *  featureTVC;
FeatureCellViewController * featureCell;

@implementation FeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    featureCell = [[FeatureCellViewController alloc] init];
    featureCell.view.frame = CGRectMake(0, 0, 320, 75);
    
    featureTVC = [[FeatureTableViewController alloc] init];
    featureTVC.view.frame = CGRectMake(0,75,320, 493);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
