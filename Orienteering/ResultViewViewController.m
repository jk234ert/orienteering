//
//  ResultViewViewController.m
//  Orienteering
//
//  Created by macmini on 15/4/16.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "ResultViewViewController.h"
#import "TWRChart.h"


@interface ResultViewViewController ()
@property (weak, nonatomic) IBOutlet XYPieChart *testPirChart;
@property(nonatomic, strong) NSArray        *sliceColors;
@end

@implementation ResultViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scoreArray = @[@50,@50,@60,@70];
    _dotArray = @[@"3",@"8",@"11",@"22"];
    
    [self.testPirChart setDataSource:self];
    [self.testPirChart setStartPieAngle:M_PI_2];
    [self.testPirChart setAnimationSpeed:1.0];
    //[self.testPirChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.testPirChart setLabelRadius:100];
    [self.testPirChart setShowPercentage:NO];
    [self.testPirChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.testPirChart setPieCenter:CGPointMake(200, 240)];
    [self.testPirChart setUserInteractionEnabled:YES];
    [self.testPirChart setLabelShadowColor:[UIColor blackColor]];

    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    
    // Chart View
    TWRChartView *_chartView = [[TWRChartView alloc] initWithFrame:CGRectMake(0, 410, 300, 200)];
    
    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:@"file" ofType:@"js"];
    [_chartView setChartJsFilePath:jsFilePath];
    
    TWRCircularChart *chart = [[TWRCircularChart alloc] initWithValues:_scoreArray colors:self.sliceColors type:TWRCircularChartTypePie animated:YES];
    
    TWRDataSet *dataset = [[TWRDataSet alloc] initWithDataPoints:_scoreArray fillColor:[UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:0 alpha:1] strokeColor:[UIColor greenColor]];
    TWRBarChart *linechar = [[TWRBarChart alloc] initWithLabels:_dotArray dataSets:@[dataset] animated:YES];
    
    // Add the chart view to the controller's view
    [self.view addSubview:_chartView];
    
    //[_chartView loadCircularChart:chart];
    [_chartView loadBarChart:linechar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTestPirChart:nil];

    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.testPirChart reloadData];
}

-(void)setDotArray:(NSArray *)dotArray
{

    
    //self.dotArray = @[@"3",@"8",@"11",@"22"];
}

-(void)setScoreArray:(NSArray *)scoreArray
{
    //self.scoreArray = @[@40,@50,@60,@70];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.dotArray.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.scoreArray objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    return [_dotArray objectAtIndex:index];
}

@end
