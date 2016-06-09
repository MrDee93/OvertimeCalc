//
//  ViewOvertimeViewController.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 04/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewOvertimeViewController : UIViewController



@property (nonatomic, strong) IBOutlet UITextField *dateTextfield;
@property (nonatomic, strong) IBOutlet UITextField *hoursTextfield;

-(void)setHours:(double)theHours withDate:(NSString*)theDate;

@end
