//
//  XSDChartModel.h
//  XSDRingChart
//
//  Created by XSDCoder on 2017/7/10.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

#define randomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0]
#define kWidthScale (self.frame.size.width / [UIScreen mainScreen].bounds.size.width)

@interface XSDChartModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) NSNumber *number;

+ (instancetype)modelWithNumber:(NSNumber *)number color:(UIColor *)color name:(NSString *)name;

@end
