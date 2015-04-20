//
//  ActivityViewController.h
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QRCodeReaderDelegate.h"
#import "ActivityManager.h"

@interface ActivityViewController : UIViewController<QRCodeReaderDelegate,CLLocationManagerDelegate>

@property(nonatomic, retain)ActivityModel *currentActivity;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDirection currentHeading;

@end
