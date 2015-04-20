//
//  ActivityManager.m
//  Orienteering
//
//  Created by macmini on 15/4/17.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "ActivityManager.h"

@interface ActivityManager()
@property(nonatomic,retain)NSMutableArray *activitiesArray;

@property(nonatomic,retain)NSMutableDictionary *activityPathDict;
@property(nonatomic,retain)NSMutableDictionary *activityMapnameDict;
@property(nonatomic,retain)NSMutableArray *totalDotArray;
@end

@implementation ActivityManager

+(instancetype)sharedInstance
{
    static ActivityManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[[self class] alloc] init];
    });
    
    return _defaultManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.activityPathDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        
        self.activityMapnameDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        [self.activityMapnameDict setValue:@"MapHome" forKey:@"家庭"];
        [self.activityMapnameDict setValue:@"MapMan" forKey:@"男子"];
        [self.activityMapnameDict setValue:@"MapWoman" forKey:@"女子"];
        [self.activityMapnameDict setValue:@"MapYouth" forKey:@"青年"];
        [self.activityMapnameDict setValue:@"MapYoungsters" forKey:@"青少年"];
        [self.activityMapnameDict setValue:@"MapMiddleYouth" forKey:@"中青年"];
        
        NSNumber *storeArrayNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"registeredActivityNumber"];
        if([storeArrayNumber intValue] > 0)
        {
            self.activitiesArray = [[NSMutableArray alloc] initWithCapacity:10];
            for(int x=0;x<[storeArrayNumber intValue];x++)
            {
                NSString *tempNumber = [NSString stringWithFormat:@"activityNo%d",(int)x];
                NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:tempNumber];
                ActivityModel *newA = [[ActivityModel alloc] initWithStadiums:@"五台山" mapType:type];
                [self.activitiesArray addObject:newA];
            }
        } else {
            self.activitiesArray = [[NSMutableArray alloc] initWithCapacity:10];
        }
        [self initMapInfo];
        
    }
    return self;
}

-(void)initMapInfo
{
    NSArray *home = @[@57,@31,@33,@48,@32,@47,@49,@59,@52,@51,@35,@37,@58,@38,@53,@34,@40,@18];
    [_activityPathDict setObject:home forKey:@"家庭"];
    
    NSArray *man = @[@42,@43,@54,@31,@46,@44,@32,@48,@33,@52,@36,@37,@39,@34,@38,@58,@51,@49,@55,@100];
    [_activityPathDict setObject:man forKey:@"男子"];
    
    NSArray *woman = @[@41,@43,@56,@47,@46,@45,@32,@48,@33,@55,@59,@52,@58,@53,@34,@37,@36,@100];
    [_activityPathDict setObject:woman forKey:@"女子"];
    
    NSArray *youth = @[@45,@47,@33,@51,@35,@34,@58,@37,@36,@52,@55,@48,@50,@32,@44,@46,@49,@100];
    [_activityPathDict setObject:youth forKey:@"青年"];
    
    NSArray *youngsters = @[@45,@32,@31,@47,@50,@33,@55,@59,@52,@35,@34,@53,@38,@58,@37,@36,@51,@40,@100];
    [_activityPathDict setObject:youngsters forKey:@"青少年"];
    
    NSArray *middleYouth = @[@57,@54,@56,@31,@46,@47,@50,@55,@52,@36,@37,@39,@58,@53,@58,@34,@51,@40,@100];
    [_activityPathDict setObject:middleYouth forKey:@"中青年"];
}

-(NSArray*)getAllRegisteredActivities
{
    return _activitiesArray;
}
-(void)addNewActivity :(ActivityModel*)newActivity
{
    [_activitiesArray addObject:newActivity];
    NSInteger x=0;
    while(x<[_activitiesArray count])
    {
        NSString *tempNumber = [NSString stringWithFormat:@"activityNo%d",(int)x];
        [[NSUserDefaults standardUserDefaults] setObject:[[_activitiesArray objectAtIndex:x] mapType] forKey:tempNumber];
        x++;
    }

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:x] forKey:@"registeredActivityNumber"];
}

-(void)deleteActivity: (NSInteger)index
{
    [_activitiesArray removeObjectAtIndex:index];
    NSInteger activityNumber = [_activitiesArray count];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:activityNumber] forKey:@"registeredActivityNumber"];
    
    NSString *tempNumber = [NSString stringWithFormat:@"activityNo%d",(int)index];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:tempNumber];
}

-(NSArray*)getCorrespondingPathArray: (ActivityModel*)activity
{
    return [_activityPathDict objectForKey:[activity mapType]];
}

-(NSString*)getCorrespondingMapName: (ActivityModel*)activity
{
    return [_activityMapnameDict objectForKey:[activity mapType]];
}

@end
