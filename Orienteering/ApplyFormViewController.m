//
//  ApplyFormViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/14.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "ApplyFormViewController.h"
#import "EditUserInfoTableViewCell.h"
#import "TimeUtil.h"
#import "UserInfoCacheManager.h"
#import "ActionSheetPicker.h"
#import "ApplyInfoObject.h"
#import "ActivityManager.h"
#import "AppDelegate.h"

static NSString* const editUserInfoTableViewCellReuseIdetifier = @"editUserInfoTableViewCell";

@interface ApplyFormViewController ()
@property (weak, nonatomic) IBOutlet UITableView *applyFormInfoTableView;
@property (retain, nonatomic) ApplyInfoObject *defaultApplyInfoObject;
@end

@implementation ApplyFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _applyFormInfoTableView.delegate = self;
    _applyFormInfoTableView.dataSource = self;
    
    [_applyFormInfoTableView setScrollEnabled:NO];
    
    [_applyFormInfoTableView registerNib:[UINib nibWithNibName:@"EditUserInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:editUserInfoTableViewCellReuseIdetifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserInfo) name:@"APPLY_INFO_UPDATED" object:nil];
    
    _defaultApplyInfoObject = [[ApplyInfoObject alloc] init];
    [self setupDefaultApplyInfo];

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
- (IBAction)useDefaultInfoButtonClicked:(id)sender {
    [self setupDefaultApplyInfo];
    [_applyFormInfoTableView reloadData];
}
- (IBAction)confirmApplyButtonClicked:(id)sender {
    
    ActivityModel *newActivity = [[ActivityModel alloc] initWithStadiums:@"五台山" mapType:_pathType];
    [[ActivityManager sharedInstance] addNewActivity:newActivity];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"activityupdate" object:nil];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
    
    [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:[[AppDelegate globalDelegate] myActivityVC]];
}


-(void)setupDefaultApplyInfo
{
    
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSData* imageData = [preferences objectForKey:@"userAvatar"];
    if(imageData)
    {
        [_defaultApplyInfoObject setUserAvatar:imageData];
    } else {
        [_defaultApplyInfoObject setUserAvatar:nil];

    }
    [_defaultApplyInfoObject setUsername:[UserInfoCacheManager getStoredUsername]];
    [_defaultApplyInfoObject setUserRealName:[UserInfoCacheManager getStoredUserRealName]];
    [_defaultApplyInfoObject setUserGender:[UserInfoCacheManager getStoredUserGender]];
    [_defaultApplyInfoObject setUserHeight:[UserInfoCacheManager getStoredUserHeight]];
    [_defaultApplyInfoObject setUserWeight:[UserInfoCacheManager getStoredUserWeight]];
    [_defaultApplyInfoObject setUserBirthday:[UserInfoCacheManager getStoredUserBirthDay]];
    
    
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editInfoTableViewCell"];
            [cell.textLabel setText:@"修改头像"];
            UIImageView *userAvatarPreviewImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 8, 28, 28)];
            UIImage* image;
            if ([_defaultApplyInfoObject userAvatar]) {
                image = [UIImage imageWithData:[_defaultApplyInfoObject userAvatar]];
                
            }
            else {
                if([[UserInfoCacheManager getStoredUserGender] isEqualToString:@"女"])
                {
                    image = [UIImage imageNamed:@"defaultFemaleUserGrayAvatar"];
                } else {
                    image = [UIImage imageNamed:@"defaultMaleUserGrayAvatar"];
                }
            }
            
            [userAvatarPreviewImageView setImage:image];
            [cell.contentView addSubview:userAvatarPreviewImageView];
            
            UIImageView *enterArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 20, 13, 12, 18)];
            [enterArrowImageView setImage:[UIImage imageNamed:@"enterArrow"]];
            [cell.contentView addSubview:enterArrowImageView];
            cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
            return cell;
        }
            break;
            
        case 1:
        {
            EditUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editUserInfoTableViewCellReuseIdetifier forIndexPath:indexPath];
            [cell setText1:@"昵称"];
            [cell setValueString:[_defaultApplyInfoObject username]];
            return cell;
        }
            break;
            
        case 2:
        {
            EditUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editUserInfoTableViewCellReuseIdetifier forIndexPath:indexPath];
            [cell setText1:@"姓名"];
            [cell setValueString:[_defaultApplyInfoObject userRealName]];
            return cell;
        }
            break;
        case 3:
        {
            EditUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editUserInfoTableViewCellReuseIdetifier forIndexPath:indexPath];
            [cell setText1:@"性别"];
            [cell setValueString:[_defaultApplyInfoObject userGender]];
            return cell;
        }
            break;
        case 4:
        {
            EditUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editUserInfoTableViewCellReuseIdetifier forIndexPath:indexPath];
            [cell setText1:@"身高"];
            NSString *heightString = [NSString stringWithFormat:@"%ld 厘米",(long)[_defaultApplyInfoObject userHeight]];
            [cell setValueString:heightString];
            return cell;
        }
            break;
        case 5:
        {
            EditUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editUserInfoTableViewCellReuseIdetifier forIndexPath:indexPath];
            [cell setText1:@"体重"];
            NSString *heightString = [NSString stringWithFormat:@"%ld 公斤",(long)[_defaultApplyInfoObject userWeight]];
            [cell setValueString:heightString];
            return cell;
        }
            break;
        case 6:
        {
            EditUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editUserInfoTableViewCellReuseIdetifier forIndexPath:indexPath];
            [cell setText1:@"生日"];
            NSString *birthdayString = [TimeUtil NSDateToString:[_defaultApplyInfoObject userBirthday]];
            
            [cell setValueString:birthdayString];
            return cell;
        }
            break;
            
        default:
            return 0;
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    if([indexPath row] == 0)
    {
        
        UIAlertController *pickerChooseVC = [UIAlertController alertControllerWithTitle:@"选择头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [pickerChooseVC addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
            imagePickerVC.delegate = self;
            [imagePickerVC setAllowsEditing:YES];
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }]];
        
        [pickerChooseVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [imagePickerVC setAllowsEditing:YES];
            imagePickerVC.delegate = self;
            [imagePickerVC setShowsCameraControls:YES];
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }]];
        
        if([_defaultApplyInfoObject userAvatar]){
        [pickerChooseVC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

            [_defaultApplyInfoObject setUserAvatar:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_INFO_UPDATED" object:nil];
            [pickerChooseVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        }
        
        [pickerChooseVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [pickerChooseVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:pickerChooseVC animated:YES completion:nil];
    } else
    {
        
        
        switch ([indexPath row]) {
                
            case 1:
            {
                UIAlertController *editInfoAlertController;
                editInfoAlertController = [UIAlertController alertControllerWithTitle:@"请输入新昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [editInfoAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"昵称只接受中英文字符、数字及常用符号";
                }];
                [editInfoAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [editInfoAlertController dismissViewControllerAnimated:YES completion:nil];
                }]];
                [editInfoAlertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *newUsername = [(UITextField*)[[editInfoAlertController textFields] objectAtIndex:0] text];
                    
                    [_defaultApplyInfoObject setUsername:newUsername];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_INFO_UPDATED" object:nil];
                    
                    [editInfoAlertController dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [self presentViewController:editInfoAlertController animated:YES completion:nil];
            }
                break;
                
            case 2:
            {
                UIAlertController *editInfoAlertController;
                editInfoAlertController = [UIAlertController alertControllerWithTitle:@"请输入姓名" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [editInfoAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"请输入您的真实姓名";
                }];
                [editInfoAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [editInfoAlertController dismissViewControllerAnimated:YES completion:nil];
                }]];
                [editInfoAlertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *newRealname = [(UITextField*)[[editInfoAlertController textFields] objectAtIndex:0] text];
                    [_defaultApplyInfoObject setUserRealName:newRealname];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_INFO_UPDATED" object:nil];
                    
                    [editInfoAlertController dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:editInfoAlertController animated:YES completion:nil];
            }
                break;
            case 3:
            {
                NSArray *genders = @[@"男",@"女"];
                [ActionSheetStringPicker showPickerWithTitle:@"请选择性别" rows:genders initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    
                    [_defaultApplyInfoObject setUserGender:[genders objectAtIndex:selectedIndex]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_INFO_UPDATED" object:nil];
                    
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self.view];
            }
                
                break;
            case 4:
            {
                NSMutableArray *height = [[NSMutableArray alloc] initWithCapacity:10];
                for (int x = 30;x<256;x++)
                {
                    [height addObject:[NSString stringWithFormat:@"%d", x]];
                }
                [ActionSheetStringPicker showPickerWithTitle:@"请选择身高" rows:height initialSelection:141 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    [_defaultApplyInfoObject setUserHeight:(30+selectedIndex)];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_INFO_UPDATED" object:nil];
                    
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self.view];
            }
                break;
            case 5:
            {
                NSMutableArray *weight = [[NSMutableArray alloc] initWithCapacity:10];
                for (int x = 5;x<250;x++)
                {
                    [weight addObject:[NSString stringWithFormat:@"%d", x]];
                }
                [ActionSheetStringPicker showPickerWithTitle:@"请选择体重" rows:weight initialSelection:60 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    [_defaultApplyInfoObject setUserWeight:(5+selectedIndex)];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_INFO_UPDATED" object:nil];
                    
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self.view];
            }
                break;
            case 6:
            {
                
                [ActionSheetDatePicker showPickerWithTitle:@"请选择生日" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] minimumDate:[NSDate dateWithTimeIntervalSince1970:0] maximumDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                    [_defaultApplyInfoObject setUserBirthday:(NSDate*)selectedDate];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_INFO_UPDATED" object:nil];
                    
                } cancelBlock:^(ActionSheetDatePicker *picker) {
                    
                } origin:self.view];
            }
                break;
            default:
                
                break;
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"picked key is %@",info);
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [_defaultApplyInfoObject setUserAvatar:UIImagePNGRepresentation(pickedImage)];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_INFO_UPDATED" object:nil];
}

-(void)setUserInfo
{
    [_applyFormInfoTableView reloadData];
}
@end
