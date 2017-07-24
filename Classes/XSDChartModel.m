//
//  XSDChartModel.m
//  XSDRingChart
//
//  Created by XSDCoder on 2017/7/10.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import "XSDChartModel.h"

@implementation XSDChartModel

+ (instancetype)modelWithNumber:(NSNumber *)number color:(UIColor *)color name:(NSString *)name {
    XSDChartModel *model = [self new];
    model.name = name;
    model.color = color;
    model.number = number;
    return model;
}

- (UIColor *)color {
    if (!_color) {
        _color = randomColor;
    }
    return _color;
}

@end
