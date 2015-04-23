//
//  ActivityManager.h
//  Orienteering
//
//  Created by macmini on 15/4/17.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityModel.h"

@interface ActivityManager : NSObject

+(instancetype)sharedInstance;

-(NSArray*)getAllRegisteredActivities;
-(void)addNewActivity :(ActivityModel*)newActivity;
-(void)deleteActivity: (NSInteger)index;


-(NSArray*)getCorrespondingPathArray: (ActivityModel*)activity;
-(NSString*)getCorrespondingMapName: (ActivityModel*)activity;
-(NSString*)getCorrespondingDotInfoName: (ActivityModel*)activit;

-(BOOL)uploadActivityScore:(NSArray*)scroreArray withActivity:(ActivityModel*)activity;
@end
