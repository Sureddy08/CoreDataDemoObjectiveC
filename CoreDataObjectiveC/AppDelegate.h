//
//  AppDelegate.h
//  CoreDataObjectiveC
//
//  Created by VKS on 5/1/16.
//  Copyright © 2016 VKS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) CoreDataStack *coreDataStack;
-(void) addTestData;


@end

