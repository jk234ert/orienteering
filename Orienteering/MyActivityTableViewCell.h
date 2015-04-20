//
//  MyActivityTableViewCell.h
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyActivityStatus) {
    MyActivityStatusMissed = 0,
    MyActivityStatusParticipated,
    MyActivityStatusInProcess,
    MyActivityStatusInProcessWaiting
};

@protocol MyActivityTableViewCellStartProtocol <NSObject>
@required
-(void)activitySelected:(NSInteger)cellIndexNumber;
@end

@interface MyActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *name2;
@property(nonatomic, copy)NSString *thumbPath;
@property(nonatomic, copy)NSString *mapType;
@property(nonatomic)NSInteger cellIndexNumber;

@property (nonatomic, weak) id <MyActivityTableViewCellStartProtocol> delegate;

@end
