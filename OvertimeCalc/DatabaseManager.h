//
//  DatabaseManager.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 02/11/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "LoadingView.h"

@interface DatabaseManager : NSObject


@property (nonatomic, strong) AppDelegate *appDelegate;

-(instancetype)init;
-(BOOL)removeAllData;

@end
