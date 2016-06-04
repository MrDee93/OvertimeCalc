//
//  OvertimeTVC.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 18/05/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "OvertimeTVC.h"
#import "AppDelegate.h"
#import "Overtime.h"
#import "DateFormat.h"
#import "TotalTVC.h"

//#define MainAppDelegate ((AppDelegate*)([UIApplication sharedApplication].delegate))

@interface OvertimeTVC ()

@end

@implementation OvertimeTVC
{
    NSArray *sampleData, *sampleHours;
    AppDelegate *appDelegate;

}

-(void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"Overtimes"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData)]];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)]];
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
-(void)addData {
    
    [self addTempData];
    /*
    NSLog(@"addData");
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Date Selection" message:@"Select the date of the Overtime" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       // textField.inputView = pickerView;
        
    }];
    [alertController.view addSubview:pickerView];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Select" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    */
    
    /*
    Overtime *overtime = [NSEntityDescription insertNewObjectForEntityForName:@"Overtime" inManagedObjectContext:appDelegate.managedObjectContext];
    overtime.date = [NSDate date];
    overtime.hours = [NSNumber numberWithDouble:7.5];
    [appDelegate saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    */
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
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SomethingChanged" object:nil];
}

-(void)somethingChanged {
    NSLog(@"Something changed!");
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    
    Overtime *cellObject = [self.frc objectAtIndexPath:indexPath];
    
    
    NSString *dateString;
    if([[self loadDateSettings] intValue] == 1) {
        dateString = [NSString stringWithString:[DateFormat getUSStyleDate:cellObject.date]];
    } else {
        dateString = [NSString stringWithString:[DateFormat getUKStyleDate:cellObject.date]];
    }
    
    
    //[DateFormat getDateStringFromDate:cellObject.date withIndex:3]
    cell.textLabel.text = [NSString stringWithFormat:@"%@ = %.1f hours", dateString, [cellObject.hours doubleValue]];
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
