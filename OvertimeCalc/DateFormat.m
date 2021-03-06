//
//  DateFormat.m
//  Pullup Challenge
//
//  Created by Dayan Yonnatan on 01/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "DateFormat.h"

@implementation DateFormat

+(NSString *)getSuffixForDate:(NSDate*)theDate
{
    NSDateFormatter *dayOf = [NSDateFormatter new];
    [dayOf setDateFormat:@"dd"];
    
    int number = [[dayOf stringFromDate:theDate] intValue];
    
    NSString *suffix;
    
    int ones = number % 10;
    int tens = (number/10) % 10;
    
    if (tens ==1) {
        suffix = [NSString stringWithFormat:@"th"];
    } else if (ones ==1){
        suffix = [NSString stringWithFormat:@"st"];
    } else if (ones ==2){
        suffix = [NSString stringWithFormat:@"nd"];
    } else if (ones ==3){
        suffix = [NSString stringWithFormat:@"rd"];
    } else {
        suffix = [NSString stringWithFormat:@"th"];
    }
    return suffix;
}

+(NSString*)cleanDigits:(NSString*)string {
    if([[string substringToIndex:1] isEqualToString:@"0"]) {
        return [string substringFromIndex:1];
    } else {
        return string;
    }
}
+(NSString*)getDateStringFromDate:(NSDate*)date {
    return [self getDateStringFromDate:date withIndex:0];
}
+(NSString*)getDateStringFromDate:(NSDate*)date withIndex:(int)index {
    if(index <= 0) {
        // 0. 25-03-16
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"dd-MM-yy"];
        return [formatter stringFromDate:date];
    } else if(index == 1) {
        // 1. 25th March 16
        NSDateFormatter *dayFormat = [NSDateFormatter new];
        NSDateFormatter *restFormat = [NSDateFormatter new];
        [dayFormat setDateFormat:@"dd"];
        [restFormat setDateFormat:@"LLLL yy"];
        
        NSString *string = [NSString stringWithFormat:@"%@%@ %@", [DateFormat cleanDigits:[dayFormat stringFromDate:date]],[self getSuffixForDate:date],[restFormat stringFromDate:date]];
        return string;
    } else if(index == 2) {
        // 2. Friday 25th
        NSDateFormatter *dayFormat = [NSDateFormatter new];
        [dayFormat setDateFormat:@"EEEE dd"];
        NSString *string = [NSString stringWithFormat:@"%@%@",[dayFormat stringFromDate:date],[self getSuffixForDate:date]];
        return string;
    } else if(index == 3) {
        // 3. Friday (25-03-16)
        NSDateFormatter *format = [NSDateFormatter new];
        [format setDateFormat:@"EEEE"];
        NSDateFormatter *basicFormatter = [NSDateFormatter new];
        [basicFormatter setDateFormat:@"dd-MM-yy"];
        NSString *string = [NSString stringWithFormat:@"%@ (%@)", [format stringFromDate:date], [basicFormatter stringFromDate:date]];
        return string;
    } else if(index == 4) {
        // 4. Friday 25th March 2016
        NSDateFormatter *dayOfWkFormat = [NSDateFormatter new];
        [dayOfWkFormat setDateFormat:@"EEEE"];
        NSDateFormatter *dayFormat = [NSDateFormatter new];
        [dayFormat setDateFormat:@"dd"];
        NSDateFormatter *restOfDateFormat = [NSDateFormatter new];
        [restOfDateFormat setDateFormat:@"LLLL yyyy"];
        NSString *string = [NSString stringWithFormat:@"%@ %@%@ %@", [dayOfWkFormat stringFromDate:date], [DateFormat cleanDigits:[dayFormat stringFromDate:date]],[self getSuffixForDate:date], [restOfDateFormat stringFromDate:date]];
        return string;
    }
    else {
        NSLog(@"ERROR: No index found!");
        return nil;
    }
}

+(NSString*)getFullUSStyleDate:(NSDate*)date {
    NSDateFormatter *dayFormat = [NSDateFormatter new];
    [dayFormat setDateFormat:@"EEEE"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    return [NSString stringWithFormat:@"%@ (%@)", [dayFormat stringFromDate:date], [dateFormatter stringFromDate:date]];
}


+(NSString*)getFullUKStyleDate:(NSDate*)date {
    NSDateFormatter *dayFormat = [NSDateFormatter new];
    [dayFormat setDateFormat:@"EEEE"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    return [NSString stringWithFormat:@"%@ (%@)", [dayFormat stringFromDate:date], [dateFormatter stringFromDate:date]];
}

+(NSString*)getUSStyleDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    return [dateFormatter stringFromDate:date];
}


+(NSString*)getUKStyleDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)getUKStyleDateFromString:(NSString*)dateString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSDate *newDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 17:30:30",dateString]];
    if(!newDate) {
        NSLog(@"ERROR: Failed to create date!!");
        return nil;
    }
    return newDate;
}
+(NSDate*)getUSStyleDateFromString:(NSString*)dateString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDate *newDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 17:30:30",dateString]];
    if(!newDate) {
        NSLog(@"ERROR: Failed to create date!!");
        return nil;
    }
    return newDate;
}




@end
