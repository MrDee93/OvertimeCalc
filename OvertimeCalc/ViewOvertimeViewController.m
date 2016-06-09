//
//  ViewOvertimeViewController.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 04/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "ViewOvertimeViewController.h"
#import <CoreData/CoreData.h>

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
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveData)];
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
-(void)saveData {
    
}
-(void)tappedAnywhere {
    [self.hoursTextfield endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHours:(double)theHours withDate:(NSString*)theDate{
    hours = theHours;
    dateString = theDate;
}
-(void)setSelectedObjectID:(NSManagedObjectID*)objectID {
    selectedObjectID = objectID;
#warning Finish up finding a way to send over the Object so that the new modified data can be saved..
#warning Or Just use a AlertController to edit the data instead
    
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
