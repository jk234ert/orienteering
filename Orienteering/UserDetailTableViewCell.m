//
//  UserDetailTableViewCell.m
//  Orienteering
//
//  Created by macmini on 15/4/9.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "UserDetailTableViewCell.h"
#import "UserInfoCacheManager.h"

@interface UserDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *uesrAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation UserDetailTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserInfo) name:@"USER_INFO_UPDATED" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)editButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userDetailInfoEditButtonClicked:)]) {
        [self.delegate userDetailInfoEditButtonClicked:_username];
    }
}

-(void)setUsername:(NSString *)username
{
    [self.usernameLabel setText:username];
}

-(void)setThumbPath:(NSString *)thumbPath
{
    //[self.thumbImageView setImage:[UIImage imageWithContentsOfFile:thumbPath]];
    [self.uesrAvatarImageView setImage:[UIImage imageNamed:thumbPath]];
}

-(void)setUserInfo
{
    UIImage *image = [UserInfoCacheManager getStoredUserAvatar];
    if(image)
    {
        [self.uesrAvatarImageView setImage:image];
        self.uesrAvatarImageView.backgroundColor = [UIColor whiteColor];
    } else {
        if([[UserInfoCacheManager getStoredUserGender] isEqualToString:@"女"])
        {
            image = [UIImage imageNamed:@"defaultFemaleUserGrayAvatar"];
        } else {
            image = [UIImage imageNamed:@"defaultMaleUserGrayAvatar"];
        }

        [self.uesrAvatarImageView setImage:image];
        self.uesrAvatarImageView.backgroundColor = [UIColor colorWithRed:221.0/225.0 green:221.0/225.0 blue:221.0/225.0 alpha:1];
    }
    
    [self.usernameLabel setText:[UserInfoCacheManager getStoredUsername]];
}

@end
