//
//  OvertimeTVC.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 18/05/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface OvertimeTVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>

// Fetchedresultscontroller
@property (nonatomic, strong) NSFetchedResultsController *frc;

@property (nonatomic) double totalDouble;


//#warning These are never called.. Should I remove??
-(BOOL)isThereData;
-(NSNumber*)getTotalHours;
-(NSDate*)getStartDate;
-(NSDate*)getEndDate;
-(NSInteger)getTotalDays;

@end
