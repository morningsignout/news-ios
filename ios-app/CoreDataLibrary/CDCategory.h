//
//  CDCategory.h
//  ios-app
//
//  Created by Qingwei Lan on 11/8/15.
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDCategory : NSManagedObject

+ (CDCategory *)categoryWithName:(NSString *)name
          inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteCategoryWithName:(NSString *)name
      fromManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)subscribeToCategoryWithName:(NSString *)name
             inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)unsubscribeFromCategoryWithName:(NSString *)name
                 inManagedObjectContext:(NSManagedObjectContext *)context;

+ (BOOL)isCategorySubscribed:(NSString *)name
      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)subscribedCategoriesInManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "CDCategory+CoreDataProperties.h"
