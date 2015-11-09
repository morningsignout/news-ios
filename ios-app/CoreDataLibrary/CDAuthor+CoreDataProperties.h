//
//  CDAuthor+CoreDataProperties.h
//  ios-app
//
//  Created by Qingwei Lan on 11/8/15.
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDAuthor.h"

@class CDPost;

NS_ASSUME_NONNULL_BEGIN

@interface CDAuthor (CoreDataProperties)

@property (nonatomic) int32_t identity;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *about;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSSet<CDPost *> *posts;

@end

@interface CDAuthor (CoreDataGeneratedAccessors)

- (void)addPostsObject:(CDPost *)value;
- (void)removePostsObject:(CDPost *)value;
- (void)addPosts:(NSSet<CDPost *> *)values;
- (void)removePosts:(NSSet<CDPost *> *)values;

@end

NS_ASSUME_NONNULL_END
