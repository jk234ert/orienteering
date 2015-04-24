//
//  UserInfoManager.h
//  Orienteering
//
//  Created by macmini on 15/4/10.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserInfoCacheManager : NSObject

+(NSString*)getStoredUserID;
+(NSString*)getStoredUsername;
+(NSString*)getStoredUserRealName;
+(UIImage*)getStoredUserAvatar;
+(NSString*)getStoredUserGender;
+(NSInteger)getStoredUserHeight;
+(NSInteger)getStoredUserWeight;
+(NSDate*)getStoredUserBirthDay;
+(NSString*)getStoredUserPWD;

+(void)saveStoredUserID:(NSString*)newUserID;
+(void)saveStoredUsername:(NSString*)newUserName;
+(void)saveStoredUserRealName:(NSString*)newUserRealName;
+(void)saveStoredUserAvatar:(UIImage*)newUserAvatar;
+(void)saveStoredUserGender:(NSString*)newUserGender;
+(void)saveStoredUserHeight:(NSInteger)newUserHeight;
+(void)saveStoredUserWeight:(NSInteger)newUserWeight;
+(void)saveStoredUserBirthDay:(NSDate*)newUserBirthDay;
+(void)saveStoredUserPWD:(NSString*)newUserPWD;

+(void)saveStoredUser:(NSDictionary*)userDict password:(NSString*)pwd;

@end
