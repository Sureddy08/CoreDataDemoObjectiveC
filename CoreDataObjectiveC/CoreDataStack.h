//
//  CoreDataStack.h
//  CoreDataPOC
//
//  Created by VKS on 4/2/16.
//  Copyright © 2016 VKS. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface CoreDataStack : NSObject



@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
