//
//  AccountManager.h
//  Orienteering
//
//  Created by macmini on 15/4/23.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

+(instancetype)sharedInstance;

-(BOOL)loginUsingUsername :(NSString*)username password:(NSString*)pwd;
-(void)logout;



@end
