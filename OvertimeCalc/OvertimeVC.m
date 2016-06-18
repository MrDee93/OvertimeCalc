//
//  OvertimeVC.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 13/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "OvertimeVC.h"
#import "AppDelegate.h"
#import "Overtime.h"
#import "DateFormat.h"
#import "TotalTVC.h"
#import "ViewOvertimeViewController.h"
#import "Faulter.h"
#import "CalendarViewController.h"

// TESTING
#import "CalendarDate.h"

@interface OvertimeVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation OvertimeVC
{
    AppDelegate *appDelegate;
    
    // Temp
    UITextField *textFieldToStoreDate;
    //UITableView *tableView;
    BOOL isCalendarActive;
    NSDate *selectedDate;
    CalendarViewController *calendarVC;
}

static NSString *cellIdentifier = @"cell";


-(IBAction)changedSegment:(id)sender {
    UISegmentedControl *segmentControl = (UISegmentedControl*)sender;
    int index = (int)[segmentControl selectedSegmentIndex];
    
    NSLog(@"Changed to: %@", index == 0 ? @"List view" : @"Calendar view");
    
    if(index == 0) {
        // List view
        [self showListView];
        
    } else if(index == 1) {
        // Calendar view
        [self showCalendarView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCalendar" object:nil];
        
    }
}
-(NSArray*)getDates {
    NSMutableArray *arrayOfDates = [NSMutableArray new];
    
    if(self.frc.fetchedObjects > 0) {
        arrayOfDates = [self.frc.fetchedObjects copy];
    }
    
    
    return arrayOfDates;
}
-(void)showListView {
    [self.calendarviewContainer setHidden:YES];
    [self.listviewContainer setHidden:NO];
    isCalendarActive = NO;
    //NSLog(@"Showing list view...");
}
-(void)showCalendarView {
    //NSLog(@"Showing calendar view...");
    [self.listviewContainer setHidden:YES];
    [self.calendarviewContainer setHidden:NO];
    isCalendarActive = YES;
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //NSLog(@"(%@)Change: %@", keyPath, change);
    NSLog(@"Select: %@", [DateFormat getUKStyleDate:change[NSKeyValueChangeNewKey]]);
    selectedDate = change[NSKeyValueChangeNewKey];
    
    //NSLog(@"(%@)New date is: %@", keyPath, change);
}
-(void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"Overtimes"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData)]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    NSDictionary *closeButtonAtt = @{NSForegroundColorAttributeName:[UIColor redColor]};
    
    [backButton setTitleTextAttributes:closeButtonAtt forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:backButton];
}

-(void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupCoreData {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Overtime"];
    [fetch setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    
    //self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[appDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[appDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:@"OvertimeDates"];
    
    [self updateView];
}


-(void)doneEditingDate:(UIDatePicker*)sender {
    NSLog(@"%@!", [DateFormat getDateStringFromDate:sender.date]);
    
    NSString *dateString;
    if([[self loadDateSettings] intValue] == 1) {
        dateString = [NSString stringWithString:[DateFormat getUSStyleDate:sender.date]];
    } else {
        dateString = [NSString stringWithString:[DateFormat getUKStyleDate:sender.date]];
    }
    
    textFieldToStoreDate.text = dateString;
}
-(void)addData {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add new entry" message:@"Input the date of the Overtime & hours worked:" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setInputView:datePicker];
        [textField setTextAlignment:NSTextAlignmentCenter];
        textField.placeholder = @"Date of Overtime";
        textFieldToStoreDate = textField;
        
        if(isCalendarActive && selectedDate) {
            textField.text = [DateFormat getUKStyleDate:selectedDate];
            [datePicker setDate:selectedDate];
        }
        [datePicker addTarget:self action:@selector(doneEditingDate:) forControlEvents:UIControlEventValueChanged];
        
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [textField setTextAlignment:NSTextAlignmentCenter];
        textField.placeholder = @"Hours worked";
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *dateString = [[alertController textFields] firstObject].text;
        double overtimeHrs = [[[alertController textFields] lastObject].text doubleValue];
        [self addNewOvertimeWith:dateString andHours:overtimeHrs];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}
-(void)overtimeAdded {
    textFieldToStoreDate = nil;
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // NSLog(@"Total amounts of hanging in memory: %lu",(unsigned long) [[appDelegate.managedObjectContext registeredObjects] count]);
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingChanged) name:@"SomethingChanged" object:nil];
    [self setupNavigationBar];
    [self setupCoreData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isCalendarActive = NO;
    [self showListView];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SomethingChanged" object:nil];
    [calendarVC removeObserver:self forKeyPath:@"dateSelected"];
    calendarVC = nil;
    
    [super viewWillDisappear:animated];
}

-(void)somethingChanged {
    NSLog(@"Something changed, updating data!");
    NSError *error;
    if(![self.frc performFetch:&error]) {
        NSLog(@"ERROR: Failed to fetch. %@", error.localizedDescription);
    }
    [self updateView];
    
    self.totalDouble = [[self getTotalHours] doubleValue];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateView {
    NSError *error;
    if(![self.frc performFetch:&error]) {
        NSLog(@"ERROR: Failed to fetch data. (%@)", error.localizedDescription);
    }
    [self.tableView reloadData];
}


#pragma mark - Fetching data methods from TotalTVC

-(NSNumber*)getTotalHours {
    NSNumber *totalHours;
    
    double totalValue = 0;
    
    for(Overtime *overtime in self.frc.fetchedObjects) {
        totalValue = totalValue + [overtime.hours doubleValue];
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

-(void)addNewOvertimeWith:(NSString*)date andHours:(double)hours {
    Overtime *overtimeEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Overtime" inManagedObjectContext:appDelegate.managedObjectContext];
    
    
    NSDate *createdDate;
    if([[self loadDateSettings] intValue] == 1) {
        createdDate = [DateFormat getUSStyleDateFromString:date];
    } else {
        createdDate = [DateFormat getUKStyleDateFromString:date];
    }
    
    overtimeEntry.date = createdDate;
    overtimeEntry.hours = [NSNumber numberWithDouble:hours];
    
    [appDelegate saveContext];
    [self updateView];
    [Faulter faultObjectWithID:overtimeEntry.objectID inContext:appDelegate.managedObjectContext];
    
    // Refresh calendar view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCalendar" object:nil];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.frc.fetchedObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Overtime *cellObject = [self.frc objectAtIndexPath:indexPath];
    
    
    NSString *dateString;
    if([[self loadDateSettings] intValue] == 1) {
        dateString = [NSString stringWithString:[DateFormat getUSStyleDate:cellObject.date]];
    } else {
        dateString = [NSString stringWithString:[DateFormat getUKStyleDate:cellObject.date]];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ = %.1f hours", dateString, [cellObject.hours doubleValue]];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Overtime *selectedObj = [self.frc objectAtIndexPath:indexPath];
    
    ViewOvertimeViewController *viewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewOvertimeViewController"];
    
    if([[self loadDateSettings] intValue] == 1) {
        [viewVC setHours:[selectedObj.hours doubleValue] withDate:[DateFormat getUSStyleDate:selectedObj.date]];
    } else {
        [viewVC setHours:[selectedObj.hours doubleValue] withDate:[DateFormat getUKStyleDate:selectedObj.date]];
        
    }
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
    [self updateView];
    NSLog(@"Deleted object.");
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        Overtime *overtimeObject = (Overtime*)[self.frc objectAtIndexPath:indexPath];
        
        [self confirmRemoval:overtimeObject];
        
    }
}

-(void)addTempData {
    /*
     Overtime *dayOne = [NSEntityDescription insertNewObjectForEntityForName:@"Overtime" inManagedObjectContext:appDelegate.managedObjectContext];
     Overtime *dayTwo = [NSEntityDescription insertNewObjectForEntityForName:@"Overtime" inManagedObjectContext:appDelegate.managedObjectContext];
     Overtime *dayThree = [NSEntityDescription insertNewObjectForEntityForName:@"Overtime" inManagedObjectContext:appDelegate.managedObjectContext];
     
     NSDateFormatter *dateFormatter = [NSDateFormatter new];
     [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
     
     NSDate *dayOneDate = [dateFormatter dateFromString:@"01-06-2016 15:30:00"];
     NSDate *dayTwoDate = [dateFormatter dateFromString:@"02-06-2016 16:30:00"];
     NSDate *dayThreeDate = [dateFormatter dateFromString:@"03-06-2016 17:30:00"];
     
     dayOne.date = dayOneDate;
     dayTwo.date = dayTwoDate;
     dayThree.date = dayThreeDate;
     
     dayOne.hours = [NSNumber numberWithDouble:2.0];
     dayTwo.hours = [NSNumber numberWithDouble:4.0];
     dayThree.hours = [NSNumber numberWithDouble:6.0];
     
     [appDelegate saveContext];
     */
    [self updateView];
}



 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([segue.identifier isEqualToString:@"calendarSegue"]) {
         calendarVC = segue.destinationViewController;
         [calendarVC addObserver:self forKeyPath:@"dateSelected" options:NSKeyValueObservingOptionNew context:nil];
     }
     NSLog(@"Segue is: %@", segue.identifier);
 }


@end
