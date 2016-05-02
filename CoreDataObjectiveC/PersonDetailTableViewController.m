//
//  PersonDetailTableViewController.m
//  CoreDataObjectiveC
//
//  Created by VKS on 5/1/16.
//  Copyright © 2016 VKS. All rights reserved.
//

#import "PersonDetailTableViewController.h"

@interface PersonDetailTableViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UILabel *personName;

@end

@implementation PersonDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.personName.text = self.person.name;
    self.personImageView.image = self.person.image;
    self.navigationItem.title = self.person.name;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    self.person.image = self.personImageView.image;
    self.person.name = self.personName.text;
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    [[self coreDataStack] saveContext];
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSTimeInterval elapsedTime = (endTime - startTime) * 1000;
    NSLog(@"Elapsed Time = %f ms", elapsedTime);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Display Person Image" message:nil preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        if (self.personImageView.image != nil) {
            [alert addAction:[UIAlertAction actionWithTitle:@"Remove Image" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.personImageView.image = nil;
                });
            }]];
        }
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Select Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                
                [self presentViewController:picker animated:true completion:nil];
            });
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *selectedImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.personImageView.image = selectedImage;
    });
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:true completion:NULL];
}

@end
