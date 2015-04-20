//
//  StadiumsTableViewCell.m
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "StadiumsTableViewCell.h"

@interface StadiumsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

@end

@implementation StadiumsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setName:(NSString *)name
{
    [self.titleLabel setText:name];
}

-(void)setActivityInfo:(NSString *)activityInfo
{
    [self.activityInfoLabel setText:activityInfo];
}

-(void)setDescriptionString:(NSString *)descriptionString
{
    [self.descriptionLabel setText:descriptionString];
}

-(void)setThumbPath:(NSString *)thumbPath
{
    //[self.thumbImageView setImage:[UIImage imageWithContentsOfFile:thumbPath]];
    [self.thumbImageView setImage:[UIImage imageNamed:thumbPath]];
}

@end
