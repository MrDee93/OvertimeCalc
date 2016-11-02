//
//  ViewOvertimeViewController.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 04/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "ViewOvertimeViewController.h"
#import "AppDelegate.h"
#import "Overtime.h"

@interface ViewOvertimeViewController ()

@end

@implementation ViewOvertimeViewController
{
    NSString *dateString;
    double hours;
    UITextField *textField;
    NSManagedObjectID *selectedObjectID;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // New nav bar colour
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
    
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveData)];
    self.navigationItem.rightBarButtonItem = submitButton;
    self.dateTextfield.text = dateString;

    self.hoursTextfield.text = [NSString stringWithFormat:@"%.1f",hours];
    self.hoursTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self setupGesture];
    
    
}
-(void)setupGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAnywhere)];
    [tapGesture setEnabled:YES];
    [self.view addGestureRecognizer:tapGesture];
}
-(IBAction)savePressed:(id)sender
{
    [self.hoursTextfield endEditing:YES];
    if(!selectedObjectID) {
        NSLog(@"ERROR: No object ID");
    } else {
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        Overtime *object = (Overtime*)[appdelegate.managedObjectContext objectWithID:selectedObjectID];
        
        NSNumber *newHours = [NSNumber numberWithDouble:[[self.hoursTextfield text] doubleValue]];
        object.hours = newHours;
        
        [appdelegate saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)saveData {
    [self.hoursTextfield endEditing:YES];
    if(!selectedObjectID) {
        NSLog(@"ERROR: No object ID");
    } else {
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        Overtime *object = (Overtime*)[appdelegate.managedObjectContext objectWithID:selectedObjectID];
        
        NSNumber *newHours = [NSNumber numberWithDouble:[[self.hoursTextfield text] doubleValue]];
        object.hours = newHours;
        
        [appdelegate saveContext];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"Saved data!");
    }
}
-(void)tappedAnywhere {
    [self.hoursTextfield endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)deleteOvertime:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    Overtime *overtimeObject = (Overtime*)[appDelegate.managedObjectContext objectWithID:selectedObjectID];
    [appDelegate.managedObjectContext deleteObject:overtimeObject];
    if([appDelegate.managedObjectContext save:nil]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"The chosen Overtime has been successfully deleted" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:dismiss];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


-(void)setHours:(double)theHours withDate:(NSString*)theDate{
    hours = theHours;
    dateString = theDate;
}
-(void)setSelectedObjectID:(NSManagedObjectID*)objectID {
    selectedObjectID = objectID;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
