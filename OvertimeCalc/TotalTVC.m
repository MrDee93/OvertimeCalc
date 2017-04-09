//
//  TotalTVC.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 18/05/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "TotalTVC.h"
#import "DateFormat.h"
#import "LoadingView.h"
#import "DatabaseManager.h"

@interface TotalTVC ()

@end

@implementation TotalTVC
-(void)setBlackBG {
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}
-(void)setWhiteBG {
    UIColor *moneyGreenColor = [[UIColor alloc] initWithRed:0 green:0.5 blue:0 alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:moneyGreenColor];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}
-(void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"Total"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)]];

    [self.navigationController.navigationBar setTranslucent:YES];

    //[self setBlackBG];
    [self setWhiteBG];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    NSDictionary *closeButtonAtt = @{NSForegroundColorAttributeName:[UIColor redColor]};
    
    [backButton setTitleTextAttributes:closeButtonAtt forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:backButton];
}
-(void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBar];
}
-(void)refreshData {
    // Do what..?
//#warning Opening Totals with No data causes App to crash!
    UINavigationController *navCon = (UINavigationController*)[self.tabBarController.viewControllers firstObject];
    self.overtimeVC = (OvertimeVC*)[navCon.viewControllers firstObject];
    self.overtimeTVC = self.overtimeVC.theOvertimeTVC;
    
    if([self checkIfThereIsData]) {
        [self getData];
        [self showLoading];
    } else {
        [self setupTableViewCellWithEmptyData];
    }
    
    
}
-(BOOL)checkIfThereIsData {
    //NSLog(@"Class: %@", [self.overtimeTVC class]);
    return [self.overtimeTVC isThereData];
}
-(void)getData {
    NSDate *startDate, *endDate;
    NSInteger totalDays;
    NSNumber *totalHours; // This is a Double
    
    //UINavigationController *navCon = (UINavigationController*)[self.tabBarController.viewControllers firstObject];
    
    //_overtimeTVC = (OvertimeTVC*)[navCon.viewControllers firstObject];
    
    startDate = [self.overtimeTVC getStartDate];
    endDate = [self.overtimeTVC getEndDate];
    
    totalDays = [self.overtimeTVC getTotalDays];
    totalHours = [self.overtimeTVC getTotalHours];
    
    
    [self setupTableViewCellWithStart:startDate andEndDate:endDate andDaysWorked:totalDays andHoursWorked:totalHours];
}
-(NSNumber*)getTotalHours {
    return [self.overtimeTVC getTotalHours];
}
-(void)setupTableViewCellWithEmptyData {
    self.startDateCell.cellDataLabel.text = @"01/01/2000";
    self.endDateCell.cellDataLabel.text = @"31/12/2000";
    
    self.daysWorkedCell.cellDataLabel.text = @"0 days";
    self.hoursWorkedCell.cellDataLabel.text = @"0 hours";
    
    int currencySettings = [[self loadCurrencySettings] intValue];
    
    NSString *currencyString;
    switch (currencySettings) {
        case 0:
            currencyString = [NSString stringWithFormat:@"£0.00"];
            break;
        case 1:
            currencyString = [NSString stringWithFormat:@"$0.00"];
            break;
        case 2:
            currencyString = [NSString stringWithFormat:@"€0.00"];
            break;
    }
    self.totalPayCell.cellDataLabel.text = currencyString;
    
    if([[self loadPaySettings] intValue] != 0) {
        NSString *ButtonTitle = [NSString stringWithFormat:@"%@%.1f (Tap to change)",[self retrieveCurrencySymbol],[[self loadPaySettings] doubleValue]];
        [self.payPerHourCell.setPayButton setTitle:ButtonTitle forState:UIControlStateNormal];
    }
    [self setTotalPay];
}
-(void)setupTableViewCellWithStart:(NSDate*)startDate andEndDate:(NSDate*)endDate andDaysWorked:(NSInteger)daysWorked andHoursWorked:(NSNumber*)hoursWorked {
    
    NSString *startdateString, *enddateString;
    if([[self loadDateSettings] intValue] == 1) {
        startdateString = [NSString stringWithString:[DateFormat getUSStyleDate:startDate]];
        enddateString = [NSString stringWithString:[DateFormat getUSStyleDate:endDate]];
    } else {
        startdateString = [NSString stringWithString:[DateFormat getUKStyleDate:startDate]];
        enddateString = [NSString stringWithString:[DateFormat getUKStyleDate:endDate]];
    }
    
    self.startDateCell.cellDataLabel.text = startdateString;
    self.endDateCell.cellDataLabel.text = enddateString;
    
    self.daysWorkedCell.cellDataLabel.text = [NSString stringWithFormat:@"%lu days", (unsigned long)daysWorked];
    self.hoursWorkedCell.cellDataLabel.text = [NSString stringWithFormat:@"%.1f hours", [hoursWorked doubleValue]];
    
    int currencySettings = [[self loadCurrencySettings] intValue];
    
    NSString *currencyString;
    switch (currencySettings) {
        case 0:
            currencyString = [NSString stringWithFormat:@"£0.00"];
            break;
        case 1:
            currencyString = [NSString stringWithFormat:@"$0.00"];
            break;
        case 2:
            currencyString = [NSString stringWithFormat:@"€0.00"];
            break;
    }
    self.totalPayCell.cellDataLabel.text = currencyString;
    
    if([[self loadPaySettings] intValue] != 0) {
        NSString *ButtonTitle = [NSString stringWithFormat:@"%@%.1f (Tap to change)",[self retrieveCurrencySymbol],[[self loadPaySettings] doubleValue]];
        //[buttonSend setTitle:ButtonTitle forState:UIControlStateNormal];
        [self.payPerHourCell.setPayButton setTitle:ButtonTitle forState:UIControlStateNormal];
    } else {
        //NSLog(@"Pay settings dont exist.");
    }
    [self setTotalPay];
}
-(void)setTotalPay {
    if([[self loadPaySettings] doubleValue] == 0.0) {
        NSString *cellTxt = [NSString stringWithFormat:@"%@0.0", [self retrieveCurrencySymbol]];
        self.totalPayCell.cellDataLabel.text = cellTxt;
    } else {
        double totalHoursVal = [[self getTotalHours] doubleValue];
        double payrate = [[self loadPaySettings] doubleValue];
        //NSLog(@"Total pay is: %.2f", totalHoursVal * payrate);
        NSString *cellTxt = [NSString stringWithFormat:@"%@%.2f",[self retrieveCurrencySymbol], (totalHoursVal * payrate)];
        self.totalPayCell.cellDataLabel.text = cellTxt;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self showLoading];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshData];
    //[self getData];
    //[self showLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)changePayrate:(id)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Payrate" message:@"What is your pay per hour?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //textField.keyboardType = UIKeyboardTypeDecimalPad;
        [textField setKeyboardType:UIKeyboardTypeDecimalPad];
        [textField setTextAlignment:NSTextAlignmentCenter];
        
    }];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSNumber *number = [NSNumber numberWithDouble:[[alertController.textFields firstObject].text doubleValue]];
        
        //NSLog(@"Payrate: %@%@", [self retrieveCurrencySymbol],[alertController.textFields firstObject].text);
        UIButton *buttonSend = (UIButton*)sender;
        NSString *ButtonTitle = [NSString stringWithFormat:@"%@%.1f (Tap to change)",[self retrieveCurrencySymbol],[number doubleValue]];
        
        [buttonSend setTitle:ButtonTitle forState:UIControlStateNormal];
        [self setPaySettings:[number doubleValue]];
        [self refreshData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancel];
    [alertController addAction:submit];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showLoading {
    LoadingView *loadingView = [[LoadingView alloc] init];
    [loadingView presentLoadingViewOnVC:self];
    [loadingView performSelector:@selector(stopLoadingOnVC:) withObject:self afterDelay:0.5];
}
-(NSString*)retrieveCurrencySymbol {
    NSString *symbol;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults valueForKey:@"CurrencyIndex"]) {
        //NSLog(@"Currency is GBP (£).");
        symbol = @"£";
    } else {
        int index = [[userDefaults valueForKey:@"CurrencyIndex"] intValue];
        
        if(index == 1) {
            //NSLog(@"Currency is USD ($).");
            symbol = @"$";
        } else {
            //NSLog(@"Currency is EURO (€).");
            symbol = @"€";
        }
    }
    return symbol;
    
}
-(NSNumber*)loadCurrencySettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults valueForKey:@"CurrencyIndex"]) {
        //NSLog(@"Currency is GBP (£).");
        return [NSNumber numberWithInt:0];
    } else {
        int index = [[userDefaults valueForKey:@"CurrencyIndex"] intValue];
        
        if(index == 1) {
            //NSLog(@"Currency is USD ($).");
            return [NSNumber numberWithInt:1];
        } else {
            //NSLog(@"Currency is EURO (€).");
            return [NSNumber numberWithInt:2];
        }
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
-(NSNumber*)loadPaySettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults valueForKey:@"PayPerHour"]) {
        // No payrate set
        return [NSNumber numberWithDouble:0.0];
    } else {
        return (NSNumber*)[userDefaults valueForKey:@"PayPerHour"];
    }
}
-(void)setPaySettings:(double)pay {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:pay] forKey:@"PayPerHour"];
    if(![[NSUserDefaults standardUserDefaults] synchronize]) {
        //NSLog(@"FAILED TO SAVE PAY SETTINGS");
    }
}
-(IBAction)resetSession:(id)sender {
    UIAlertController *alertConfirm = [UIAlertController alertControllerWithTitle:@"Confirm Reset" message:@"All your overtimes will be erased,\nAre you sure you would like to continue resetting your session?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self resetAllData];
    }];
    [alertConfirm addAction:cancel];
    [alertConfirm addAction:confirm];
    [self presentViewController:alertConfirm animated:YES completion:nil];
    
}
-(void)resetAllData {
    DatabaseManager *dbManager = [[DatabaseManager alloc] init];
    if([dbManager removeAllData]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"All your data has successfully been erased!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:dismiss];
        [self presentViewController:alert animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCalendar" object:nil];
            [self setupTableViewCellWithEmptyData];
            
        }];
    } else {
        //NSLog(@"ERROR");
    }

}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 0;
}*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}



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
