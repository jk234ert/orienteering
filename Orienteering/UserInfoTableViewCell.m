//
//  UserInfoTableViewCell.m
//  Orienteering
//
//  Created by macmini on 15/4/9.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "UserInfoCacheManager.h"

@interface UserInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    [self setUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserInfo) name:@"USER_INFO_UPDATED" object:nil];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUserInfo
{
    UIImage *image = [UserInfoCacheManager getStoredUserAvatar];
    if(image)
    {
        [self.userAvatarImageView setImage:image];
    } else {
        if([[UserInfoCacheManager getStoredUserGender] isEqualToString:@"女"])
        {
           image = [UIImage imageNamed:@"defaultFemaleUserTransparentAvatar"];
        } else {
            image = [UIImage imageNamed:@"defaultMaleUserTransparentAvatar"];
        }
        
        [self.userAvatarImageView setImage:image];
    }
    [self.usernameLabel setText:[UserInfoCacheManager getStoredUsername]];
}

@end
