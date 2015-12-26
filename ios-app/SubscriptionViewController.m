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
@property (weak, nonatomic) IBOutlet UILabel *noSubscriptionsPrompt;
@property (weak, nonatomic) IBOutlet UIButton *viewCategoriesButton;

@end

@implementation SubscriptionViewController

static bool needtoRefresh;

- (void)viewDidLoad {
    [super viewDidLoad];
    needtoRefresh = false;
    [self.view bringSubviewToFront:self.noSubscriptionsPrompt];
    [self.view bringSubviewToFront:self.viewCategoriesButton];
    self.collectionView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - self.viewCategoriesButton.frame.size.height - 40);
    self.view.backgroundColor = [UIColor kCollectionViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated{
    if(needtoRefresh){
        needtoRefresh = false;
        [super loadPosts];
    }
    [self updateSubscriptionsPromptLabel];
}

- (void)updateSubscriptionsPromptLabel {
    if (self.subscribedContent.count == 0) {
        self.noSubscriptionsPrompt.hidden = NO;
    } else {
        self.noSubscriptionsPrompt.hidden = YES;
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
    
    [self updateSubscriptionsPromptLabel];
    
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

- (IBAction)returnToCategories:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
