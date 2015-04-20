//
//  StadiumsViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "StadiumsViewController.h"
#import "JTHamburgerButton.h"
#import "AppDelegate.h"
#import "StadiumsTableViewCell.h"
#import "StadiumDetailViewController.h"
#import "MJRefresh.h"

static NSString * const StadiumsCellReuseIdentifier = @"stadiumsTableViewCell";

@interface StadiumsViewController ()
@property (weak, nonatomic) IBOutlet JTHamburgerButton *menuButton;

@end

@implementation StadiumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHamberButton) name:@"menuClosedByTapCenterView" object:nil];
    
    _stadiumsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    
    _stadiumsTableView.dataSource = self;
    _stadiumsTableView.delegate = self;
    
    [_stadiumsTableView registerNib:[UINib nibWithNibName:@"StadiumsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:StadiumsCellReuseIdentifier];

    
    [self.view addSubview:_stadiumsTableView];
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [_stadiumsTableView setTableFooterView:view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setMenuSelected" object:[[NSNumber alloc] initWithInt:2]];
    
    __weak typeof(self) weakSelf = self;
    [_stadiumsTableView addLegendHeaderWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [weakSelf.stadiumsTableView reloadData];
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [weakSelf.stadiumsTableView.header endRefreshing];
        });
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)closeHamberButton
{
    [_menuButton setCurrentModeWithAnimation:JTHamburgerButtonModeHamburger];
}

-(void)toggleHamburgerButton
{
    if(_menuButton.currentMode == JTHamburgerButtonModeHamburger){
        [_menuButton setCurrentModeWithAnimation:JTHamburgerButtonModeArrow];
    }
    else{
        [_menuButton setCurrentModeWithAnimation:JTHamburgerButtonModeHamburger];
    }
}
- (IBAction)menuButtonClicked:(id)sender {
    [self toggleHamburgerButton];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
- (IBAction)swipeRightDetected:(id)sender {
    [self toggleHamburgerButton];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

#pragma tableview methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StadiumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StadiumsCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[StadiumsTableViewCell alloc] init];
    }
    
    if(indexPath.row == 0) {
        [cell setName:@"玄武湖"];
        [cell setActivityInfo:@"该场地共有三项活动/第二项即将进行"];
        [cell setDescriptionString:@"一次穿越玄武湖的灵感之旅"];
        
        [cell setThumbPath:@"testStadiumThumb.jpg"];
        
    } else {
        [cell setName:@"222222"];
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    StadiumDetailViewController *aVC = [[StadiumDetailViewController alloc] init];
    
    [[self navigationController] pushViewController:aVC animated:YES];
}

@end
