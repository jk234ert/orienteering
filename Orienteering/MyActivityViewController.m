//
//  MyActivityViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "MyActivityViewController.h"
#import "AppDelegate.h"
#import "JTHamburgerButton.h"
#import "StadiumsViewController.h"
#import "ActivityViewController.h"
#import "btRippleButtton.h"
#import "MJRefresh.h"
#import "ActivityManager.h"


static NSString * const MyActivityCellReuseIdentifier = @"myActivityTableViewCell";


@interface MyActivityViewController ()
@property (weak, nonatomic) IBOutlet JTHamburgerButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end


@implementation MyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHamberButton) name:@"menuClosedByTapCenterView" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setMenuSelected" object:[[NSNumber alloc] initWithInt:1]];
    
    _myActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    
    _myActivityTableView.dataSource = self;
    _myActivityTableView.delegate = self;
    
    [_myActivityTableView registerNib:[UINib nibWithNibName:@"MyActivityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MyActivityCellReuseIdentifier];
    
    [_myActivityTableView setAllowsSelection:NO];
    [_myActivityTableView setAllowsSelectionDuringEditing:YES];
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [_myActivityTableView setTableFooterView:view];
    
    [self.view addSubview:_myActivityTableView];
    
    BTRippleButtton *addNewActivityrippleButton = [[BTRippleButtton alloc] initWithImage:[UIImage imageNamed:@"addNewActivityButtonImage"]
                                                                       andFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-26, [UIScreen mainScreen].bounds.size.height-52-10, 52, 52)
                                                                   onCompletion:^(BOOL success) {
                                                                       
                                                                       StadiumsViewController *stadiumsVC = [[StadiumsViewController alloc] init];
                                                                       [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:stadiumsVC];
                                                                       
                                                                   }];
    
    [addNewActivityrippleButton setRippeEffectEnabled:YES];
    [addNewActivityrippleButton setRippleEffectWithColor:[UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:0.0 alpha:1]];
    [self.view addSubview:addNewActivityrippleButton];
     __weak typeof(self) weakSelf = self;
    [_myActivityTableView addLegendHeaderWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [weakSelf.myActivityTableView reloadData];
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [weakSelf.myActivityTableView.header endRefreshing];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"activityupdate" object:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh
{
    [_myActivityTableView reloadData];
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

- (IBAction)swipeRightDetected:(id)sender {
    [self toggleHamburgerButton];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)testbuttonclicked:(id)sender {
    [self toggleHamburgerButton];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)addNewActivityButtonClicked:(id)sender {
    StadiumsViewController *stadiumsVC = [[StadiumsViewController alloc] init];
    [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:stadiumsVC];
    
}

#pragma tableview methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ActivityManager sharedInstance] getAllRegisteredActivities] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyActivityCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[MyActivityTableViewCell alloc] init];
    }
    cell.delegate = self;
    cell.cellIndexNumber = [indexPath row];
    //if(indexPath.row == 0) {
        [cell setTitle:[[[[ActivityManager sharedInstance] getAllRegisteredActivities] objectAtIndex:[indexPath row]] stadiumName]];
        [cell setThumbPath:@"testStadiumThumb.jpg"];
    [cell setMapType:[[[[ActivityManager sharedInstance] getAllRegisteredActivities] objectAtIndex:[indexPath row]] mapType]];
    //} else {
        [cell setName2:@"222222"];
        
    //}
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)activitySelected:(NSInteger)cellIndexNumber
{
    ActivityViewController *aVC = [[ActivityViewController alloc] init];
    //aVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[self presentViewController:aVC animated:YES completion:nil];
    [aVC setCurrentActivity:[[[ActivityManager sharedInstance] getAllRegisteredActivities] objectAtIndex:cellIndexNumber]];
    
    [[self navigationController] pushViewController:aVC animated:YES];
}

- (IBAction)deleteButtonClicked:(id)sender {
    
    if([[_deleteButton titleForState:UIControlStateNormal] isEqualToString:@"删除"])
    {
        [_myActivityTableView setEditing:YES animated:YES];

        [_deleteButton setTitle:@"取消" forState:UIControlStateNormal];
    } else {
        [_myActivityTableView setEditing:NO animated:YES];

        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        //        获取选中删除行索引值
        NSInteger row = [indexPath row];
        //        通过获取的索引值删除数组中的值
        [[ActivityManager sharedInstance] deleteActivity:[indexPath row]];
        //        删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


@end
