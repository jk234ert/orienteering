//
//  ApplyInfoObject.h
//  Orienteering
//
//  Created by macmini on 15/4/14.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyInfoObject : NSObject

@property(retain,nonatomic)NSString *username;
@property(retain,nonatomic)NSData *userAvatar;
@property(retain,nonatomic)NSString *userRealName;
@property(retain,nonatomic)NSString *userGender;
@property(nonatomic)NSInteger userHeight;
@property(nonatomic)NSInteger userWeight;
@property(retain,nonatomic)NSDate *userBirthday;

@end
