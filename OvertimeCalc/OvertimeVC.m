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
//#import "CalendarDate.h"

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
/*
-(NSArray*)getDates {
    NSMutableArray *arrayOfDates = [NSMutableArray new];
    
    if(self.frc.fetchedObjects > 0) {
        arrayOfDates = [self.frc.fetchedObjects copy];
    }
    
    
    return arrayOfDates;
}*/
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCalendar" object:nil];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //NSLog(@"(%@)Change: %@", keyPath, change);
    //NSLog(@"Select: %@", [DateFormat getUKStyleDate:change[NSKeyValueChangeNewKey]]);
    //NSLog(@"Selectd: %@", change[NSKeyValueChangeNewKey]);
    selectedDate = change[NSKeyValueChangeNewKey];
    
    NSLog(@"(%@)New date is: %@", keyPath, change);
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
/*
-(void)setupCoreData {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Overtime"];
    [fetch setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    
    //self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[appDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[appDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:@"OvertimeDates"];
    
    
}*/


-(void)doneEditingDate:(UIDatePicker*)sender {
    NSString *dateString;
    if([[self loadDateSettings] intValue] == 1) {
        dateString = [NSString stringWithString:[DateFormat getUSStyleDate:sender.date]];
    } else {
        dateString = [NSString stringWithString:[DateFormat getUKStyleDate:sender.date]];
    }
    NSLog(@"textFieldToStoreDate: %@", dateString);
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
        
        BOOL UKStyleDate = [[self loadDateSettings] intValue] ? false : true;
        
        if(isCalendarActive && selectedDate) {
            if(UKStyleDate) {
                textField.text = [DateFormat getUKStyleDate:selectedDate];
            } else {
                textField.text = [DateFormat getUSStyleDate:selectedDate];
            }
            
            [datePicker setDate:selectedDate];
            NSLog(@"Selected date: %@", [DateFormat getUKStyleDate:selectedDate]);
        } else {
            if(UKStyleDate) {
                textField.text = [DateFormat getUKStyleDate:[datePicker date]];
            } else {
                textField.text = [DateFormat getUSStyleDate:[datePicker date]];
            }
            
        }
        
        [datePicker addTarget:self action:@selector(doneEditingDate:) forControlEvents:UIControlEventValueChanged];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [textField setTextAlignment:NSTextAlignmentCenter];
        textField.placeholder = @"Hours worked";
        [textField becomeFirstResponder];
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *dateString = [[alertController textFields] firstObject].text;
        double overtimeHrs = [[[alertController textFields] lastObject].text doubleValue];
        [self addNewOvertimeWith:dateString andHours:overtimeHrs];
        [self clearMemory];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self clearMemory];
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{
        // Automatically go to the Hours textfield to allow input immediately after selecting a date.
        [[alertController.textFields lastObject] becomeFirstResponder];
    }];
}
-(void)clearMemory {
    textFieldToStoreDate = nil;
}


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // NSLog(@"Total amounts of hanging in memory: %lu",(unsigned long) [[appDelegate.managedObjectContext registeredObjects] count]);
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingChanged) name:@"SomethingChanged" object:nil];
    [self setupNavigationBar];
    //[self setupCoreData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isCalendarActive = NO;
    [self showListView];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SomethingChanged" object:nil];
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
    //[self updateView];
    
    //self.totalDouble = [[self getTotalHours] doubleValue];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)doesEntryAlreadyExist:(NSString*)dateString {
    __block BOOL doesEntryExist = false;
    BOOL USStyleDate = false;
    if([[self loadDateSettings] intValue] == 1) {
        USStyleDate = true;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Overtime"];
    NSArray *fetchedOvertimes = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    [fetchedOvertimes enumerateObjectsUsingBlock:^(Overtime  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *objectDate;
        if(USStyleDate) {
            objectDate = [DateFormat getUSStyleDate:obj.date];
        } else {
            objectDate = [DateFormat getUKStyleDate:obj.date];
        }
        
        if([objectDate isEqualToString:dateString]) {
            doesEntryExist = true;
            *stop = true;
        }
        
    }];
    return doesEntryExist;
}
-(NSManagedObjectID*)fetchObjectWithDate:(NSString*)dateString {
    __block NSManagedObjectID *objectID;
    
    BOOL USStyleDate = false;
    if([[self loadDateSettings] intValue] == 1) {
        USStyleDate = true;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Overtime"];
    NSArray *fetchedOvertimes = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    [fetchedOvertimes enumerateObjectsUsingBlock:^(Overtime  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *objectDate;
        if(USStyleDate) {
            objectDate = [DateFormat getUSStyleDate:obj.date];
        } else {
            objectDate = [DateFormat getUKStyleDate:obj.date];
        }
        
        if([objectDate isEqualToString:dateString]) {
            [appDelegate.managedObjectContext obtainPermanentIDsForObjects:@[obj] error:nil];
            objectID = obj.objectID;
            *stop = true;
        }
        
    }];
    return objectID;

}

-(void)addNewOvertimeWith:(NSString*)date andHours:(double)hours {
    NSManagedObjectID *objectIDFault;
    if([self doesEntryAlreadyExist:date]) {
        Overtime *overtimeEntry = [appDelegate.managedObjectContext objectWithID:[self fetchObjectWithDate:date]];
        overtimeEntry.hours = [NSNumber numberWithDouble:(hours+[overtimeEntry.hours doubleValue])];
        objectIDFault = overtimeEntry.objectID;
    } else {
    
    Overtime *overtimeEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Overtime" inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSLog(@"Add new overtime VC");
    NSDate *createdDate;
    if([[self loadDateSettings] intValue] == 1) {
        createdDate = [DateFormat getUSStyleDateFromString:date];
    } else {
        createdDate = [DateFormat getUKStyleDateFromString:date];
    }
    
    overtimeEntry.date = createdDate;
    overtimeEntry.hours = [NSNumber numberWithDouble:hours];
        objectIDFault = overtimeEntry.objectID;
    }
    
    [appDelegate saveContext];
    //[self somethingChanged];
    //[self updateView];
    [Faulter faultObjectWithID:objectIDFault inContext:appDelegate.managedObjectContext];
    
    // Refresh list view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    
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
     
     [self somethingChanged];
    [self updateView];
     */
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
     if([segue.identifier isEqualToString:@"tableViewSegue"]) {
         self.theOvertimeTVC = segue.destinationViewController;
     }
     //NSLog(@"Segue is: %@", segue.identifier);
 }


@end
