//
//  OvertimeTabBarController.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 02/11/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "OvertimeTabBarController.h"

@interface OvertimeTabBarController ()

@end

@implementation OvertimeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setWhiteBG];
    
}
-(void)setBlackBG {
    //[self.tabBar setBarTintColor:[UIColor blackColor]];
    [self.tabBar setTintColor:[UIColor orangeColor]];
}
-(void)setWhiteBG { 
    
   // [self.tabBar setTintColor:[UIColor blackColor]];
    //[self.tabBar setTintColor:[UIColor blueColor]];
    
    UIColor *moneyGreenColor = [[UIColor alloc] initWithRed:0 green:0.5 blue:0 alpha:1.0];
    
    [self.tabBar setTintColor:moneyGreenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
