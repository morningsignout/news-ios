//
//  CDCategory.m
//  ios-app
//
//  Created by Qingwei Lan on 11/8/15.
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CDCategory.h"

@implementation CDCategory

+ (CDCategory *)categoryWithName:(NSString *)name
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    CDCategory *nCategory = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDCategory"];
    request.predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", name];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || matches.count > 1) {
        NSLog(@"Error when fetching CDCategory, %@, %lu", error, (unsigned long)matches.count);
    } else if (matches.count == 1) {
        NSLog(@"Core Data found Category: %@", name);
        nCategory = [matches firstObject];
    } else {
        NSLog(@"Core Data didn't find Category, inserting Category: %@", name);
        nCategory = [NSEntityDescription insertNewObjectForEntityForName:@"CDCategory" inManagedObjectContext:context];
        nCategory.name = name;
        nCategory.subscribed = NO;
    }
    
    return nCategory;
}

+ (void)deleteCategoryWithName:(NSString *)name
      fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDCategory"];
    request.predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", name];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || matches.count > 1) {
        NSLog(@"Error when fetching CDCategory, %@, %lu", error, (unsigned long)matches.count);
    } else if (matches.count == 1) {
        NSLog(@"Core Data found Category to delete: %@", name);
        NSManagedObject *object = [matches firstObject];
        [context deleteObject:object];
    } else {
        NSLog(@"Core Data didn't find Category: %@", name);
    }
}

+ (void)subscribeToCategoryWithName:(NSString *)name
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDCategory"];
    request.predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", name];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || matches.count > 1) {
        NSLog(@"Error when fetching CDCategory, %@, %lu", error, (unsigned long)matches.count);
    } else if (matches.count == 1) {
        NSLog(@"Core Data found Category to subscribe to: %@", name);
        CDCategory *category = [matches firstObject];
        category.subscribed = YES;
    } else {
        NSLog(@"Core Data didn't find Category, inserting category: %@", name);
        CDCategory *category = [self categoryWithName:name inManagedObjectContext:context];
        category.subscribed = YES;
    }
}

+ (void)unsubscribeFromCategoryWithName:(NSString *)name
                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDCategory"];
    request.predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", name];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || matches.count > 1) {
        NSLog(@"Error when fetching CDCategory %@, %lu", error, (unsigned long)matches.count);
    } else if (matches.count == 1) {
        NSLog(@"Core Data found Category to unsubscribe from: %@", name);
        CDCategory *category = [matches firstObject];
        category.subscribed = NO;
    } else {
        NSLog(@"Core Data didn't find Category, inserting category: %@", name);
        CDCategory *category = [self categoryWithName:name inManagedObjectContext:context];
        category.subscribed = NO;
    }
}

+ (BOOL)isCategorySubscribed:(NSString *)name
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    BOOL isSubscribed = NO;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDCategory"];
    request.predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", name];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || matches.count > 1) {
        NSLog(@"Error when fetching CDCategory, %@, %lu", error, (unsigned long)matches.count);
    } else if (matches.count == 1) {
        NSLog(@"Core Data found Category to check if subscribed: %@", name);
        CDCategory *category = [matches firstObject];
        isSubscribed = category.subscribed;
    } else {
        NSLog(@"Core Data didn't find Category to check if subscribed, inserting category: %@", name);
        [CDCategory categoryWithName:name inManagedObjectContext:context];
    }
    
    return isSubscribed;
}

+ (NSArray *)subscribedCategoriesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableArray *subscribedCategories = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDCategory"];
    request.predicate = [NSPredicate predicateWithFormat:@"subscribed == 1"];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error when fetching CDCategory, %@", error);
    } else if (matches.count) {
        NSLog(@"Core Data found subscribed categories");
        for (CDCategory *category in matches) {
            [subscribedCategories addObject:category.name];
            NSLog(@"Core Data found subscribed category: %@", category.name);
        }
    }
    
    return subscribedCategories;
}

@end
