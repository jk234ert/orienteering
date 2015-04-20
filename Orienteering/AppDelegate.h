//
//  AppDelegate.h
//  Orienteering
//
//  Created by macmini on 15/3/30.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyActivityViewController.h"
#import "MenuTableViewController.h"
#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyActivityViewController *myActivityVC;
@property (strong, nonatomic) MenuTableViewController *menuTableVC;
@property (strong, nonatomic) JVFloatingDrawerViewController *drawerViewController;

+ (AppDelegate *)globalDelegate;

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;
- (void)closeLeftDrawer:(id)sender animated:(BOOL)animated;

- (void)loginSuccess;

@end

