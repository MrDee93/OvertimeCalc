//
//  DateFormat.h
//  Pullup Challenge
//
//  Created by Dayan Yonnatan on 01/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormat : NSObject

+(NSString *)getSuffixForDate:(NSDate*)theDate;
+(NSString*)getDateStringFromDate:(NSDate*)date;
+(NSString*)getDateStringFromDate:(NSDate*)date withIndex:(int)index;
+(NSString*)getUKStyleDate:(NSDate*)date;
+(NSString*)getUSStyleDate:(NSDate*)date;

+(NSString*)getFullUKStyleDate:(NSDate*)date;
+(NSString*)getFullUSStyleDate:(NSDate*)date;

+(NSDate*)getUSStyleDateFromString:(NSString*)dateString;
+(NSDate*)getUKStyleDateFromString:(NSString*)dateString;

@end
