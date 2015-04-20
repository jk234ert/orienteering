//
//  TimeUtil.m
//  Orienteering
//
//  Created by macmini on 15/4/8.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil

+(NSString*)getTimeStringBetweenFirstDate :(NSDate*)firstDate andSecondDate:(NSDate*)secondDate
{
    NSTimeInterval totalTimeIntervalCost = [secondDate timeIntervalSinceDate:firstDate];
    
    NSString *hourString;
    if((int)totalTimeIntervalCost >= 36000)
    {
        hourString = [NSString stringWithFormat:@"%d", (int)totalTimeIntervalCost/36000];
    } else {
        hourString = [NSString stringWithFormat:@"0%d", (int)totalTimeIntervalCost/3600];
    }
    
    NSString *minuteString;
    if((int)totalTimeIntervalCost % 3600 >= 600)
    {
        minuteString = [NSString stringWithFormat:@"%d", ((int)totalTimeIntervalCost % 3600)/60];
    } else {
        minuteString = [NSString stringWithFormat:@"0%d", ((int)totalTimeIntervalCost % 3600)/60];
    }
    
    NSString *secondString;
    if((int)totalTimeIntervalCost % 60 >= 10)
    {
        secondString = [NSString stringWithFormat:@"%d", (int)totalTimeIntervalCost % 60];
    } else{
        secondString = [NSString stringWithFormat:@"0%d", (int)totalTimeIntervalCost % 60];
    }
    
    NSString *totalTimeCostString = [NSString stringWithFormat:@"%@:%@:%@", hourString, minuteString, secondString];
    return totalTimeCostString;
}

+(NSString*)NSDateToString :(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    [dateFormatter setDateFormat:@"yyyy 年 MM 月 dd 日"];
    
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSDate*)StringToNSDate :(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    [dateFormatter setDateFormat:@"yyyy 年 MM 月 dd 日"];
    
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

@end
