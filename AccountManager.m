//
//  AccountManager.m
//  Orienteering
//
//  Created by macmini on 15/4/23.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "AccountManager.h"
#import "UserInfoCacheManager.h"

@implementation AccountManager

+(instancetype)sharedInstance
{
    static AccountManager *_defaultManager = nil;
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

        
    }
    return self;
}

-(BOOL)loginUsingUsername :(NSString*)username password:(NSString*)pwd
{
    
    return NO;
}

@end
