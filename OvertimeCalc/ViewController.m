//
//  ViewController.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 18/05/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+DarkGreen.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self setupNavigationBar];
}

-(IBAction)dateStyleChanged:(id)sender {
    int index = (int)[((UISegmentedControl*)sender) selectedSegmentIndex];
    
    //NSLog(@"Date style selected: %i", index);
    [self setSettingsWithDateStyle:[NSNumber numberWithInt:index]];
}
-(IBAction)currencyChanged:(id)sender {
    int index = (int) [((UISegmentedControl*)sender) selectedSegmentIndex];
    //NSLog(@"Currency selected: %i", index);
    [self setSettingsWithCurrency:[NSNumber numberWithInt:index]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIColor *darkGreenColor = [UIColor darkGreenColor];
    
    [self.view setBackgroundColor:darkGreenColor];
    [self loadSegmentSettings];
    [self loadRememberSettings];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"ViewDidAppear");
    
    [self loadRememberSettings];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)openApp {
    [self performSegueWithIdentifier:@"ShowTabBarController" sender:self];
}
-(void)loadRememberSettings {
    if([self isRememberMyOptionsOn]) {
        [_rememberSettingsSwitch setOn:true];
        [self openApp];
    } else {
        [_rememberSettingsSwitch setOn:false];
    }
}
-(void)loadSegmentSettings {
    NSNumber *loadedDateSettings = [self loadDateSettings];
    [_dateStyleSegmentControl setSelectedSegmentIndex:[loadedDateSettings integerValue]];
    
    NSNumber *loadedCurrencySettings = [self loadCurrencySettings];
    [_currencySegmentControl setSelectedSegmentIndex:[loadedCurrencySettings integerValue]];
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
- (IBAction)rememberOptionChanged:(id)sender {
    [self setRememberSettings:_rememberSettingsSwitch.on];
}


-(void)setSettingsWithCurrency:(NSNumber*)currencyIndex {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int currencyIndexInt = [currencyIndex intValue];
    if(currencyIndexInt == 0) {
        [userDefaults removeObjectForKey:@"CurrencyIndex"];
    } else {
        [userDefaults setValue:currencyIndex forKey:@"CurrencyIndex"];
    }
    
    if(![userDefaults synchronize]) {
        //NSLog(@"ERROR: Fail to save Currency settings..");
    } else {
        //NSLog(@"Successfully saved settings.");
    }
}

-(void)setSettingsWithDateStyle:(NSNumber*)dateIndex {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int dateIndexInt = [dateIndex intValue];
    
    if(dateIndexInt == 0) {
        [userDefaults removeObjectForKey:@"DateStyleIndex"];
    } else {
        [userDefaults setValue:@1 forKey:@"DateStyleIndex"];
    }
    if(![userDefaults synchronize]) {
        //NSLog(@"ERROR: Fail to save Date settings..");
    } else {
        //NSLog(@"Successfully saved settings.");
    }
}

-(void)setRememberSettings:(BOOL)option {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSNumber numberWithBool:option] forKey:@"RememberMyChoice"];
    if([userDefaults synchronize]) {
        NSLog(@"SAVED");
    } else {
        NSLog(@"ERROR");
    }
}
-(BOOL)isRememberMyOptionsOn {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userDefaultOption = [userDefaults objectForKey:@"RememberMyChoice"];
    return [userDefaultOption boolValue];
}







@end
