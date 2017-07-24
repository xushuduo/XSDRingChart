//
//  XSDRingChart.m
//  XSDRingChart
//
//  Created by XSDCoder on 2017/7/10.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import "XSDRingChart.h"

@interface XSDRingChart ()

/** 数值和 */
@property (nonatomic, assign) CGFloat totol;

@property (nonatomic, strong) NSMutableArray *angelArray;

@property (nonatomic, assign) CGFloat itemsSpace;

@end

@implementation XSDRingChart

/** 环形半径 */
static const CGFloat defaultRedius = 75.0;

- (NSMutableArray *)angelArray {
    if (!_angelArray) {
        _angelArray = [NSMutableArray array];
    }
    return _angelArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _ringWidth = 20.0;
    }
    return self;
}

- (void)setDataArray:(NSArray<XSDChartModel *> *)dataArray {
    _dataArray = dataArray;
    if (!dataArray || dataArray.count == 0) return;
    _totol = 0;
    _itemsSpace = (M_PI * 2.0 * 10 / 360) / dataArray.count;
    for (XSDChartModel *model in dataArray) {
        _totol += model.number.doubleValue;
    }
    [self show];
}

- (void)show {
    self.layer.sublayers = @[];
    [self.angelArray removeAllObjects];
    CGFloat lastBegin = -M_PI / 2;
    NSInteger i = 0;
    
    for (XSDChartModel *model in _dataArray) {
        CGFloat cuttentpace = model.number.doubleValue / _totol * (M_PI * 2 - _itemsSpace * _dataArray.count);
        CGFloat endAngle = lastBegin + cuttentpace;
        [self.angelArray addObject:@{@"startAngle":@(lastBegin), @"endAngle":@(endAngle)}];
        [self createShapeLayerWithStrokeColor:model.color radius:defaultRedius startAngle:lastBegin endAngle:endAngle];
        lastBegin += (cuttentpace + _itemsSpace);
        i++;
    }
    
    NSNumber *firstStartAngle = self.angelArray.firstObject[@"startAngle"];
    NSNumber *firstEndAngle = self.angelArray.firstObject[@"endAngle"];
    
    [self showDetailWithIndex:0 startAngle:firstStartAngle.doubleValue endAngle:firstEndAngle.doubleValue];
}

- (void)showDetailWithIndex:(NSInteger)index startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    // 移除多余的Layer
    if (self.layer.sublayers.count > self.dataArray.count) {
        NSMutableArray *temp = [self.layer.sublayers mutableCopy];
        [temp removeObjectsInRange:NSMakeRange(self.dataArray.count, self.layer.sublayers.count - self.dataArray.count)];
        self.layer.sublayers = [temp copy];
    }
    XSDChartModel *model = _dataArray[index];
    [self createShapeLayerWithStrokeColor:model.color radius:(defaultRedius + 5) startAngle:startAngle endAngle:endAngle];
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGFloat currentSpace = model.number.doubleValue / _totol * (M_PI * 2 - _itemsSpace * _dataArray.count);
    CGFloat midSpace = startAngle + currentSpace / 2 + M_PI / 2;
    CGFloat longLen = defaultRedius + 30 * kWidthScale;
    CGPoint begin = CGPointMake(self.center.x + sin(midSpace) * defaultRedius, self.center.y - cos(midSpace) * defaultRedius);
    CGPoint endx = CGPointMake(self.center.x + sin(midSpace) * longLen, self.center.y - cos(midSpace) * longLen);
    [self drawLineWithContext:contex andStarPoint:begin andEndPoint:endx andIsDottedLine:NO andColor:model.color];
    CGPoint secondP = CGPointZero;
    NSString *str = [NSString stringWithFormat:@"%.02lf%%\n%@", model.number.doubleValue / _totol * 100, model.name];
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil];
    textRect.size.width += 2;
    if (midSpace < M_PI) {
        // 左边
        secondP = CGPointMake(endx.x + 20 * kWidthScale, endx.y);
        [self drawText:str andContext:contex rect:textRect atPoint:CGPointMake(secondP.x + textRect.size.width * 0.5 + 5, secondP.y) WithColor:model.color andFontSize:13.0f leftRight:YES];
    } else {
        // 右边
        secondP = CGPointMake(endx.x - 20 * kWidthScale, endx.y);
        [self drawText:str andContext:contex rect:textRect atPoint:CGPointMake(secondP.x - textRect.size.width * 0.5 - 5, secondP.y) WithColor:model.color andFontSize:13.0f leftRight:NO];
    }
    [self drawPointWithRedius:6.0f * kWidthScale andColor:model.color andPoint:secondP andContext:contex];
    [self drawLineWithContext:contex andStarPoint:endx andEndPoint:secondP andIsDottedLine:NO andColor:model.color];
}

- (void)createShapeLayerWithStrokeColor:(UIColor *)strokeColor radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = strokeColor.CGColor;
    [path addArcWithCenter:self.center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    layer.path = path.CGPath;
    layer.lineWidth = _ringWidth;
    [self.layer addSublayer:layer];
    [self layerAddAnimation:layer withKeyPath:@"strokeEnd"];
}

/**
 *  绘制线段
 *
 *  @param context  图形绘制上下文
 *  @param start    起点
 *  @param end      终点
 *  @param isDotted 是否是虚线
 *  @param color    线段颜色
 */
- (void)drawLineWithContext:(CGContextRef)context andStarPoint:(CGPoint)start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color {
    CAShapeLayer *lineShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef lineShapePath =  CGPathCreateMutable();
    [lineShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [lineShapeLayer setStrokeColor:color.CGColor];
    lineShapeLayer.lineWidth = 1.0f;
    if (isDotted) {
        NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:5], nil];
        [lineShapeLayer setLineDashPattern:dotteShapeArr];
    }
    CGPathMoveToPoint(lineShapePath, NULL, start.x, start.y);
    CGPathAddLineToPoint(lineShapePath, NULL, end.x, end.y);
    [lineShapeLayer setPath:lineShapePath];
    CGPathRelease(lineShapePath);
    [self.layer addSublayer:lineShapeLayer];
    [self layerAddAnimation:lineShapeLayer withKeyPath:@"strokeEnd"];
}

/**
 *  绘制圆
 *
 *  @param redius  半径
 *  @param color   线段颜色
 *  @param p       位置
 *  @param contex  图形绘制上下文
 */
- (void)drawPointWithRedius:(CGFloat)redius andColor:(UIColor *)color andPoint:(CGPoint)p andContext:(CGContextRef)contex {
    CAShapeLayer *solidLine = [CAShapeLayer layer];
    CGMutablePathRef solidPath = CGPathCreateMutable();
    solidLine.fillColor = color.CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(p.x - redius * 0.5, p.y - redius * 0.5, redius, redius));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.layer addSublayer:solidLine];
}

/**
 *  绘制文字
 *
 *  @param text    文字内容
 *  @param context 图形绘制上下文
 *  @param rect    绘制点
 *  @param color   绘制颜色
 */
- (void)drawText:(NSString *)text andContext:(CGContextRef)context rect:(CGRect)rect atPoint:(CGPoint)point WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize leftRight:(BOOL)leftRight {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = text;
    textLayer.fontSize = fontSize;
    textLayer.bounds = rect;
    textLayer.alignmentMode = leftRight ? kCAAlignmentLeft : kCAAlignmentRight;
    textLayer.foregroundColor = color.CGColor;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.wrapped = YES;
    textLayer.position = point;
    [self.layer addSublayer:textLayer];
}

/** 加动画 */
- (void)layerAddAnimation:(CALayer *)layer withKeyPath:(NSString *)keypath {
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:keypath];
    basic.fromValue = @(0);
    basic.toValue = @(1);
    basic.duration = 0.35;
    basic.fillMode = kCAFillModeForwards;
    [layer addAnimation:basic forKey:@"animation"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    if (point.y > self.center.y + defaultRedius + 60) {
        return;
    }
    
    // 求弧度
    CGFloat x = (point.x - self.center.x);
    CGFloat y = (point.y - self.center.y);
    CGFloat radian = atan2(y, x);
    // 当超过180度时，要加2π
    if (y < 0 && x < 0) {
        radian = radian + 2 * M_PI;
    }
    
    // 判断点击位置的角度在哪个Path范围上
    for (NSInteger i = 0; i < self.angelArray.count; i++) {
        NSDictionary *dict = self.angelArray[i];
        CGFloat startAngle = [dict[@"startAngle"] doubleValue];
        CGFloat endAngle = [dict[@"endAngle"] doubleValue];
        if (radian >= startAngle && radian < endAngle) {
            [self showDetailWithIndex:i startAngle:startAngle endAngle:endAngle];
            break;
        }
    }
}

@end
