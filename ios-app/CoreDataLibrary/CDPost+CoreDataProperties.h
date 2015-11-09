//
//  CDPost+CoreDataProperties.h
//  ios-app
//
//  Created by Qingwei Lan on 11/8/15.
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPost.h"

@class CDCategory, CDTag, CDAuthor;

NS_ASSUME_NONNULL_BEGIN

@interface CDPost (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *excerpt;
@property (nullable, nonatomic, retain) NSString *fullCoverImageURL;
@property (nonatomic) int32_t identity;
@property (nullable, nonatomic, retain) NSString *thumbnailCoverImageURL;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) CDAuthor *authoredBy;
@property (nullable, nonatomic, retain) NSSet<CDTag *> *tags;
@property (nullable, nonatomic, retain) NSSet<CDCategory *> *categories;

@end

@interface CDPost (CoreDataGeneratedAccessors)

- (void)addTagsObject:(CDTag *)value;
- (void)removeTagsObject:(CDTag *)value;
- (void)addTags:(NSSet<CDTag *> *)values;
- (void)removeTags:(NSSet<CDTag *> *)values;

- (void)addCategoriesObject:(CDCategory *)value;
- (void)removeCategoriesObject:(CDCategory *)value;
- (void)addCategories:(NSSet<CDCategory *> *)values;
- (void)removeCategories:(NSSet<CDCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
