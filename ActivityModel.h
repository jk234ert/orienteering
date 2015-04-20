//
//  ActivityModel.h
//  Orienteering
//
//  Created by macmini on 15/4/17.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject<NSCoding, NSCopying>

@property(copy,nonatomic)NSString *stadiumName;
@property(copy,nonatomic)NSString *mapType;

-(instancetype)initWithStadiums :(NSString*)stadiumName mapType:(NSString*)mapTypeString;

@end
