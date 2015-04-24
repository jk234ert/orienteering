//
//  AccountManager.m
//  Orienteering
//
//  Created by macmini on 15/4/23.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "AccountManager.h"
#import "UserInfoCacheManager.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"


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

-(void)loginUsingUsername :(NSString*)username password:(NSString*)pwd mainVC:(UIViewController*)vc completionBlock:(void (^)())loginBlock
{
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        NSString *loginURL = [NSString stringWithFormat:ROOT_URL@"user/login?username=%@&password=%@",username,pwd];
        
        [manager GET:loginURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"login get userid request response is %@",responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                NSString *requestTmp = [NSString stringWithString:operation.responseString];
                NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",resultDic);
                //CFBooleanRef* success = [resultDic objectForKey:@"success"];
                NSNumber *number = [resultDic objectForKey:@"messageid"];
                NSLog(@"number value is %d",[number intValue]);
                
                if([number intValue] > 0){
                    NSArray *userInfoArray = [resultDic objectForKey:@"results"];
                    NSDictionary *userInfoDict = [userInfoArray objectAtIndex:0];
                    
                    [UserInfoCacheManager saveStoredUser:userInfoDict password:pwd];
                    
                    //[UserInfoCacheManager saveStoredUsername:[self.usernameTextField text]];
                    //[UserInfoCacheManager saveStoredUserPWD:[self.pwdTextField text]];
                    
                    if(loginBlock)
                    {
                        loginBlock();
                    }
                
                    
                } else if([number intValue] == -1){
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"错误" message:@"该用户不存在，请核实您输入的用户名是否正确" preferredStyle:UIAlertControllerStyleAlert];
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [vc presentViewController:alertVC animated:YES completion:nil];
                    //[SVProgressHUD showErrorWithStatus:@"该用户不存在，请核实您输入的用户名是否正确！"];
                } else if([number intValue] == -2)
                {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"错误" message:@"密码错误,请重新输入" preferredStyle:UIAlertControllerStyleAlert];
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [vc presentViewController:alertVC animated:YES completion:nil];
                    //[SVProgressHUD showErrorWithStatus:@"密码错误,请重新输入"];
                } else {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"错误" message:@"服务器错误" preferredStyle:UIAlertControllerStyleAlert];
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [vc presentViewController:alertVC animated:YES completion:nil];
                    //[SVProgressHUD showErrorWithStatus:@"服务器错误"];
                }
                
                
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"login get userid error is %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"网络错误，请检查网络连接"];

            });
        }];
        
    });
}

@end
