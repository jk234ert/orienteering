//
//  AppDelegate.m
//  Orienteering
//
//  Created by macmini on 15/3/30.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RZTransitionsManager.h"
#import "RZCirclePushAnimationController.h"
#import "RZZoomAlphaAnimationController.h"
#import "RZCardSlideAnimationController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    /*
    _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
    
    _myActivityVC = [[MyActivityViewController alloc] init];
    _menuTableVC = [[MenuTableViewController alloc] init];
    // Assign to your own view controllers
    _drawerViewController.leftViewController   = _menuTableVC;
    //drawerViewController.rightViewController  = nil;
    _drawerViewController.centerViewController = _myActivityVC;
    
    _drawerViewController.backgroundImage = [UIImage imageNamed:@"mainViewBackground"];
    
    _drawerViewController.animator = [[JVFloatingDrawerSpringAnimator alloc] init];
    
    //UINavigationController *nacController = [[UINavigationController alloc] initWithRootViewController:_drawerViewController];
    //[nacController setNavigationBarHidden:YES];
    */
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[self.window setRootViewController:nacController];
    
    [self.window setRootViewController:loginVC];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    id<RZAnimationControllerProtocol> presentDismissAnimationController = [[RZCirclePushAnimationController alloc] init];
    //id<RZAnimationControllerProtocol> pushPopAnimationController = [[RZCardSlideAnimationController alloc] init];
    [[RZTransitionsManager shared] setDefaultPresentDismissAnimationController:presentDismissAnimationController];
    //[[RZTransitionsManager shared] setDefaultPushPopAnimationController:pushPopAnimationController];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}

- (void)closeLeftDrawer:(id)sender animated:(BOOL)animated
{
    [self.drawerViewController closeDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:nil];
}

- (void)loginSuccess
{
    UIViewController *loginVC = [self.window rootViewController];
    
    _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
    
    _myActivityVC = [[MyActivityViewController alloc] init];
    _menuTableVC = [[MenuTableViewController alloc] init];
    // Assign to your own view controllers
    _drawerViewController.leftViewController   = _menuTableVC;
    //drawerViewController.rightViewController  = nil;
    _drawerViewController.centerViewController = _myActivityVC;
    
    _drawerViewController.backgroundImage = [UIImage imageNamed:@"mainViewBackground"];
    
    _drawerViewController.animator = [[JVFloatingDrawerSpringAnimator alloc] init];
    
    UINavigationController *nacController = [[UINavigationController alloc] initWithRootViewController:_drawerViewController];
    
    [nacController setNavigationBarHidden:YES];

    [nacController setTransitioningDelegate:[RZTransitionsManager shared]];
    [loginVC presentViewController:nacController animated:YES completion:nil];
}

@end