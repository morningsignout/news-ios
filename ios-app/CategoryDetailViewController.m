//
//  CategoryDetailViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/18/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CategoryDetailViewController.h"
#import "DataParser.h"
#import "Constants.h"
#import <CoreData/CoreData.h>

#define ENTITY_NAME @"Subscription"
#define ENTITY_ATTRIBUTE @"categoryName"

@interface CategoryDetailViewController ()
@property (nonatomic) bool end;
@property (nonatomic) bool subscribed;
@property (strong, nonatomic) NSMutableArray* subscribedCategories;
@property (strong, nonatomic) UIBarButtonItem * subscribe;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
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
    //self.navigationController.navigationBar.tintColor = [UIColor kNavTextColor];
    
    // Deal with loading subscription info from core data
    self.subscribed = false;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_NAME];
    self.subscribedCategories = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //check if this category is subscribed to
    for (id sub in self.subscribedCategories) {
        NSString * s = [sub valueForKey:ENTITY_ATTRIBUTE];
        if ([s isEqualToString:self.categoryType]) {
            self.subscribed = true;
            break;
        }
    }
    [self updateSubscribe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //subscribing from this category
    if(!self.subscribed){
        NSManagedObject *subscribedCategory = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
        [subscribedCategory setValue:self.categoryType forKey:ENTITY_ATTRIBUTE];
        self.subscribed = true;
        [self.subscribedCategories addObject:subscribedCategory];
        [self updateSubscribe];
    }

    //unsubscribing from this category
    else if (self.subscribed) {
        
        for (NSManagedObject *sub in self.subscribedCategories){
            NSString *s = [sub valueForKey:ENTITY_ATTRIBUTE];
            
            if ([s isEqualToString:self.categoryType]) {
                [self.managedObjectContext deleteObject:sub];
                self.subscribed = false;
                [self updateSubscribe];
                break;
            }
        }
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }

    [self updateSubscribe];
}

- (void)updateSubscribe{
    if(self.subscribed){
        [self.subscribe setTitle:@"Unsubscribe"];
    }
    else{
        [self.subscribe setTitle:@"Subscribe"];
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSArray *)getDataForTypeOfView {
    return [DataParser DataForCategory:self.categoryType AndPageNumber:self.page];
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

@end
