//
//  CategoryViewController.m
//  ios-app
//
//  Created by Brandon Pon on 9/10/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CategoryViewController.h"
#import "DataParser.h"
#import "DropdownNavigationController.h"
#import "CategoryDetailViewController.h"
#include "Constants.h"

@interface CategoryViewController ()

@property (strong, nonatomic) NSArray *categoryNames;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Categories";
}

- (void)viewWillAppear:(BOOL)animated {
    DropdownNavigationController *navVC = (DropdownNavigationController *)self.parentViewController.parentViewController;
    navVC.titleLabel.text = @"Categories";
    navVC.titleLabel.textColor = [UIColor kNavTextColor];
    navVC.navigationItem.title = @"Categories";
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[CategoryDetailViewController class]]) {
        CategoryDetailViewController *newVC = segue.destinationViewController;
        newVC.categoryType = segue.identifier;
        newVC.navigationItem.title = ((UIButton*)sender).titleLabel.text;
    }
}


@end
