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
    // Do any additional setup after loading the view.
    //[self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    [self.tabBar setBarTintColor:[UIColor blackColor]];
    [self.tabBar setTintColor:[UIColor orangeColor]];
    //[self.tabBar setBackgroundColor:[UIColor blackColor]];
    //[self.tabBarController.tabBar setBackgroundColor:[UIColor blackColor]];
    //NSLog(@"View did load TaBBAR");
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
