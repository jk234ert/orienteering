//
//  LoginViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/9.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserInfoCacheManager.h"
#import "AccountManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSUserDefaults standardUserDefaults] setValue:@"notlogin" forKey:@"loginstatus"];
    _usernameTextField.tag = 1;
    _pwdTextField.tag = 2;
    _usernameTextField.delegate = self;
    _pwdTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)testLoginButtonClicked:(id)sender {
    [self login];
}

-(void)login
{
    //[[AccountManager sharedInstance] loginUsingUsername:[self.usernameTextField text] password:[self.pwdTextField text]];
    
    if([[self.usernameTextField text] isEqualToString:@""])
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"错误" message:@"用户名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    if([[self.pwdTextField text] isEqualToString:@""])
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"错误" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    [self.usernameTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    
    [[AccountManager sharedInstance] loginUsingUsername:[self.usernameTextField text] password:[self.pwdTextField text] mainVC:self completionBlock:^{
        //[UserInfoCacheManager saveStoredUsername:[self.usernameTextField text]];
        //[UserInfoCacheManager saveStoredUserPWD:[self.pwdTextField text]];
        [[AppDelegate globalDelegate] loginSuccess];
    }];
    return;
    [UserInfoCacheManager saveStoredUsername:[self.usernameTextField text]];
    [UserInfoCacheManager saveStoredUserPWD:[self.pwdTextField text]];
    [[AppDelegate globalDelegate] loginSuccess];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        [_pwdTextField becomeFirstResponder];
    } else {
        [self login];
    }
    return YES;
}

@end
