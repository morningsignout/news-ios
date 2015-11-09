//
//  CDPost.m
//  ios-app
//
//  Created by Qingwei Lan on 11/8/15.
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CDPost.h"
#import "CDAuthor.h"
#import "CDTag.h"
#import "CDCategory.h"
#import "Post.h"

@implementation CDPost

+ (CDPost *)postWithPost:(Post *)post
  inManagedObjectContext:(NSManagedObjectContext *)context
{
    CDPost *nPost = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDPost"];
    request.predicate = [NSPredicate predicateWithFormat:@"identity == %d", post.ID];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || matches.count > 1) {
        NSLog(@"Error when fetching CDPost");
    } else if (matches.count == 1) {
        nPost = [matches firstObject];
    } else {
        nPost = [NSEntityDescription insertNewObjectForEntityForName:@"CDAuthor" inManagedObjectContext:context];
        nPost.identity = post.ID;
        nPost.body = post.body;
        nPost.date = post.date;
        nPost.excerpt = post.excerpt;
        nPost.fullCoverImageURL = post.fullCoverImageURL;
        nPost.thumbnailCoverImageURL = post.thumbnailCoverImageURL;
        nPost.title = post.title;
        nPost.url = post.url;
        nPost.authoredBy = [CDAuthor authorWithAuthor:post.author inManagedObjectContext:context];
        for (NSString *tag in post.tags) {
            [nPost addTagsObject:[CDTag tagWithName:tag inManagedObjectContext:context]];
        }
        for (NSString *category in post.category) {
            [nPost addCategoriesObject:[CDCategory categoryWithName:category inManagedObjectContext:context]];
        }
    }
    
    return nPost;
}

@end
