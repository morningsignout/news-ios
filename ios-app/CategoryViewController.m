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
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Categories";
    
}

- (void)viewWillAppear:(BOOL)animated {
    DropdownNavigationController *navVC = (DropdownNavigationController *)self.parentViewController.parentViewController;
    navVC.titleLabel.text = @"Categories";
    navVC.titleLabel.textColor = [UIColor kNavTextColor];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSubscriptions:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.containerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (IBAction)showCategories:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.containerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    }];

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
