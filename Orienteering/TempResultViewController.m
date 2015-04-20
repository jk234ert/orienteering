//
//  TempResultViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/16.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "TempResultViewController.h"
#import "TimeUtil.h"

@interface TempResultViewController ()
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property(nonatomic,strong)NSMutableArray *eachDotTimeCostArray;

@end

@implementation TempResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _eachDotTimeCostArray = [[NSMutableArray alloc] initWithCapacity:10];
    for(int x=0;x<([_scoreArray count]-1);x++)
    {
        //NSDate *beginDate = [_scoreArray objectAtIndex:x];
        //NSDate *finishDate = [_scoreArray objectAtIndex:(x+1)];
        
    }
    
    _resultTableView.dataSource = self;
    _resultTableView.delegate = self;
    [_resultTableView setAllowsSelection:NO];
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [_resultTableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma tableview methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([_scoreArray count]+1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"resultTableViewCell"];
    
    NSString *dotCostDescriptionString;
    if([indexPath row]==0)
    {
        dotCostDescriptionString = [NSString stringWithFormat:@"总用时"];
        
        NSString *detailString = [TimeUtil getTimeStringBetweenFirstDate:[_scoreArray objectAtIndex:0] andSecondDate:[_scoreArray lastObject]];
        cell.detailTextLabel.text = _totalTimeString;
    } else if([indexPath row]==1){
        dotCostDescriptionString = [NSString stringWithFormat:@"出发时间"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh 时 mm 分 ss 秒"];
        NSString *detailString = [dateFormatter stringFromDate:[_scoreArray objectAtIndex:0]];
        cell.detailTextLabel.text = detailString;
    } else {
        dotCostDescriptionString = [NSString stringWithFormat:@"到达点标%@时间",[_dotNumberArray objectAtIndex:([indexPath row]-2)]];
        
        if(([indexPath row]-2) <= _finishedDotNumber)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"hh 时 mm 分 ss 秒"];
            NSString *detailString = [dateFormatter stringFromDate:[_scoreArray objectAtIndex:([indexPath row]-1)]];
            cell.detailTextLabel.text = detailString;
        } else {
            cell.detailTextLabel.text = @"--";
        }
    }
    
    cell.textLabel.text = dotCostDescriptionString;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
