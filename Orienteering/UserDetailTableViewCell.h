//
//  UserDetailTableViewCell.h
//  Orienteering
//
//  Created by macmini on 15/4/9.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserDetailInfoTableViewCellEditButtonProtocol <NSObject>
@required
-(void)userDetailInfoEditButtonClicked:(NSString*)username;
@end

@interface UserDetailTableViewCell : UITableViewCell

@property(nonatomic, copy)NSString *thumbPath;
@property(nonatomic, copy)NSString *username;

@property (nonatomic, weak) id <UserDetailInfoTableViewCellEditButtonProtocol> delegate;
@end
