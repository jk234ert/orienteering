//
//  ResultViewViewController.h
//  Orienteering
//
//  Created by macmini on 15/4/16.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface ResultViewViewController : UIViewController<XYPieChartDelegate,XYPieChartDataSource>

@property(nonatomic, retain)NSMutableArray *scoreArray;
@property(nonatomic, retain)NSMutableArray *dotArray;

@end
