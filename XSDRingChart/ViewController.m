//
//  ViewController.m
//  XSDRingChart
//
//  Created by XSDCoder on 2017/7/10.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import "ViewController.h"
#import "XSDRingChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *data = [NSMutableArray array];
    [data addObject:[XSDChartModel modelWithNumber:@(123) color:[UIColor redColor] name:@"苹果"]];
    [data addObject:[XSDChartModel modelWithNumber:@(345) color:[UIColor magentaColor] name:@"草莓"]];
    [data addObject:[XSDChartModel modelWithNumber:@(267) color:[UIColor greenColor] name:@"西瓜"]];
    [data addObject:[XSDChartModel modelWithNumber:@(731) color:[UIColor orangeColor] name:@"橙子"]];
    [data addObject:[XSDChartModel modelWithNumber:@(246) color:[UIColor purpleColor] name:@"樱桃"]];
    [data addObject:[XSDChartModel modelWithNumber:@(95) color:[UIColor yellowColor] name:@"香蕉"]];
    
    XSDRingChart *ringChartView = [[XSDRingChart alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width)];
    ringChartView.dataArray = data;
    [self.view addSubview:ringChartView];
}

@end
