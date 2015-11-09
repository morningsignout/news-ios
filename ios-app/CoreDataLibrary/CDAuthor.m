//
//  CDAuthor.m
//  ios-app
//
//  Created by Qingwei Lan on 11/8/15.
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CDAuthor.h"
#import "Author.h"

@implementation CDAuthor

+ (CDAuthor *)authorWithAuthor:(Author *)author
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    CDAuthor *nAuthor = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDAuthor"];
    request.predicate = [NSPredicate predicateWithFormat:@"identity == %d", author.ID];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || matches.count > 1) {
        NSLog(@"Error when fetching CDAuthor");
    } else if (matches.count == 1) {
        NSLog(@"Core Data found Author: %d", author.ID);
        nAuthor = [matches firstObject];
    } else {
        NSLog(@"Core Data didn't find Author, inserting Author: %d", author.ID);
        nAuthor = [NSEntityDescription insertNewObjectForEntityForName:@"CDAuthor" inManagedObjectContext:context];
        nAuthor.identity = author.ID;
        nAuthor.name = author.name;
        nAuthor.about = author.about;
        nAuthor.email = author.email;
    }
    
    return nAuthor;
}

+ (void)deleteAuthorWithID:(int)identity
  fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDAuthor"];
    request.predicate = [NSPredicate predicateWithFormat:@"identity == %d", identity];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || matches.count > 1) {
        NSLog(@"Error when fetching CDAuthor");
    } else if (matches.count == 1) {
        NSLog(@"Core Data found Author to delete: %d, ", identity);
        NSManagedObject *object = [matches firstObject];
        [context deleteObject:object];
    } else {
        NSLog(@"Core Data didn't find Author: %d", identity);
    }
}

@end
