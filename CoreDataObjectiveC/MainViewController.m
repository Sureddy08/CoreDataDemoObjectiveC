//
//  MainViewController.m
//  CoreDataObjectiveC
//
//  Created by VKS on 5/1/16.
//  Copyright © 2016 VKS. All rights reserved.
//

#import "MainViewController.h"
#import "CoreDataStack.h"
#import "AppDelegate.h"
#import "Person.h"
#import "PersonDetailTableViewController.h"
#define appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface MainViewController ()<NSFetchedResultsControllerDelegate>
@property(strong,nonatomic) CoreDataStack *coreDataStack;
@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.coreDataStack = appDelegate.coreDataStack;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext: self.coreDataStack.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    self.fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchController.delegate = self;
    [self.fetchController performFetch:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [self reloadData];
}
- (IBAction)addPerson:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a Person" message:@"Name" preferredStyle: UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields[0];
        if(![textField.text isEqual:@""]){
            Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.coreDataStack.managedObjectContext];
            person.name = textField.text;
            NSError *error = nil;
            if(![self.coreDataStack.managedObjectContext save:&error]) {
                [self.coreDataStack.managedObjectContext deleteObject:person];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"A person's name must be longer than a single character!" preferredStyle: UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:true completion:nil];            }
            [self reloadData];
        }
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

-(void)reloadData{
    [[self fetchController] performFetch:nil];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchController.sections[section];
    return [sectionInfo objects].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Person *person = [self.fetchController objectAtIndexPath:indexPath];
    cell.textLabel.text = person.name;
    if(person.image != nil){
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.imageView.image = person.image;
        [cell.imageView setNeedsLayout];
    });
    }
    else{
        cell.imageView.image = person.image;
    }
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Person *person = [self.fetchController objectAtIndexPath:indexPath];
        [self.coreDataStack.managedObjectContext deleteObject:person];
        [self.fetchController performFetch:nil];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier  isEqual: @"showPersonDetail"]){
        PersonDetailTableViewController *personDetailVC = (PersonDetailTableViewController *) segue.destinationViewController;
        personDetailVC.coreDataStack = self.coreDataStack;
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchController.sections[selectedIndexPath.section];
        Person *person = [[sectionInfo objects] objectAtIndex:selectedIndexPath.row];
        personDetailVC.person = person;
    }

}


@end
