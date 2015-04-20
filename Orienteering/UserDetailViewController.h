//
//  UserDetailViewController.h
//  Orienteering
//
//  Created by macmini on 15/4/9.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailTableViewCell.h"

@interface UserDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UserDetailInfoTableViewCellEditButtonProtocol>

@end
