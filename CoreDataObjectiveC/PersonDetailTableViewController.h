//
//  PersonDetailTableViewController.h
//  CoreDataObjectiveC
//
//  Created by VKS on 5/1/16.
//  Copyright © 2016 VKS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"
#import "Person.h"

@interface PersonDetailTableViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) CoreDataStack *coreDataStack;
@property (strong,nonatomic) Person *person;
@end
