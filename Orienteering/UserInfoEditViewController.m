//
//  UserInfoEditViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/10.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "UserInfoEditViewController.h"
#import "ActionSheetPicker.h"
#import "EditUserInfoTableViewCell.h"
#import "UserInfoCacheManager.h"
#import "TimeUtil.h"

static NSString* const editUserInfoTableViewCellReuseIdetifier = @"editUserInfoTableViewCell";

@interface UserInfoEditViewController ()
@property(nonatomic, retain)UITableView *detailInfoTableView;
@end

@implementation UserInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    
    
    [_detailInfoTableView registerNib:[UINib nibWithNibName:@"EditUserInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:editUserInfoTableViewCellReuseIdetifier];
    
    _detailInfoTableView.dataSource = self;
    _detailInfoTableView.delegate = self;
    
    
    
    [_detailInfoTableView setScrollEnabled:NO];
    
    [self.view addSubview:_detailInfoTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserInfo) name:@"USER_INFO_UPDATED" object:nil];
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
- (IBAction)backButtonClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)edgeSwipeToRightDetected:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma tableview methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 2)
    {
        return ([UIScreen mainScreen].bounds.size.height-16*3-44*8-64);
    } else {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
            
        case 0:
            return 1;
            break;
            
        case 1:
            return 6;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editInfoTableViewCell"];
    
    if(indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editInfoTableViewCell"];
        [cell.textLabel setText:@"修改头像"];
        UIImageView *userAvatarPreviewImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 8, 28, 28)];
        NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
        NSData* imageData = [preferences objectForKey:@"userAvatar"];
        UIImage* image;
        if (imageData) {
            image = [UIImage imageWithData:imageData];
            userAvatarPreviewImageView.backgroundColor = [UIColor whiteColor];
        }
        else {
            if([[UserInfoCacheManager getStoredUserGender] isEqualToString:@"女"])
            {
                image = [UIImage imageNamed:@"defaultFemaleUserGrayAvatar"];
            } else {
                image = [UIImage imageNamed:@"defaultMaleUserGrayAvatar"];
            }
            
            userAvatarPreviewImageView.backgroundColor = [UIColor colorWithRed:221.0/225.0 green:221.0/225.0 blue:221.0/225.0 alpha:1];
        }
        
        [userAvatarPreviewImageView setImage:image];
        [cell.contentView addSubview:userAvatarPreviewImageView];
        
        UIImageView *enterArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 20, 13, 12, 18)];
        [enterArrowImageView setImage:[UIImage imageNamed:@"enterArrow"]];
        [cell.contentView addSubview:enterArrowImageView];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
        
    } else if(indexPath.section == 1){
        EditUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editUserInfoTableViewCellReuseIdetifier forIndexPath:indexPath];
        switch ([indexPath row]) {
                
                
            case 0:
            {
                [cell setText1:@"昵称"];
                if([UserInfoCacheManager getStoredUserID])
                {
                    [cell setValueString:[UserInfoCacheManager getStoredUsername]];
                } else {
                    [cell setValueString:@"游客"];
                }
                
            }
                break;
                
            case 1:
            {
                [cell setText1:@"姓名"];
                
                if([UserInfoCacheManager getStoredUserID])
                {
                    [cell setValueString:[UserInfoCacheManager getStoredUserRealName]];
                } else {
                    [cell setValueString:@"游客"];
                }
                
            }
                break;
            case 2:
            {
                [cell setText1:@"性别"];
                
                if([UserInfoCacheManager getStoredUserID])
                {
                    [cell setValueString:[UserInfoCacheManager getStoredUserGender]];
                } else {
                    [cell setValueString:@"--"];
                }
            }
                break;
            case 3:
            {
                [cell setText1:@"身高"];
                
                if([UserInfoCacheManager getStoredUserID])
                {
                    NSString *heightString = [NSString stringWithFormat:@"%ld 厘米",(long)[UserInfoCacheManager getStoredUserHeight]];
                    [cell setValueString:heightString];
                } else {
                    [cell setValueString:@"--"];
                }
            }
                break;
            case 4:
            {
                [cell setText1:@"体重"];
                
                if([UserInfoCacheManager getStoredUserID])
                {
                    NSString *heightString = [NSString stringWithFormat:@"%ld 公斤",(long)[UserInfoCacheManager getStoredUserWeight]];
                    [cell setValueString:heightString];
                } else {
                    [cell setValueString:@"--"];
                }
            }
                break;
            case 5:
            {
                [cell setText1:@"生日"];
                
                if([UserInfoCacheManager getStoredUserID])
                {
                    NSString *birthdayString = [TimeUtil NSDateToString:[UserInfoCacheManager getStoredUserBirthDay]];
                    
                    [cell setValueString:birthdayString];
                } else {
                    [cell setValueString:@"--"];
                }
            }
                break;
            case 6:
            {
                [cell setText1:@"所在地"];
                [cell setValueString:@""];
            }
                break;
            default:
                return 0;
                break;
        }
        return cell;
        
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editInfoTableViewCell"];
        [cell.textLabel setText:@"修改登录密码"];
        UIImageView *enterArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 22, 13, 12, 18)];
        [enterArrowImageView setImage:[UIImage imageNamed:@"enterArrow"]];
        [cell.contentView addSubview:enterArrowImageView];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    if(indexPath.section == 0)
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
        NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
        NSData* imageData = [preferences objectForKey:@"userAvatar"];
        if (imageData) {
        [pickerChooseVC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
            [preferences setObject:nil forKey:@"userAvatar"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_INFO_UPDATED" object:nil];
            [pickerChooseVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        }
        
        [pickerChooseVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [pickerChooseVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:pickerChooseVC animated:YES completion:nil];
    } else if(indexPath.section == 1)
    {
        
        
        switch ([indexPath row]) {
                
            case 0:
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
                    
                    [UserInfoCacheManager saveStoredUsername:newUsername];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_INFO_UPDATED" object:nil];
                    
                    [editInfoAlertController dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [self presentViewController:editInfoAlertController animated:YES completion:nil];
            }
                break;
                
            case 1:
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
                    [UserInfoCacheManager saveStoredUserRealName:newRealname];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_INFO_UPDATED" object:nil];
                    
                    [editInfoAlertController dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:editInfoAlertController animated:YES completion:nil];
            }
                break;
            case 2:
            {
                NSArray *genders = @[@"男",@"女"];
                [ActionSheetStringPicker showPickerWithTitle:@"请选择性别" rows:genders initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    
                    [UserInfoCacheManager saveStoredUserGender:[genders objectAtIndex:selectedIndex]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_INFO_UPDATED" object:nil];
                     
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self.view];
            }
                
                break;
            case 3:
            {
                NSMutableArray *height = [[NSMutableArray alloc] initWithCapacity:10];
                for (int x = 30;x<256;x++)
                {
                    [height addObject:[NSString stringWithFormat:@"%d", x]];
                }
                [ActionSheetStringPicker showPickerWithTitle:@"请选择身高" rows:height initialSelection:141 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    [UserInfoCacheManager saveStoredUserHeight:(30+selectedIndex)];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_INFO_UPDATED" object:nil];
                    
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self.view];
            }
                break;
            case 4:
            {
                NSMutableArray *weight = [[NSMutableArray alloc] initWithCapacity:10];
                for (int x = 5;x<250;x++)
                {
                    [weight addObject:[NSString stringWithFormat:@"%d", x]];
                }
                [ActionSheetStringPicker showPickerWithTitle:@"请选择体重" rows:weight initialSelection:60 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    [UserInfoCacheManager saveStoredUserWeight:(5+selectedIndex)];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_INFO_UPDATED" object:nil];
                    
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self.view];
            }
                break;
            case 5:
            {
                
                [ActionSheetDatePicker showPickerWithTitle:@"请选择生日" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] minimumDate:[NSDate dateWithTimeIntervalSince1970:0] maximumDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                    [UserInfoCacheManager saveStoredUserBirthDay:(NSDate*)selectedDate];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_INFO_UPDATED" object:nil];
                    
                } cancelBlock:^(ActionSheetDatePicker *picker) {
                    
                } origin:self.view];
            }
                break;
            default:

                break;
        }
    } else
    {
        UIAlertController *editInfoAlertController;
        editInfoAlertController = [UIAlertController alertControllerWithTitle:@"修改密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [editInfoAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"请输入旧密码";
//            textField.secureTextEntry = true;
//        }];
        [editInfoAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入新密码";
            textField.secureTextEntry = true;
        }];
        [editInfoAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请再输入一次新密码";
            textField.secureTextEntry = true;
        }];
        [editInfoAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [editInfoAlertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [editInfoAlertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [editInfoAlertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:editInfoAlertController animated:YES completion:nil];
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"picked key is %@",info);
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:UIImagePNGRepresentation(pickedImage) forKey:@"userAvatar"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_INFO_UPDATED" object:nil];
}

-(void)setUserInfo
{
    [self.detailInfoTableView reloadData];
}

@end
