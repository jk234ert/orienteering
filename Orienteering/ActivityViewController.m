//
//  ActivityViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/7.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "ActivityViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

#import "TimeUtil.h"
#import "FBShimmeringView.h"
#import "ResultViewViewController.h"
#import "TempResultViewController.h"


#define SCOREBOARD_FALLING_DISTANCE 55
#define SCOREBOARD_HEIGHT 229
#define SCOREBOARD_FALLING_TIME_PERIOD 0.35

typedef NS_ENUM(NSInteger, ActivityProcessStatus) {
    ActivityProcessStatusNotCheckin = 0,
    ActivityProcessStatusCheckedNotStart,
    ActivityProcessStatusProcessing,
    ActivityProcessStatusFinished
};

@interface ActivityViewController ()


@property (weak, nonatomic) IBOutlet UIButton *navTitleButton;

@property (weak, nonatomic) IBOutlet UIView *scoreBoardView;
@property (weak, nonatomic) IBOutlet UILabel *scoreBoardTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreboardTotalTimeSign;

@property (weak, nonatomic) IBOutlet UILabel *nextDotSign;
@property (weak, nonatomic) IBOutlet UILabel *nextDotNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *remainDotSign;
@property (weak, nonatomic) IBOutlet UILabel *remainDotCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentDotTimeCostLabel;

@property (nonatomic) ActivityProcessStatus activityProgressStatus;
@property (nonatomic,retain) NSTimer *timeCountingTimer;
@property (nonatomic,retain) NSDate *activityStartDate;
@property (nonatomic,retain) NSMutableArray *scoreArray;
@property (nonatomic) NSInteger finalScore;
@property (nonatomic) NSInteger finishedDotNumber;


@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UILabel *buttonIndicatorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downIndicator1;
@property (weak, nonatomic) IBOutlet UIImageView *downIndicator2;

@property (nonatomic,retain) NSArray *testDotNumberArray;
@property (retain, nonatomic) NSMutableDictionary *dotInfoDict;
@property (weak, nonatomic) IBOutlet UIImageView *compassImageView;

@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@property(nonatomic)CGRect originScanButtonFrame;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *mapPanGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIImageView *mapView;

@property(nonatomic)CGPoint mapOriginCenterPoint;
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scoreArray = [[NSMutableArray alloc] initWithCapacity:10];
    _dotInfoDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    _finishedDotNumber = 0;
    
    [_mapView setImage:[UIImage imageNamed:[[ActivityManager sharedInstance] getCorrespondingMapName:_currentActivity]]];
    
    //[_navTitleButton setTitle:@"请签到" forState:UIControlStateNormal];
    _activityProgressStatus = ActivityProcessStatusNotCheckin;
    /*
    _titleButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(235,32,20,15.6)];
    [_titleButton setStyle:kFRDLivelyButtonStyleCaretUp animated:NO];
    
    [_titleButton setOptions:@{
                               kFRDLivelyButtonHighlightedColor: [UIColor whiteColor],
                               kFRDLivelyButtonColor: [UIColor whiteColor]
                               }];
    [_titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_titleButton];
     */
    
    _exitButton.layer.cornerRadius = _exitButton.frame.size.width / 2.0;
    _exitButton.backgroundColor = [UIColor colorWithRed:0 green:219.0/255.0 blue:128.0/255.0 alpha:1];
    [_exitButton addTarget:self action:@selector(highlightExitButton) forControlEvents:UIControlEventTouchDown];
    [_exitButton addTarget:self action:@selector(exitButtonUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_exitButton addTarget:self action:@selector(exitButtonUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    _scanButton.layer.cornerRadius = _scanButton.frame.size.width / 2.0;
    _scanButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [_scanButton addTarget:self action:@selector(highlightScanButton) forControlEvents:UIControlEventTouchDown];
    [_scanButton addTarget:self action:@selector(scanButtonUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_scanButton addTarget:self action:@selector(scanButtonUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    [_scanButton setTitle:@"签到" forState:UIControlStateNormal];
    
    [_nextDotNumberLabel setText:@"--"];
    [_remainDotCountLabel setText:@"--"];
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:_buttonIndicatorLabel.frame];
    [_scoreBoardView addSubview:shimmeringView];
    
    //CGRect oldframe = _buttonIndicatorLabel.frame;
    CGRect oldFrame = shimmeringView.frame;
    
    shimmeringView.contentView = _buttonIndicatorLabel;
    shimmeringView.frame = CGRectMake(oldFrame.origin.x-20, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
    
    // Start shimmering.
    shimmeringView.shimmering = YES;
    
    _originScanButtonFrame = _scanButton.frame;
    
    _mapOriginCenterPoint = _mapView.center;

    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    // 判斷是否 iOS 8
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization]; // 永久授权
    }
    
    [locationManager startUpdatingHeading];
    
    
    
}

-(void)highlightExitButton
{
    _exitButton.backgroundColor = [UIColor whiteColor];
}

-(void)exitButtonUpOutside
{
    _exitButton.backgroundColor = [UIColor colorWithRed:0 green:219.0/255.0 blue:128.0/255.0 alpha:1];
}

-(void)exitButtonUpInside
{
    _exitButton.backgroundColor = [UIColor colorWithRed:0 green:219.0/255.0 blue:128.0/255.0 alpha:1];
    
    switch (_activityProgressStatus) {
        case ActivityProcessStatusNotCheckin:
            [[self navigationController] popViewControllerAnimated:YES];
            break;
            
        case ActivityProcessStatusCheckedNotStart:
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"比赛将要开始，确定退出吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [[self navigationController] popViewControllerAnimated:YES];
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
        case ActivityProcessStatusProcessing:
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定放弃本次比赛吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [[self navigationController] popViewControllerAnimated:YES];
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
    
    
    //[[self navigationController] popViewControllerAnimated:YES];
}

-(void)highlightScanButton
{
    _scanButton.backgroundColor = [UIColor whiteColor];
}

-(void)scanButtonUpOutside
{
    _scanButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:0 alpha:1];
}

-(void)scanButtonUpInside
{
    _scanButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:0 alpha:1];

    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            reader                        = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"取消"];
            reader.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        reader.delegate = self;
        
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:reader animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"此设备不支持二维码扫描" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startLocationHeadingEvents];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.locationManager) {
        [self.locationManager stopUpdatingHeading];
        [self.locationManager stopUpdatingLocation];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startLocationHeadingEvents {
    if (!self.locationManager) {
        CLLocationManager* theManager = [[CLLocationManager alloc] init];
        
        // Retain the object in a property.
        self.locationManager = theManager;
        self.locationManager.delegate = self;
    }
    
    // Start location services to get the true heading.
    self.locationManager.distanceFilter = 1;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager startUpdatingLocation];
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization]; // 永久授权
    }
    
    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        self.locationManager.headingFilter = 5;
        [self.locationManager startUpdatingHeading];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.headingAccuracy < 0)
        return;
    //self.compassImageView.transform = CGAffineTransformMakeRotation(CGAffineTransformIdentity);
    self.compassImageView.transform = CGAffineTransformMakeRotation((360.00-[newHeading magneticHeading]) * M_PI / 180.00);
    NSLog(@"heading is %f",[newHeading magneticHeading]);

}


- (IBAction)backButtonClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)scanButtonClicked:(id)sender {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            reader                        = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"取消"];
            reader.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        reader.delegate = self;
        
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:reader animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        BOOL isAvailableResult = NO;
        
        switch (_activityProgressStatus) {
            case ActivityProcessStatusNotCheckin:
                if([result isEqualToString:@"checked!"])
                {
                    //[_navTitleButton setTitle:@"扫描起点开始！" forState:UIControlStateNormal];
                    
                    [_buttonIndicatorLabel setText:@"点击扫码按钮出发 >>>"];
                    [_scanButton setTitle:@"出发" forState:UIControlStateNormal];
                    _activityProgressStatus = ActivityProcessStatusCheckedNotStart;
                    [self loadDotInfoArray];
                    [_remainDotCountLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)[_testDotNumberArray count]]];
                    [_nextDotNumberLabel setText:[[_testDotNumberArray objectAtIndex:0] stringValue]];
                    isAvailableResult = YES;
                }
                break;
            case ActivityProcessStatusCheckedNotStart:
                if([result isEqualToString:@"startpoint"])
                {
                    //[_navTitleButton setTitle:@"越野开始！" forState:UIControlStateNormal];
                    _activityProgressStatus = ActivityProcessStatusProcessing;
                    isAvailableResult = YES;
                    //_activityStartDate = [NSDate date];
                    //[_scoreArray addObject:_activityStartDate];
                    [_scanButton setTitle:@"扫码" forState:UIControlStateNormal];
                    [_buttonIndicatorLabel setText:@"点击扫码按钮扫描点标二维码 >>>"];
                    
                    NSString *nextDotLabelString = [NSString stringWithFormat:@"%d-%@",(int)(_finishedDotNumber+1),[_testDotNumberArray objectAtIndex:(_finishedDotNumber)]];
                    [_nextDotNumberLabel setText:nextDotLabelString];
                    
                    _timeCountingTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(timeCountingMethod:) userInfo:nil repeats:YES];
                }
                break;
            case ActivityProcessStatusProcessing:
                if(![result isEqualToString:@"endpoint"])
                {
                    NSLog(@"available string is %@",[[_dotInfoDict objectForKey:[_testDotNumberArray objectAtIndex:_finishedDotNumber]] stringValue]);
                    if([result isEqualToString:[[_dotInfoDict objectForKey:[_testDotNumberArray objectAtIndex:_finishedDotNumber]] stringValue]]){
                        NSDate *newDate = [NSDate date];
                        [_scoreArray addObject:newDate];
                        //[_navTitleButton setTitle:result forState:UIControlStateNormal];
                        isAvailableResult = YES;
                        
                        _finishedDotNumber++;
                        
                        if((_finishedDotNumber) == [_dotInfoDict count])
                        {
                            [_nextDotNumberLabel setText:@"--"];
                            
                            [_timeCountingTimer invalidate];
                            _activityProgressStatus = ActivityProcessStatusFinished;
                            
                            [_buttonIndicatorLabel setText:@"点击提交按钮提交成绩 >>>"];
                            [_scanButton setTitle:@"提交" forState:UIControlStateNormal];
                            [_scanButton removeTarget:self action:@selector(scanButtonUpInside) forControlEvents:UIControlEventTouchUpInside];
                        } else {
                            NSString *nextDotLabelString = [NSString stringWithFormat:@"%d-%@",(int)(_finishedDotNumber+1),[_testDotNumberArray objectAtIndex:(_finishedDotNumber)]];
                            [_nextDotNumberLabel setText:nextDotLabelString];
                        }
                        [_remainDotCountLabel setText:[NSString stringWithFormat:@"%lu",([_testDotNumberArray count]-_finishedDotNumber)]];
                    }
                    
                } else {
                    NSDate *newDate = [NSDate date];
                    [_scoreArray addObject:newDate];
                    //[_navTitleButton setTitle:@"比赛结束" forState:UIControlStateNormal];
                    _activityProgressStatus = ActivityProcessStatusFinished;
                    [_timeCountingTimer invalidate];
                    [_remainDotCountLabel setText:[_testDotNumberArray objectAtIndex:_finishedDotNumber]];
                    [_nextDotNumberLabel setText:@"--"];
                    [_currentDotTimeCostLabel setText:@"--"];
                    isAvailableResult = YES;
                }
                
                break;
            case ActivityProcessStatusFinished:

                break;
                
            default:
                break;
        }

        if(!isAvailableResult)
        {
            UIAlertController *scanAlertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"无效二维码！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:scanAlertVC animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [scanAlertVC dismissViewControllerAnimated:YES completion:nil];
            });
            return;
        } else {
            UIAlertController *scanAlertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"扫码成功！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:scanAlertVC animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [scanAlertVC dismissViewControllerAnimated:YES completion:nil];
            });
            return;
        }
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)testMatchBeginButtonClicked:(id)sender {
    
    
}

- (IBAction)titleButtonClicked:(id)sender {
    /*
    if(_titleButton.buttonStyle == kFRDLivelyButtonStyleCaretUp){
        [_titleButton setStyle:kFRDLivelyButtonStyleCaretDown animated:YES];
    } else {
        [_titleButton setStyle:kFRDLivelyButtonStyleCaretUp animated:YES];
    }
    [self toggleScoreBoard];
     */
}

-(void)toggleScoreBoard
{
    if(_scoreBoardView.alpha < 1)
    {
        [self.view bringSubviewToFront:_scoreBoardView];
        [UIView animateWithDuration:0.3 animations:^{
            _scoreBoardView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _scoreBoardView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view sendSubviewToBack:_scoreBoardView];
        }];
    }
}
- (IBAction)scoreboardIndicatorClicked:(id)sender {
    CGRect oldFrame = _scoreBoardView.frame;
    if(oldFrame.origin.y <= ([UIScreen mainScreen].bounds.size.height-oldFrame.size.height))
    {
        [self downScoreboardView];
    } else {
        [self upScoreboardView];
    }
    
}
- (IBAction)mapClicked:(id)sender {
    CGRect oldFrame = _scoreBoardView.frame;
    if(oldFrame.origin.y <= ([UIScreen mainScreen].bounds.size.height-oldFrame.size.height))
    {
        [self downScoreboardView];
    }
}
- (IBAction)swipeDownScoreboard:(id)sender {
    CGRect oldFrame = _scoreBoardView.frame;
    if(oldFrame.origin.y <= ([UIScreen mainScreen].bounds.size.height-oldFrame.size.height))
    {
        [self downScoreboardView];
    }
}
- (IBAction)swipeUpScoreboard:(id)sender {
    CGRect oldFrame = _scoreBoardView.frame;
    if(oldFrame.origin.y > ([UIScreen mainScreen].bounds.size.height-oldFrame.size.height))
    {
        [self upScoreboardView];
    }
}

-(void)downScoreboardView
{
    /*--------------------------------------  修改"总用时"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _scoreboardTotalTimeSign.superview.constraints) {
        if (constraint.firstItem == _scoreboardTotalTimeSign && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 6;
        }
    
    /*--------------------------------------  修改"总用时"高度  ---------------------------------------*/
    }
    for (NSLayoutConstraint *constraint in _scoreboardTotalTimeSign.constraints) {
        if (constraint.firstItem == _scoreboardTotalTimeSign && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 18;
        }
    }
    
    
    /*--------------------------------------  修改"总时间"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _scoreBoardTotalTimeLabel.superview.constraints) {
        if (constraint.firstItem == _scoreBoardTotalTimeLabel && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 30;
        }
    }
    
    /*--------------------------------------  修改"总时间"高度  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _scoreBoardTotalTimeLabel.constraints) {
        if (constraint.firstItem == _scoreBoardTotalTimeLabel && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 18;
        }
    }
    
    /*--------------------------------------  修改"下一点标"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _nextDotSign.superview.constraints) {
        if (constraint.firstItem == _nextDotSign && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 6;
        }
    }
    
    /*--------------------------------------  修改"下一点标"高度  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _nextDotSign.constraints) {
        if (constraint.firstItem == _nextDotSign && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 18;
        }
    }
    
    /*--------------------------------------  修改"下一点标数字"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _nextDotNumberLabel.superview.constraints) {
        if (constraint.firstItem == _nextDotNumberLabel && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 6;
        }
    }
    
    /*--------------------------------------  修改"下一点标数字"高度  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _nextDotNumberLabel.constraints) {
        if (constraint.firstItem == _nextDotNumberLabel && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 18;
        }
    }
    
    /*--------------------------------------  修改"剩余点标"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _remainDotSign.superview.constraints) {
        if (constraint.firstItem == _remainDotSign && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 6;
        }
    }
    
    /*--------------------------------------  修改"剩余点标"高度  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _remainDotSign.constraints) {
        if (constraint.firstItem == _remainDotSign && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 18;
        }
    }
    
    /*--------------------------------------  修改"剩余点标数字"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _remainDotCountLabel.superview.constraints) {
        if (constraint.firstItem == _remainDotCountLabel && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 6;
        }
    }
    
    /*--------------------------------------  修改"剩余点标数字"高度  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _remainDotCountLabel.constraints) {
        if (constraint.firstItem == _remainDotCountLabel && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 18;
        }
    }
    
    
    /*--------------------------------------  修改"计分板"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _scoreBoardView.superview.constraints) {
        NSLog(@"constraint is %@",constraint);
        if (constraint.secondItem == _scoreBoardView && constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = (SCOREBOARD_FALLING_DISTANCE - SCOREBOARD_HEIGHT);
        }
    }
    
    /*--------------------------------------  修改"扫码"按钮位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _scanButton.superview.constraints) {
        NSLog(@"constraint is %@",constraint);
        if (constraint.secondItem == _scanButton && constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant += 36;
        }
    }
    
    
    [UIView animateWithDuration:SCOREBOARD_FALLING_TIME_PERIOD animations:^{
        _downIndicator1.alpha = 0;
        _downIndicator2.alpha = 0;
        
        [self.view layoutIfNeeded];
        [_scoreBoardView layoutIfNeeded];
        [_scoreboardTotalTimeSign setFont:[UIFont boldSystemFontOfSize:18]];
        [_scoreBoardTotalTimeLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        [_nextDotSign setFont:[UIFont systemFontOfSize:18]];
        [_nextDotNumberLabel setFont:[UIFont systemFontOfSize:18]];
        
        [_remainDotSign setFont:[UIFont systemFontOfSize:18]];
        [_remainDotCountLabel setFont:[UIFont systemFontOfSize:18]];
        
    } completion:^(BOOL finished) {

    }];

}

-(void)upScoreboardView
{
    
    for (NSLayoutConstraint *constraint in _scoreboardTotalTimeSign.superview.constraints) {
        if (constraint.firstItem == _scoreboardTotalTimeSign && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 16;
        }
        
    }
    for (NSLayoutConstraint *constraint in _scoreboardTotalTimeSign.constraints) {
        if (constraint.firstItem == _scoreboardTotalTimeSign && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 23;
        }
    }
    
    
    
    for (NSLayoutConstraint *constraint in _scoreBoardTotalTimeLabel.superview.constraints) {
        if (constraint.firstItem == _scoreBoardTotalTimeLabel && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 55;
        }
    }
    for (NSLayoutConstraint *constraint in _scoreBoardTotalTimeLabel.constraints) {
        if (constraint.firstItem == _scoreBoardTotalTimeLabel && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 23;
        }
    }
    
    /*--------------------------------------  修改"下一点标"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _nextDotSign.superview.constraints) {
        if (constraint.firstItem == _nextDotSign && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 102;
        }
    }
    
    /*--------------------------------------  修改"下一点标"高度  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _nextDotSign.constraints) {
        if (constraint.firstItem == _nextDotSign && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 13;
        }
    }
    
    /*--------------------------------------  修改"下一点标数字"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _nextDotNumberLabel.superview.constraints) {
        if (constraint.firstItem == _nextDotNumberLabel && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 2;
        }
    }
    
    /*--------------------------------------  修改"下一点标数字"高度  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _nextDotNumberLabel.constraints) {
        if (constraint.firstItem == _nextDotNumberLabel && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 13;
        }
    }
    
    /*--------------------------------------  修改"剩余点标"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _remainDotSign.superview.constraints) {
        if (constraint.firstItem == _remainDotSign && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 102;
        }
    }
    
    /*--------------------------------------  修改"剩余点标"高度  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _remainDotSign.constraints) {
        if (constraint.firstItem == _remainDotSign && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 13;
        }
    }
    
    /*--------------------------------------  修改"剩余点标数字"位置  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _remainDotCountLabel.superview.constraints) {
        if (constraint.firstItem == _remainDotCountLabel && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 2;
        }
    }
    
    /*--------------------------------------  修改"剩余点标数字"高度  ---------------------------------------*/
    for (NSLayoutConstraint *constraint in _remainDotCountLabel.constraints) {
        if (constraint.firstItem == _remainDotCountLabel && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 13;
        }
    }

    
    
    
    for (NSLayoutConstraint *constraint in _scoreBoardView.superview.constraints) {
        NSLog(@"constraint is %@",constraint);
        if (constraint.secondItem == _scoreBoardView && constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = 0;
        }
    }
    
    for (NSLayoutConstraint *constraint in _scanButton.superview.constraints) {
        NSLog(@"constraint is %@",constraint);
        if (constraint.secondItem == _scanButton && constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant -= 36;
        }
    }
    
    [UIView animateWithDuration:SCOREBOARD_FALLING_TIME_PERIOD animations:^{
        _downIndicator1.alpha = 1;
        _downIndicator2.alpha = 1;
        

        [self.view layoutIfNeeded];
        [_scoreBoardView layoutIfNeeded];
        [_scoreboardTotalTimeSign setFont:[UIFont boldSystemFontOfSize:23]];
        [_scoreBoardTotalTimeLabel setFont:[UIFont boldSystemFontOfSize:23]];
        
        [_nextDotSign setFont:[UIFont boldSystemFontOfSize:13]];
        [_nextDotNumberLabel setFont:[UIFont systemFontOfSize:13]];
        
        [_remainDotSign setFont:[UIFont boldSystemFontOfSize:13]];
        [_remainDotCountLabel setFont:[UIFont systemFontOfSize:13]];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)loadDotInfoArray
{
    //_testDotNumberArray = @[@"3",@"8",@"11",@"22"];
    
    
    _testDotNumberArray = [[NSArray alloc] initWithArray:[[ActivityManager sharedInstance] getCorrespondingPathArray:_currentActivity]];
    
    NSArray *testDotQRCodeArray = [[NSArray alloc] initWithArray:_testDotNumberArray];
    for(int x=0;x<[_testDotNumberArray count];x++)
    {
        [_dotInfoDict setObject:[testDotQRCodeArray objectAtIndex:x] forKey:[_testDotNumberArray objectAtIndex:x]];
    }
}

-(void)timeCountingMethod:(NSTimer *)timer
{
    
    
    NSString *totalTimeCostString;
    if([_scoreArray count] == 0)
    {
        NSDate *newDate = [NSDate date];
        [_scoreArray addObject:newDate];
        totalTimeCostString = @"00:00:00";
        _finishedDotNumber = 0;
        //[_remainDotCountLabel setText:[_testDotNumberArray objectAtIndex:_finishedDotNumber]];
        
        [_currentDotTimeCostLabel setText:@"00:00:00"];
        
    } else {
        NSDate *newDate = [NSDate date];
        NSDate *startDate = [_scoreArray objectAtIndex:0];
        
        totalTimeCostString = [TimeUtil getTimeStringBetweenFirstDate:startDate andSecondDate:newDate];
        
        NSString *currentDotTimeCostString = [TimeUtil getTimeStringBetweenFirstDate:[_scoreArray lastObject] andSecondDate:newDate];
        [_currentDotTimeCostLabel setText:currentDotTimeCostString];
    }

    [_scoreBoardTotalTimeLabel setText:totalTimeCostString];
}

- (IBAction)scoreViewButtonClicked:(id)sender {
    //ResultViewViewController *aVC = [[ResultViewViewController alloc] init];
    
    if(_activityProgressStatus != ActivityProcessStatusProcessing)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"错误" message:@"比赛还未开始，请先签到" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    TempResultViewController *aVC = [[TempResultViewController alloc] init];
    [aVC setDotNumberArray:_testDotNumberArray];
    
    [aVC setScoreArray:_scoreArray];
    [aVC setFinishedDotNumber:_finishedDotNumber];
    
    if(_activityProgressStatus != ActivityProcessStatusProcessing)
    {
        NSString *detailString = [TimeUtil getTimeStringBetweenFirstDate:[_scoreArray objectAtIndex:0] andSecondDate:[_scoreArray lastObject]];
        [aVC setTotalTimeString:detailString];
    } else {
        [aVC setTotalTimeString:[_scoreBoardTotalTimeLabel text]];
    };
    
    
    [[self navigationController] pushViewController:aVC animated:YES];
}

- (IBAction)mapPinchDetected:(id)sender {
    UIView *view = _pinchGestureRecognizer.view;
    if (_pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || _pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"scale is %f",_pinchGestureRecognizer.scale );
        if(_pinchGestureRecognizer.scale < 1)
        {

            view.transform = CGAffineTransformScale(view.transform,  _pinchGestureRecognizer.scale,  _pinchGestureRecognizer.scale);
            _pinchGestureRecognizer.scale = 1;
        } else {
            view.transform = CGAffineTransformScale(view.transform, _pinchGestureRecognizer.scale, _pinchGestureRecognizer.scale);
            _pinchGestureRecognizer.scale = 1;
        }
        
        
    } else if(_pinchGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if((view.transform.a - 1.0f) < 0.f)
        {

            [UIView animateWithDuration:0.2 animations:^{
                view.transform = CGAffineTransformIdentity;
                [view setCenter:self.mapOriginCenterPoint];
            }];
        }
        NSLog(@"scale is %f,%f,%f,%f,%f,%f",view.transform.a,view.transform.b,view.transform.c,view.transform.d,view.transform.tx,view.transform.ty);
    }
}

- (IBAction)mapPanGestureDetected:(id)sender {
    UIView *view = _mapPanGestureRecognizer.view;
    if (_mapPanGestureRecognizer.state == UIGestureRecognizerStateBegan || _mapPanGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [_mapPanGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [_mapPanGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}


@end
