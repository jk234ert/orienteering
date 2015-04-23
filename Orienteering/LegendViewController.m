//
//  LegendViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/23.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "LegendViewController.h"

@interface LegendViewController ()
@property (weak, nonatomic) IBOutlet UIButton *infoTypeSwitchButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@end

@implementation LegendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainImageView setImage:[UIImage imageNamed:_dotInfoImageName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)infoTypeSwitchButtonClicked:(id)sender {
    if([[_infoTypeSwitchButton titleForState:UIControlStateNormal] isEqualToString:@"图例"])
    {
        [_infoTypeSwitchButton setTitle:@"检查点说明" forState:UIControlStateNormal];
        [self.mainImageView setImage:[UIImage imageNamed:@"legend"]];
        
        //self.mainImageView.contentMode = UIViewContentModeScaleToFill;
        //self.mainImageView.frame = CGRectMake(, 0, 320, 460);
    } else {
        [_infoTypeSwitchButton setTitle:@"图例" forState:UIControlStateNormal];
        [self.mainImageView setImage:[UIImage imageNamed:_dotInfoImageName]];
        
        //self.mainImageView.frame = CGRectMake(0, 0, 320, 460);
    }
}


@end
