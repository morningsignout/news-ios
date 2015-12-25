//
//  SubscriptionViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/26/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "DataParser.h"
#import <CoreData/CoreData.h>
#include "Constants.h"

#define ENTITY_NAME @"Subscription"
#define ENTITY_ATTRIBUTE @"categoryName"

@interface SubscriptionViewController ()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *subscribedContent;

@end

@implementation SubscriptionViewController

static bool needtoRefresh;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Subscriptions";
    needtoRefresh = false;
    self.view.backgroundColor = [UIColor kCollectionViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated{    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor kNavBackgroundColor]];
    self.navigationController.navigationBar.tintColor = [UIColor kNavTextColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor kNavTextColor]};
    
    if (needtoRefresh) {
        needtoRefresh = false;
        [super loadPosts];
    }
}

- (NSArray *)getDataForTypeOfView {
    self.subscribedContent = nil;
    [self insertIntoSubscribedContent];
    return self.subscribedContent;
}

+ (void)updateCategories {
    needtoRefresh = true;
}

- (void)insertIntoSubscribedContent {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_NAME];
    NSArray *subscribedCategories = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (id sub in subscribedCategories) {
        NSString *s = [sub valueForKey:ENTITY_ATTRIBUTE];
        NSArray *content = [DataParser DataForCategory:s AndPageNumber:self.page];
        [self.subscribedContent addObjectsFromArray:content];
    }
    
}

- (NSMutableArray *)subscribedContent {
    if (!_subscribedContent) {
        _subscribedContent = [NSMutableArray array];
    }
    return _subscribedContent;
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

@end
