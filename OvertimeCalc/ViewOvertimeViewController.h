//
//  ViewOvertimeViewController.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 04/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewOvertimeViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *dateTextfield;
@property (nonatomic, strong) IBOutlet UITextField *hoursTextfield;
@property (nonatomic, strong) IBOutlet UITextField *customPayTextfield;

@property bool customPayBool;
-(void)setHours:(double)theHours withDate:(NSString*)theDate;
-(void)setHours:(double)theHours withDate:(NSString *)theDate withCustomPay:(double)customPay;
-(void)setSelectedObjectID:(NSManagedObjectID*)objectID;

@end
