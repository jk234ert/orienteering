//
//  StadiumDetailFirstRowTableViewCell.m
//  Orienteering
//
//  Created by macmini on 15/4/13.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "StadiumDetailFirstRowTableViewCell.h"

@interface StadiumDetailFirstRowTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *text2Label;

@end

@implementation StadiumDetailFirstRowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDescriptionString:(NSString *)descriptionString
{
    [self.titleLabel setText:descriptionString];
}

-(void)setThumbPath:(NSString *)thumbPath
{
    //[self.thumbImageView setImage:[UIImage imageWithContentsOfFile:thumbPath]];
    [self.thumbImageView setImage:[UIImage imageNamed:thumbPath]];
}
-(void)setText2:(NSString *)text2
{
    [self.text2Label setText:text2];
}
@end
