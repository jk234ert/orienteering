//
//  UserInfoManager.m
//  Orienteering
//
//  Created by macmini on 15/4/10.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "UserInfoCacheManager.h"
#import "TimeUtil.h"

@implementation UserInfoCacheManager

+(NSString*)getStoredUserID
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString* userid = [preferences objectForKey:@"userid"];
    if (userid) {
        return [userid copy];
    }
    else {
        return nil;
    }
}

+(NSString*)getStoredUsername
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString* username = [preferences objectForKey:@"username"];
    if (username) {
        return [username copy];
    }
    else {
        return nil;
    }
}


+(NSString*)getStoredUserRealName{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString* userrealname = [preferences objectForKey:@"userrealname"];
    if (userrealname) {
        return [userrealname copy];
    }
    else {
        return nil;
    }
}


+(UIImage*)getStoredUserAvatar{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSData* imageData = [preferences objectForKey:@"userAvatar"];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
        return [image copy];
    }
    else {
        return nil;
    }
    
}


+(NSString*)getStoredUserGender{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString* usergender = [preferences objectForKey:@"usergender"];
    if (usergender) {
        return [usergender copy];
    }
    else {
        return nil;
    }
}


+(NSInteger)getStoredUserHeight{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSNumber* userheightvalue = [preferences objectForKey:@"userheight"];
    if (userheightvalue) {
        return [userheightvalue integerValue];
    }
    else {
        return 0;
    }
}


+(NSInteger)getStoredUserWeight{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSNumber* userweightvalue = [preferences objectForKey:@"userweight"];
    if (userweightvalue) {
        return [userweightvalue integerValue];
    }
    else {
        return 0;
    }
}


+(NSDate*)getStoredUserBirthDay{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSDate* userbirthday = [preferences objectForKey:@"userbirthday"];
    if (userbirthday) {
        return [userbirthday copy];
    }
    else {
        return 0;
    }
}


+(NSString*)getStoredUserPWD{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString* userpwd = [preferences objectForKey:@"userpwd"];
    if (userpwd) {
        return [userpwd copy];
    }
    else {
        return 0;
    }
}

/**
 *  ---------------------------------------------------------------------
 */

+(void)saveStoredUserID:(NSString*)newUserID
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:newUserID forKey:@"userid"];
}

+(void)saveStoredUsername:(NSString*)newUserName
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:newUserName forKey:@"username"];
}


+(void)saveStoredUserRealName:(NSString*)newUserRealName
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:newUserRealName forKey:@"userrealname"];
}


+(void)saveStoredUserAvatar:(UIImage*)newUserAvatar{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:UIImagePNGRepresentation(newUserAvatar) forKey:@"userAvatar"];
}


+(void)saveStoredUserGender:(NSString*)newUserGender{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:newUserGender forKey:@"usergender"];
}


+(void)saveStoredUserHeight:(NSInteger)newUserHeight{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:[NSNumber numberWithInteger:newUserHeight] forKey:@"userheight"];
}


+(void)saveStoredUserWeight:(NSInteger)newUserWeight{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:[NSNumber numberWithInteger:newUserWeight] forKey:@"userweight"];
}


+(void)saveStoredUserBirthDay:(NSDate*)newUserBirthDay{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:newUserBirthDay forKey:@"userbirthday"];
}


+(void)saveStoredUserPWD:(NSString*)newUserPWD{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:newUserPWD forKey:@"userpwd"];
}

+(void)saveStoredUser:(NSDictionary*)userDict password:(NSString*)pwd
{
    [self saveStoredUserID:[userDict objectForKey:@"userid"]];
    [self saveStoredUsername:[userDict objectForKey:@"alias"]];
    [self saveStoredUserRealName:[userDict objectForKey:@"realname"]];
    //[self saveStoredUserAvatar:[userDict objectForKey:@"realname"]];
    [self saveStoredUserGender:[userDict objectForKey:@"gender"]];
    [self saveStoredUserHeight:[(NSNumber*)[userDict objectForKey:@"height"] integerValue]];
    [self saveStoredUserWeight:[(NSNumber*)[userDict objectForKey:@"weight"] integerValue]];
    
    NSString *dateString = [userDict objectForKey:@"birthday"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];

    
    [self saveStoredUserBirthDay:date];
    [self saveStoredUserPWD:pwd];


}



@end
