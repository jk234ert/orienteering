//
//  TempResultViewController.h
//  Orienteering
//
//  Created by macmini on 15/4/16.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *scoreArray;
@property(nonatomic,strong)NSArray *dotNumberArray;
@property(nonatomic)NSInteger finishedDotNumber;

@property(nonatomic,copy)NSString* totalTimeString;
@end
