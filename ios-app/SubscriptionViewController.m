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
#import "CategoryViewController.h"

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
    needtoRefresh = false;
}

- (void)viewWillAppear:(BOOL)animated{
    if(needtoRefresh){
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
    NSLog((@"attempting to fetch data"));
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_NAME];
    NSArray *subscribedCategories = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    CategoryViewController *categoryVC = (CategoryViewController *)self.parentViewController;
    
    if (subscribedCategories.count == 0) {
        categoryVC.noSubscriptionsPrompt.hidden = NO;
    } else {
        categoryVC.noSubscriptionsPrompt.hidden = YES;
    }
    
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

- (void)fetchMoreItems {
    return;
}

@end
