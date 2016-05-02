//
//  CoreDataStack.m
//  CoreDataPOC
//
//  Created by VKS on 4/2/16.
//  Copyright © 2016 VKS. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack()

@property (strong,nonatomic) NSManagedObjectContext *saveManagedObjectContext;

@end

@implementation CoreDataStack

@synthesize saveManagedObjectContext = _saveManagedObjectContext;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "sureddy.CoreDataPOC" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



-(NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL * documentDirectory = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL * storeFile = [documentDirectory URLByAppendingPathComponent:@"CoreDataObjectiveC.sqlite"];
    
    NSError * error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeFile options:nil error:&error])
    {
        NSLog(@"Error: %@", error);
    }
    return _persistentStoreCoordinator;
}


-(NSManagedObjectModel *) managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataObjectiveC" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

-(NSManagedObjectContext *)saveManagedObjectContext{
    if (_saveManagedObjectContext != nil) {
        return _saveManagedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _saveManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_saveManagedObjectContext setPersistentStoreCoordinator:coordinator];
    return _saveManagedObjectContext;


}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.parentContext = self.saveManagedObjectContext;
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSManagedObjectContext *saveManagedObjectContext = self.saveManagedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] || [saveManagedObjectContext hasChanges]){
            [managedObjectContext performBlockAndWait:^{
                NSError *error = nil;
                if(![managedObjectContext save:&error]) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   // abort();
                }
            }];
            [saveManagedObjectContext performBlock:^{
                NSError *error = nil;
                if(![saveManagedObjectContext save:&error]) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }];
        }
    }
}

@end
