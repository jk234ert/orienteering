//
//  UserDetailViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/9.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "UserDetailViewController.h"
#import "JTHamburgerButton.h"
#import "AppDelegate.h"
#import "UserInfoEditViewController.h"
#import "UserInfoCacheManager.h"

static NSString * const UserDetailInfoCellReuseIdentifier = @"userDetailInfoTableViewCell";

@interface UserDetailViewController ()
@property (weak, nonatomic) IBOutlet JTHamburgerButton *menuButton;
@property(nonatomic, retain)UITableView *detailInfoTableView;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHamberButton) name:@"menuClosedByTapCenterView" object:nil];
    
    _detailInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    
    _detailInfoTableView.dataSource = self;
    _detailInfoTableView.delegate = self;
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [_detailInfoTableView setTableFooterView:view];
    
    [_detailInfoTableView registerNib:[UINib nibWithNibName:@"UserDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:UserDetailInfoCellReuseIdentifier];
    
    [self.view addSubview:_detailInfoTableView];
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

- (IBAction)navButtonClicked:(id)sender {
    [self toggleHamburgerButton];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
- (IBAction)swipeRightDetected:(id)sender {
    [self toggleHamburgerButton];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)logOffButtonClicked:(id)sender {
    [UserInfoCacheManager removeAllCache];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma tableview methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {

        case 0:
        case 1:
        case 2:
            return 1;
            break;
            
        case 3:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserDetailInfoCellReuseIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == 0) {
        
        cell.delegate = self;
        
        return cell;
        
    } else {
        [cell setUsername:@"222222"];
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            
        case 0:
            return 140;
            break;

        default:
            return 100;
            break;
    }
}

-(void)userDetailInfoEditButtonClicked:(NSString *)username
{
    UserInfoEditViewController *aVC = [[UserInfoEditViewController alloc] init];
    //aVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[self presentViewController:aVC animated:YES completion:nil];
    
    [[self navigationController] pushViewController:aVC animated:YES];
}

@end
