//
//  MyActivityTableViewCell.m
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "MyActivityTableViewCell.h"

@interface MyActivityTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeCountingLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *mapTypeLabel;

@end

@implementation MyActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_myStatusLabel setTextColor:[UIColor whiteColor]];
    [_myStatusLabel setBackgroundColor:[UIColor colorWithRed:0 green:156.0/255.0 blue:235.0/255.0 alpha:1]];
    [_timeCountingLabel setText:@"5小时后开始"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitle:(NSString *)title
{
    [_titleLabel setText:title];
}

-(void)setName2:(NSString *)name2{
    [_timeCountingLabel setText:@"5小时后开始"];
}

- (IBAction)actionButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(activitySelected:)]) {
        [self.delegate activitySelected:_cellIndexNumber];
    }
}

-(void)setThumbPath:(NSString *)thumbPath
{
    //[self.thumbImageView setImage:[UIImage imageWithContentsOfFile:thumbPath]];
    [self.thumbImageView setImage:[UIImage imageNamed:thumbPath]];
}

-(void)setMapType:(NSString *)mapType
{
    [_mapTypeLabel setText:mapType];
}

@end
