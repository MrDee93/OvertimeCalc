//
//  OvertimeTVC.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 18/05/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "OvertimeTVC.h"
#import "AppDelegate.h"
#import "Overtime+CoreDataClass.h"
#import "DateFormat.h"
#import "TotalTVC.h"
#import "ViewOvertimeViewController.h"
#import "Faulter.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (SCREEN_MAX_LENGTH == 736.0)

@interface OvertimeTVC ()

@end

@implementation OvertimeTVC
{
    AppDelegate *appDelegate;
}
     
-(void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupCoreData {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Overtime"];
    [fetch setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[appDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    [self updateView];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(void)viewWillDisappear:(BOOL)animated {
    appDelegate = nil;
    
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupCoreData];
    [self somethingChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingChanged) name:@"SomethingChanged" object:nil];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SomethingChanged" object:nil];
}

-(void)somethingChanged {
    //NSLog(@"Something changed, updating TableViewController!");
    NSError *error = nil;
    if(![self.frc performFetch:&error]) {
        NSLog(@"ERROR: Failed to fetch. %@ (%@)", error.userInfo, error.localizedDescription);
    }
    [self updateView];
    
    self.totalDouble = [[self getTotalHours] doubleValue];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateView {
    [self.tableView reloadData];
    
    // Refresh calendar view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCalendar" object:nil];
}


#pragma mark - Fetching data methods from TotalTVC

-(BOOL)isThereData {
    if(self.frc.fetchedObjects.count >= 1) {
        return YES;
    } else {
        return NO;
    }
}
-(NSNumber*)getTotalCustomPay {
    double totalValue = 0;
    
    for (Overtime *overtime in self.frc.fetchedObjects) {
        if ([overtime.customPay boolValue] == true) {
            double customPay = [overtime.hours doubleValue] * [overtime.payrate doubleValue];
            totalValue = totalValue + customPay;
        }
    }
    return [NSNumber numberWithDouble:totalValue];
}
-(NSNumber*)getTotalHours {
    NSNumber *totalHours;
    double totalValue = 0;
    
    for(Overtime *overtime in self.frc.fetchedObjects) {
        if ([overtime.customPay boolValue] == false) {
        totalValue = totalValue + [overtime.hours doubleValue];
        }
    }
    totalHours = [NSNumber numberWithDouble:totalValue];
    return totalHours;
}
-(NSDate*)getStartDate {
    if(self.frc.fetchedObjects) {
        Overtime *startObj = (Overtime*)[self.frc.fetchedObjects lastObject];
        return startObj.date;
    } else {
        NSLog(@"ERROR: Unable to fetch start date");
        return nil;
    }
}
-(NSDate*)getEndDate {
    if(self.frc.fetchedObjects) {
        Overtime *endObj = (Overtime*)[self.frc.fetchedObjects firstObject];
        return endObj.date;
    } else {
        NSLog(@"ERROR: Unable to fetch end date");
        return nil;
    }
}
-(NSInteger)getTotalDays {
    if(self.frc.fetchedObjects) {
        return [self.frc.fetchedObjects count];
    } else {
        NSLog(@"ERROR: Unable to fetch total days");
        return 0;
    }
}

-(NSNumber*)loadDateSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults valueForKey:@"DateStyleIndex"]) {
        //NSLog(@"Date style is DEFAULT.");
        return [NSNumber numberWithInt:0];
    } else {
        //NSLog(@"Date style is US STYLE.");
        return [NSNumber numberWithInt:1];
    }
}
-(BOOL)testIfFloatIsNecessary:(NSNumber*)number {
    float firstNum = number.floatValue;
    int secondNum = number.intValue;
    
    NSLog(@"First num: %f", firstNum);
    NSLog(@"Second num: %i", secondNum);
    
    if(firstNum == secondNum) {
        return false;
    }
    return true;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.frc.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Overtime *cellObject = [self.frc objectAtIndexPath:indexPath];
    
    NSString *dateString;
    
    if([[self loadDateSettings] intValue] == 1) {
        dateString = [NSString stringWithString:[DateFormat getFullUSStyleDate:cellObject.date]];
    } else {
        dateString = [NSString stringWithString:[DateFormat getFullUKStyleDate:cellObject.date]];
    }
    
    if([self testIfFloatIsNecessary:cellObject.hours]) {
        if ([cellObject.customPay boolValue] == true) {
            cell.textLabel.text = [NSString stringWithFormat:@"(CustomPay) %@ = %.1f hours", dateString, [cellObject.hours doubleValue]];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ = %.1f hours", dateString, [cellObject.hours doubleValue]];
        }
    } else {
        if ([cellObject.customPay boolValue] == true) {
            cell.textLabel.text = [NSString stringWithFormat:@"(CustomPay) %@ = %i hours", dateString, [cellObject.hours intValue]];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ = %i hours", dateString, [cellObject.hours intValue]];
        }
    }
    
    
    
    if(IS_IPHONE_5) {
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Overtime *selectedObj = [self.frc objectAtIndexPath:indexPath];
    
    ViewOvertimeViewController *viewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewOvertimeViewController"];
    if ([selectedObj.customPay boolValue] == true) {
        viewVC.customPayBool = true;
        double customPayrate = [selectedObj.payrate doubleValue];
        if([[self loadDateSettings] intValue] == 1) {
            [viewVC setHours:[selectedObj.hours doubleValue] withDate:[DateFormat getFullUSStyleDate:selectedObj.date] withCustomPay:customPayrate];
        } else {
            [viewVC setHours:[selectedObj.hours doubleValue] withDate:[DateFormat getFullUKStyleDate:selectedObj.date] withCustomPay:customPayrate];
        }
    } else {
        viewVC.customPayBool = false;
    if([[self loadDateSettings] intValue] == 1) {
        [viewVC setHours:[selectedObj.hours doubleValue] withDate:[DateFormat getFullUSStyleDate:selectedObj.date]];
    } else {
        [viewVC setHours:[selectedObj.hours doubleValue] withDate:[DateFormat getFullUKStyleDate:selectedObj.date]];
    }
    }
    [viewVC setSelectedObjectID:selectedObj.objectID];
    
    [self.navigationController pushViewController:viewVC animated:YES];
}


-(void)confirmRemoval:(Overtime*)overtimeEntry {
    NSString *dateString;
    if([[self loadDateSettings] intValue] == 1) {
        dateString = [NSString stringWithString:[DateFormat getUSStyleDate:overtimeEntry.date]];
    } else {
        dateString = [NSString stringWithString:[DateFormat getUKStyleDate:overtimeEntry.date]];
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Delete" message:[NSString stringWithFormat:@"Confirm deletion of\n'%@'", dateString] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteEntry:overtimeEntry];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:cancel];
    [alertC addAction:confirm];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)deleteEntry:(Overtime*)overtimeEntry {
    [appDelegate.managedObjectContext deleteObject:overtimeEntry];
    [appDelegate saveContext];
    [self somethingChanged];
    
    //NSLog(@"Deleted object.");
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        Overtime *overtimeObject = (Overtime*)[self.frc objectAtIndexPath:indexPath];
        
        [self confirmRemoval:overtimeObject];
    }
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
