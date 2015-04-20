//
//  StadiumDetailViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/13.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "StadiumDetailViewController.h"
#import "StadiumDetailFirstRowTableViewCell.h"
#import "StadiumDetailOtherInfoTableViewCell.h"
#import "ApplyFormViewController.h"

static NSString * const StadiumDetailFirstRowTableViewCellReuseIdentifier = @"stadiumDetailFirstRowTableViewCell";
static NSString * const StadiumDetailOtherInfoTableViewCellReuseIdentifier = @"stadiumDetailOtherInfoTableViewCell";

@interface StadiumDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *stadiumDetailTableView;
@property (retain, nonatomic) NSArray *pathList;
@end

@implementation StadiumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _stadiumDetailTableView.dataSource = self;
    _stadiumDetailTableView.delegate = self;
    
    _pathList = @[@"男子",@"女子",@"家庭",@"青年",@"中青年",@"青少年"];
    
    [_stadiumDetailTableView registerNib:[UINib nibWithNibName:@"StadiumDetailFirstRowTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:StadiumDetailFirstRowTableViewCellReuseIdentifier];
    
    [_stadiumDetailTableView registerNib:[UINib nibWithNibName:@"StadiumDetailOtherInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:StadiumDetailOtherInfoTableViewCellReuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)swipeRightDetected:(id)sender {
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

#pragma tableview methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //if(section == 0)
    //{
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 24)];
    
    footView.backgroundColor = [UIColor colorWithRed:221.0/225.0 green:221.0/225.0 blue:221.0/225.0 alpha:1.0];
    
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pathIndicator"]];
        CGRect oldFrame = imageView.frame;
        CGRect newFrame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-39, 12.0-7.5, 78, 15);
        imageView.frame = newFrame;
        
        [footView addSubview:imageView];
    
    UILabel *indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-30, 12.0-7.5, 60, 15)];
    [indicatorLabel setFont:[UIFont systemFontOfSize:10.0]];
    [indicatorLabel setTextColor:[UIColor whiteColor]];
    [indicatorLabel setTextAlignment:NSTextAlignmentCenter];
    if(section == 0)
    {
        [indicatorLabel setText:@"场地"];
    } else
    {
        [indicatorLabel setText:@"路线"];
    }
    
    [footView addSubview:indicatorLabel];
        return footView;
    //} else {
        return nil;
    //}
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
            
        case 0:
            return 3;
            break;
            
        case 1:
            return [_pathList count];
            break;

        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            
        case 0:
            if([indexPath row] == 0)
            {
                return 80;
            } else
            {
                return 44;
            }
            break;
            
        case 1:
            return 44;
            break;
            
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        switch ([indexPath row]) {
                
            case 0:
            {
                StadiumDetailFirstRowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StadiumDetailFirstRowTableViewCellReuseIdentifier forIndexPath:indexPath];
                [cell setDescriptionString:@"五台山体育馆"];
                [cell setThumbPath:@"testStadiumThumb.jpg"];
                [cell setText2:@"一次穿越玄武湖的灵感之旅"];
                return cell;
            }
            break;
                
            case 1:
            {
                StadiumDetailOtherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StadiumDetailOtherInfoTableViewCellReuseIdentifier forIndexPath:indexPath];
                [cell setText1:@"五台山体育馆的地址"];
                return cell;
            }
                
            break;
            case 2:
            {
                StadiumDetailOtherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StadiumDetailOtherInfoTableViewCellReuseIdentifier forIndexPath:indexPath];
                [cell setText1:@"02566666666"];
                return cell;
            }
                
            break;
                
            default:
                return 0;
                break;
        }
    } else {
        StadiumDetailOtherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StadiumDetailOtherInfoTableViewCellReuseIdentifier forIndexPath:indexPath];
        
        
        [cell setText1:[_pathList objectAtIndex:([indexPath row])]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    if(indexPath.section == 0)
    {
        if([indexPath row] == 2)
        {
            UIAlertController *pickerChooseVC = [UIAlertController alertControllerWithTitle:@"拨打电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [pickerChooseVC addAction:[UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:02566666666"]];
            }]];
            
            [pickerChooseVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [pickerChooseVC dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [self presentViewController:pickerChooseVC animated:YES completion:nil];
            
        }
    } else
    {
        ApplyFormViewController *aVC = [[ApplyFormViewController alloc] init];
        aVC.pathType = [_pathList objectAtIndex:[indexPath row]];
        [[self navigationController] pushViewController:aVC animated:YES];
    }
}


@end
