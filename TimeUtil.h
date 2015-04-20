//
//  TimeUtil.h
//  Orienteering
//
//  Created by macmini on 15/4/8.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject

+(NSString*)getTimeStringBetweenFirstDate :(NSDate*)firstDate andSecondDate:(NSDate*)secondDate;

+(NSString*)NSDateToString :(NSDate*)date;

+(NSDate*)StringToNSDate :(NSString*)string;

@end
