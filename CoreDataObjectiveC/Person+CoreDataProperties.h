//
//  Person+CoreDataProperties.h
//  CoreDataObjectiveC
//
//  Created by VKS on 5/1/16.
//  Copyright © 2016 VKS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) id image;

@end

NS_ASSUME_NONNULL_END
