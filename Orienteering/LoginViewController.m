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
