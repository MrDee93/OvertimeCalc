//
//  OvertimeVC.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 13/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OvertimeTVC.h"

@interface OvertimeVC : UIViewController


// List view
@property (nonatomic, strong) IBOutlet UIView *listviewContainer;
@property (nonatomic, strong) IBOutlet UIView *calendarviewContainer;


// Custom view to show ListView/CalendarView
//@property (nonatomic, strong) IBOutlet UIView *customView;

// To fetch data
@property (nonatomic, strong) OvertimeTVC *theOvertimeTVC;


// Fetchedresultscontroller
@property (nonatomic, strong) NSFetchedResultsController *frc;

@property (nonatomic) double totalDouble;

//@property (nonatomic, strong) UITableView *tableView;
/*
-(BOOL)isThereData;
-(NSNumber*)getTotalHours;
-(NSDate*)getStartDate;
-(NSDate*)getEndDate;
-(NSInteger)getTotalDays;
*/

// To pass array of dates
-(NSArray*)getDates;

@end
