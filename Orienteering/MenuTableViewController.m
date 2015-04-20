//
//  MenuTableViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuTableViewCell.h"
#import "AppDelegate.h"
#import "StadiumsViewController.h"
#import "UserInfoTableViewCell.h"
#import "UserDetailViewController.h"

static NSString * const DrawerCellReuseIdentifier = @"DrawerTableViewCell";
static NSString * const DrawerUserInfoCellReuseIdentifier = @"userInfoTableViewCell";


@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DrawerCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DrawerUserInfoCellReuseIdentifier];
    [self.tableView setScrollEnabled:NO];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleSwipeLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(setMenuSelected:) name:@"setMenuSelected" object:nil];
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"loginstatus"] isEqualToString:@"notlogin"])
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [[NSUserDefaults standardUserDefaults] setValue:@"alreadylogin" forKey:@"loginstatus"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMenuSelected:(NSNotification*)noti
{
    NSLog(@"select ID %@",[noti object]);
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:[(NSNumber*)[noti object] integerValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 160;
    }
    return 60;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0)
    {
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DrawerUserInfoCellReuseIdentifier forIndexPath:indexPath];

        return cell;
    }
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DrawerCellReuseIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        //case 0:
           // [cell setMenuTitle:@""];
           // [cell setUserInteractionEnabled:NO];
           // break;
        case 1:
            [cell setMenuTitle:@"我的活动"];
            [cell setThumbPath:@"myActivityIcon"];
            break;
        case 2:
            [cell setMenuTitle:@"场地"];
            [cell setThumbPath:@"stadiumsIcon"];
            break;
            
        default:
            [cell setMenuTitle:@"活动"];
            [cell setThumbPath:@"stadiumsIcon"];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *destinationViewController = nil;
    
    switch (indexPath.row) {
            case 0:
            destinationViewController = [[UserDetailViewController alloc] init];
             break;
        case 1:
            destinationViewController = [[AppDelegate globalDelegate] myActivityVC];
            break;
        case 2:
            destinationViewController = [[StadiumsViewController alloc] init];
            break;
            
        default:
            destinationViewController = [[StadiumsViewController alloc] init];
            break;
    }
    
    [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:destinationViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuClosedByTapCenterView" object:nil];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];

}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
