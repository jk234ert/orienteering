//
//  StadiumsViewController.h
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface StadiumsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain)UITableView *stadiumsTableView;

@end
