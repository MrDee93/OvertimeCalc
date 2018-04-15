//
//  ViewController.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 18/05/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UISegmentedControl *dateStyleSegmentControl;
@property (nonatomic, strong) IBOutlet UISegmentedControl *currencySegmentControl;

@property (nonatomic, strong) IBOutlet UISwitch *rememberSettingsSwitch;

@end

