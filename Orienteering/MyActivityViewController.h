//
//  MyActivityViewController.h
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyActivityTableViewCell.h"

@interface MyActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyActivityTableViewCellStartProtocol>

@property(nonatomic, retain)UITableView *myActivityTableView;

@end
