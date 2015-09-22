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

@interface CategoryDetailViewController ()
@property (nonatomic) bool end;
@property (nonatomic) bool subscribed;
@property (strong, nonatomic) NSArray* subscribedCategories;
@property (strong, nonatomic) UIBarButtonItem * subscribe;

@end

@implementation CategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.end = false;
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor kNavBackgroundColor]];
    self.navigationController.navigationBar.tintColor = [UIColor kNavTextColor];
    self.subscribe = [[UIBarButtonItem alloc] initWithTitle:@"Subscribe" style:UIBarButtonItemStylePlain target:self action:@selector(subscribeCategory)];
    NSArray *actionButtonItems = @[self.subscribe];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    
    
}

- (void) viewDidAppear:(BOOL)animated{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSError * error = nil;
    self.subscribed = false;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Subscribed"];
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subscribed" inManagedObjectContext:managedObjectContext];
    //[fetchRequest setEntity:entity];
//    NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
//    
//    if(error){
//        NSLog(@"aiyah");
//        return;
//    }
//    NSLog(@"good");
    self.subscribedCategories = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //check if category is subscribed
    for (id sub in self.subscribedCategories) {
        NSString * s = [[sub valueForKey:@"id"] stringValue];
        if ([s isEqualToString:self.navigationItem.title]) {
            self.subscribed = true;
            break;
        }
    }
    [self updateSubscribe];
}

- (void)subscribeCategory {

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    //subscribing
    if(!self.subscribed){
        NSManagedObject *subscribedCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Subscribed" inManagedObjectContext:managedObjectContext];
        [subscribedCategory setValue:self.navigationItem.title forKey:@"id"];
        self.subscribed = true;
        [self updateSubscribe];
    }

    //unsubscribing
    else if(self.subscribed){
        //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Subscribed"];
        for(id sub in self.subscribedCategories){
            NSString * s = [[sub valueForKey:@"id"] stringValue];
            if ([s isEqualToString:self.navigationItem.title]) {
                [managedObjectContext delete:sub];
                self.subscribed = false;
                [self updateSubscribe];
                break;
            }
        }
//        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Subscribed" inManagedObjectContext:managedObjectContext]];
//        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"content == %d",self.navigationItem.title]];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //self.navigationController.navigationBar.tintColor = [UIColor kNavTextColor];
    //self.navigationItem.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
