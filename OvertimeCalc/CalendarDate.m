//
//  CalendarDate.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 17/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "CalendarDate.h"

@implementation CalendarDate

@synthesize date;

-(instancetype)init {
    if(self = [super init]) {
        date = [NSDate date];
    }
    return self;
}
@end
