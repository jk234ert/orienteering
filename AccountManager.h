//
//  AccountManager.h
//  Orienteering
//
//  Created by macmini on 15/4/23.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ROOT_URL @"http://58.213.138.147/orienteering/"

@interface AccountManager : NSObject

+(instancetype)sharedInstance;


-(void)loginUsingUsername :(NSString*)username password:(NSString*)pwd mainVC:(UIViewController*)vc completionBlock:(void (^)())loginBlock;
-(void)logout;



@end
