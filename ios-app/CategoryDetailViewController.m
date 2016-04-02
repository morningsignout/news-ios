//
//  CategoryDetailViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/18/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CategoryDetailViewController.h"
#import "SubscriptionViewController.h"
#import "DataParser.h"
#import "Constants.h"
#import <CoreData/CoreData.h>
#import "CDCategory.h"

@interface CategoryDetailViewController ()
@property (nonatomic) bool end;
@property (nonatomic) bool subscribed;
@property (strong, nonatomic) UIBarButtonItem * subscribe;
@end

@implementation CategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.end = false;
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor kNavBackgroundColor]];
    self.navigationController.navigationBar.tintColor = [UIColor kNavTextColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor kNavTextColor]}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.subscribed = [CDCategory isCategorySubscribed:self.categoryName
                                inManagedObjectContext:self.delegate.managedObjectContext];
    [self.delegate saveContext];
    
//    // Deal with loading subscription info from core data
//    self.subscribed = false;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_NAME];
//    self.subscribedCategories = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    
//    //check if this category is subscribed to
//    for (id sub in self.subscribedCategories) {
//        NSString * s = [sub valueForKey:ENTITY_ATTRIBUTE];
//        if ([s isEqualToString:self.categoryType]) {
//            self.subscribed = true;
//            break;
//        }
//    }
    [self updateSubscribe];
}

- (UIBarButtonItem *)subscribe {
    if (!_subscribe) {
        
        NSString *subscribeButtonText;
        if (self.subscribed) {
            subscribeButtonText = @"Unsubscribe";
        } else {
            subscribeButtonText = @"Subscribe";
        }
        
        _subscribe = [[UIBarButtonItem alloc] initWithTitle:subscribeButtonText style:UIBarButtonItemStylePlain target:self action:@selector(subscribeCategory)];
        NSArray *actionButtonItems = @[_subscribe];
        self.navigationItem.rightBarButtonItems = actionButtonItems;
    }
    return _subscribe;
}

- (void)subscribeCategory {
    
    //inform subscribeview to update
    //[SubscriptionViewController updateCategories];
    
    //subscribing from this category
    if(!self.subscribed){
        [CDCategory subscribeToCategoryWithName:self.categoryName inManagedObjectContext:self.delegate.managedObjectContext];
        [self.delegate saveContext];
        self.subscribed = YES;
    }

    //unsubscribing from this category
    else if (self.subscribed) {
        [CDCategory unsubscribeFromCategoryWithName:self.categoryName inManagedObjectContext:self.delegate.managedObjectContext];
        [self.delegate saveContext];
        self.subscribed = NO;
    }

    [self updateSubscribe];
}

- (void)updateSubscribe{
    if(self.subscribed)
        [self.subscribe setTitle:@"Unsubscribe"];
    else
        [self.subscribe setTitle:@"Subscribe"];
}

- (NSArray *)getDataForTypeOfView {
    NSArray *data = [DataParser DataForCategory:self.categoryType AndPageNumber:self.page];
    //for (Post *post in data)
      //  [post printInfo];
    return data;
}

- (void) setEndOfPosts:(bool)set{
    self.end = set;
}

- (BOOL) getEndOfPosts{
    return self.end;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)isCategory
{
    return YES;
}

- (NSString *)categoryName
{
    if ([self.categoryType isEqualToString:@"public-health"])
        return @"Public Health";
    else if ([self.categoryType isEqualToString:@"premed_advice"])
        return @"Premed Advising";
    return self.categoryType;
}

@end
