//
//  ApplyFormViewController.h
//  Orienteering
//
//  Created by macmini on 15/4/14.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyFormViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,copy)NSString *pathType;
@end
