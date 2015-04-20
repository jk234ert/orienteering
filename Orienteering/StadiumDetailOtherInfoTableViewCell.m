//
//  StadiumDetailOtherInfoTableViewCell.m
//  Orienteering
//
//  Created by macmini on 15/4/13.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "StadiumDetailOtherInfoTableViewCell.h"

@interface StadiumDetailOtherInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *text1Label;

@end

@implementation StadiumDetailOtherInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setText1:(NSString *)text1
{
    [self.text1Label setText:text1];
}

@end
