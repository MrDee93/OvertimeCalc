//
//  TotalTVC.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 18/05/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OvertimeTVC.h"
#import "OvertimeVC.h"
#import "TotalsTableViewCell.h"

@interface TotalTVC : UITableViewController

@property (nonatomic, weak) OvertimeTVC *overtimeTVC;
@property (nonatomic, weak) OvertimeVC *overtimeVC;


// Tableview Data
@property (weak) IBOutlet TotalsTableViewCell *startDateCell;
@property (weak) IBOutlet TotalsTableViewCell *endDateCell;
@property (weak) IBOutlet TotalsTableViewCell *daysWorkedCell;
@property (weak) IBOutlet TotalsTableViewCell *hoursWorkedCell;
@property (weak) IBOutlet TotalsTableViewCell *payPerHourCell;
@property (weak) IBOutlet TotalsTableViewCell *standardPayCell;

// New cells
@property (weak) IBOutlet TotalsTableViewCell *customPayCell;
@property (weak) IBOutlet TotalsTableViewCell *totalPayCell;

//@property (nonatomic, strong) UILabel *startDateLabel;
//@property (nonatomic, strong) UILabel *endDateLabel;


@end
