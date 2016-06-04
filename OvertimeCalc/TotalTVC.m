//
//  TotalTVC.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 18/05/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "TotalTVC.h"


@interface TotalTVC ()

@end

@implementation TotalTVC

-(void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"Total"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBar];
}
-(void)refreshData {
    // Do what..?
#warning Do something here...
    [self showLoading];
}
-(void)getData {
    NSDate *startDate, *endDate;
    NSInteger totalDays;
    NSNumber *totalHours; // This is a Double
    
    UINavigationController *navCon = (UINavigationController*)[self.tabBarController.viewControllers firstObject];
    
    _overtimeTVC = (OvertimeTVC*)[navCon.viewControllers firstObject];
    
    startDate = [_overtimeTVC getStartDate];
    endDate = [_overtimeTVC getEndDate];
    
    totalDays = [_overtimeTVC getTotalDays];
    totalHours = [_overtimeTVC getTotalHours];
    
    [self setupTableViewCellWithStart:startDate andEndDate:endDate andDaysWorked:totalDays andHoursWorked:totalHours];
}
-(void)setupTableViewCellWithStart:(NSDate*)startDate andEndDate:(NSDate*)endDate andDaysWorked:(NSInteger)daysWorked andHoursWorked:(NSNumber*)hoursWorked {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    self.startDateCell.cellDataLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:startDate]];
    self.endDateCell.cellDataLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:endDate]];
    
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
    
    [self getData];
    [self showLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setPayrate
{
    /*
     * This is throwing an error when presenting view..
     */
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Payrate" message:@"What is your pay per hour?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Payrate: %@", [alertController.textFields firstObject].text);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancel];
    [alertController addAction:submit];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showLoading {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Loading..." message:@"\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(130.0, 65.5);
    spinner.color = [UIColor blackColor];
    [spinner startAnimating];
    [alertController.view addSubview:spinner];
    [self presentViewController:alertController animated:YES completion:^{
        // nil
    }];
    [self performSelector:@selector(stopAnimation:) withObject:spinner afterDelay:1];
    
}

-(void)stopAnimation:(UIActivityIndicatorView*)spinner {
    [spinner stopAnimating];
    spinner = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
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
