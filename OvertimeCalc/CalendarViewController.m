//
//  CalendarViewController.m
//
//
//  Created by Jonathan Tribouharet.
//

#import "CalendarViewController.h"
#import "OvertimeVC.h"
#import "AppDelegate.h"
#import "Overtime+CoreDataClass.h"
#import "ViewOvertimeViewController.h"
#import "DateFormat.h"
#import "UIColor+DarkGreen.h"


@interface CalendarViewController (){
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    JTCalendarDayView *selectedDay;
   // NSDate *dateSelected;
}

@end

@implementation CalendarViewController
@synthesize dateSelected;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    //NSLog(@"Loaded with NIB");
    self.title = @"Calendar View";
    
    return self;
}
-(void)refreshData {
    //NSLog(@"Refreshing data");
    [self createEventsFromAppdelegate];
    if(selectedDay) {
        [self calendar:_calendarManager didTouchDayView:selectedDay];
    } else {
        // Use this to refresh the page
        [_calendarManager setDate:_todayDate];
    }
}

-(void)createEventsFromAppdelegate {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSArray *dates = [self createArrayOfArrayDateswithArray:[appDelegate fetchAllDates]];
    
    [self createEventsWithDates:dates];
    //NSLog(@"createEventsFromAppdelegate");
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshCalendar" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSBundle mainBundle] loadNibNamed:@"CalendarViewController" owner:self options:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RefreshCalendar" object:nil];
    
    [self createEventsFromAppdelegate];

    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    [self setValue:_todayDate forKey:@"dateSelected"];
}
-(void)viewWillDisappear:(BOOL)animated {
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshCalendar" object:nil];
    
    //[self removeObserver:self forKeyPath:@"SelectedCalendarDate"];
    //NSLog(@"View will disappear");
    [super viewWillDisappear:animated];
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
-(NSArray*)createArrayOfArrayDateswithArray:(NSArray*)array {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    for(NSDate *date in array) {
        [mutArray addObject:@[date]];
    }
    return [mutArray copy];
}

-(void)openViewOvertime:(Overtime*)object {
    ViewOvertimeViewController *viewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewOvertimeViewController"];
    
    if([[self loadDateSettings] intValue] == 1) {
        [viewVC setHours:[object.hours doubleValue] withDate:[DateFormat getFullUSStyleDate:object.date]];
    } else {
        [viewVC setHours:[object.hours doubleValue] withDate:[DateFormat getFullUKStyleDate:object.date]];
    }
    [viewVC setSelectedObjectID:object.objectID];
    [self.navigationController pushViewController:viewVC animated:YES];
}

#pragma mark - Buttons callback
-(IBAction)openSelectedDate:(id)sender
{
    if([self haveEventForDay:dateSelected]) {
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        Overtime *overtimeObject = [appDelegate fetchObjectWithDate:dateSelected];
        
        [self openViewOvertime:overtimeObject];
    } else {
        //NSLog(@"No data for selected date");
    }
    
    
}
- (IBAction)didGoTodayTouch
{
    //dateSelected = [NSDate date];
    
    //dateSelected = _todayDate;
    
    [self setValue:_todayDate forKey:@"dateSelected"]; // this should set dateSelected variable to the date.
    [_calendarManager setDate:_todayDate];
    
    
    //NSLog(@"didGoTodayTouch: %@", dateSelected);
}
/*
- (IBAction)didChangeModeTouch
{
    NSLog(@"didChangeModeTouch");
    
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
    }
    
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}*/

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.circleRatio = 0.85f;
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        //dayView.circleView.backgroundColor = [UIColor blueColor]; - Changing current date color to Red
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];

    }
    // Selected date
    else if(dateSelected && [_calendarManager.dateHelper date:dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor darkGreenColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor darkGreenColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor darkGreenColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    // SELECTEDDATE
    // dayView.date holds the selected date.
    selectedDay = dayView;
    //NSLog(@"Selected: %@", dayView.date);
    //NSLog(@"nSelected: %@", [NSDateFormatter localizedStringFromDate:dayView.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    
    //dateSelected = dayView.date;
    [self setValue:dayView.date forKey:@"dateSelected"]; // this should set dateSelected variable to the date.

    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //NSLog(@"Previous page loaded");
}

#pragma mark - Data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 12 months before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-12];
    
    // Max date will be 12 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:12];
}


-(NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}

- (void)createEventsWithDates:(NSArray*)dates
{
    // This was stopping new dates from being created...
    /*
    if(_eventsByDate) {
        NSLog(@"Events already exist!");
        _eventsByDate = nil;
    }*/
    
    
    _eventsByDate = [NSMutableDictionary new];
    
    NSDateFormatter *simpleDateFormat = [[NSDateFormatter alloc] init];
    [simpleDateFormat setDateFormat:@"dd-MM-yyyy"];
    
    for (NSArray *dateArray in dates) {
        NSDate *date = (NSDate*)[dateArray lastObject];
        [_eventsByDate setValue:dateArray forKey:[simpleDateFormat stringFromDate:date]];
    }
    
    // This is sample code that came with the Calendar Class
    /*
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
    
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSDate *date = [NSDate new];
    date = [dateFormat dateFromString:@"01/07/2016 13:30:00"];
    
    [_eventsByDate setObject:[NSMutableArray arrayWithObject:date] forKey:@"01-07-2016"];
    */
}

@end
