//
//  XSDRingChart.h
//  XSDRingChart
//
//  Created by XSDCoder on 2017/7/10.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSDChartModel.h"

@interface XSDRingChart : UIView

/** 数据数组 */
@property (nonatomic, strong) NSArray<XSDChartModel *> *dataArray;

/** 环型宽度 */
@property (nonatomic, assign) CGFloat ringWidth;

- (void)show;

@end
