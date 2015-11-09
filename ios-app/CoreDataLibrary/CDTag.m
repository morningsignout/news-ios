//
//  CDTag.m
//  ios-app
//
//  Created by Qingwei Lan on 11/8/15.
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CDTag.h"

@implementation CDTag

+ (CDTag *)tagWithName:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context
{
    CDTag *nTag = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDTag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", name];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || matches.count > 1) {
        NSLog(@"Error when fetching CDTag");
    } else if (matches.count == 1) {
        nTag = [matches firstObject];
    } else {
        nTag = [NSEntityDescription insertNewObjectForEntityForName:@"CDTag" inManagedObjectContext:context];
        nTag.name = name;
    }
    
    return nTag;
}

@end
