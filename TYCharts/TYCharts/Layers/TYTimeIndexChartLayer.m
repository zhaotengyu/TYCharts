//
//  TYTimeIndexChartLayer.m
//  TYCharts
//
//  Created by ty on 2023/10/30.
//

#import "TYTimeIndexChartLayer.h"

@interface TYTimeIndexChartLayer ()

/// 分时线
@property (nonatomic, strong) CAShapeLayer *timeLineLayer;
/// 背景
@property (nonatomic, strong) CAShapeLayer *backgroundLineLayer;
/// 均价线
@property (nonatomic, strong) CAShapeLayer *avegPriceLayer;
/// 时间分割线
@property (nonatomic, strong) CAShapeLayer *timeSeparatorLayer;
/// 呼吸灯
@property (nonatomic, strong) CAShapeLayer *staticHeartLayer;
@property (nonatomic, strong) CAShapeLayer *dynamicHeartLayer;

@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation TYTimeIndexChartLayer

- (void)drawChart:(CALayer *)contentLayer
{
    [super drawChart:contentLayer];
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    
    // 绘制x轴分割线
    [self setupTimeSeparatorLayer:data atContentLayer:contentLayer];
    // 绘制分时线、均线
    [self setupTimeLineLayer:data atContentLayer:contentLayer];
}

/// 绘制x轴分割线
/// - Parameter contentLayer: <#contentLayer description#>
- (void)setupTimeSeparatorLayer:(TYChartDataSource *)data atContentLayer:(CALayer *)contentLayer
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat width = contentLayer.ty_width / 5;
    
    for (NSInteger index = 1; index <= 4; index++) {
        CGPoint startPoint = CGPointMake(index * width, 0);
        CGPoint endPoint = CGPointMake(index * width, contentLayer.ty_bottom);
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
    }
    
    self.timeSeparatorLayer.path = path.CGPath;
    self.timeSeparatorLayer.frame = contentLayer.bounds;
    [contentLayer addSublayer:self.timeSeparatorLayer];
}

/// 绘制分时线、均价线
/// - Parameter contentLayer: <#contentLayer description#>
- (void)setupTimeLineLayer:(TYChartDataSource *)data atContentLayer:(CALayer *)contentLayer
{
    CGFloat startIndex = data.xAxis.startIndex;
    CGFloat endIndex = data.xAxis.endIndex;
    
    NSArray<TYChartKLineDataModel *> *models = data.models;
    
    UIBezierPath *avgLinePath = [UIBezierPath bezierPath];
    UIBezierPath *timeLinePath = [UIBezierPath bezierPath];
    UIBezierPath *backgroundPath = [UIBezierPath bezierPath];
    [backgroundPath moveToPoint:CGPointMake(0, contentLayer.ty_height)];
    
    NSInteger count = 0;
    for (NSInteger index = startIndex; index < endIndex; index ++) {
        
        TYChartKLineDataModel *model = models[index];
        
        CGFloat pointX = model.pointX;
        // 均价坐标
        CGFloat avgY = [self transformCoordinateWithCurrentValue:model.avg_price.doubleValue bounds:contentLayer.bounds];
        CGPoint avgPoint = CGPointMake(pointX, avgY);
        
        // 分时坐标
        CGFloat timeY = [self transformCoordinateWithCurrentValue:model.current.doubleValue bounds:contentLayer.bounds];
        CGPoint timePoint = CGPointMake(pointX, timeY);
        
        if ((index == startIndex) ||
            (count == 26 && self.timeLineType == TYTimeLineIndexType5DMinute)) {
            count = 0;
            if (model.avg_price.doubleValue != CGFLOAT_MIN) {
                [avgLinePath moveToPoint:avgPoint];
            }
            
            if (model.current.doubleValue != CGFLOAT_MIN) {
                [timeLinePath moveToPoint:timePoint];
            }
        } else {
            if (model.avg_price.doubleValue != CGFLOAT_MIN) {
                [avgLinePath addLineToPoint:avgPoint];
            }
            
            if (model.current.doubleValue != CGFLOAT_MIN) {
                [timeLinePath addLineToPoint:timePoint];
            }
            
            self.endPoint = timePoint;
        }
        count ++;
        
        [backgroundPath addLineToPoint:timePoint];
    }

    // 均价线
    self.avegPriceLayer.path = avgLinePath.CGPath;
    self.avegPriceLayer.frame = contentLayer.bounds;
    [contentLayer addSublayer:self.avegPriceLayer];
    
    // 分时线
    self.timeLineLayer.path = timeLinePath.CGPath;
    self.timeLineLayer.frame = contentLayer.bounds;
    [contentLayer addSublayer:self.timeLineLayer];
    
    // 分时线背景色
    [backgroundPath addLineToPoint:CGPointMake(self.endPoint.x, contentLayer.ty_height)];
    self.backgroundLineLayer.path = backgroundPath.CGPath;
    self.backgroundLineLayer.frame = contentLayer.bounds;
    [contentLayer addSublayer:self.backgroundLineLayer];
    
    // 绘制呼吸灯
    if (self.timeLineType == TYTimeLineIndexTypeMinute) { // 分时图
        if (models.count < TYChartTimeLinePointCount) {
            [self setupBreathingLightLayer:contentLayer atPoint:self.endPoint];
        }
    }
}

/// 绘制呼吸灯
/// - Parameter contentLayer: <#contentLayer description#>
- (void)setupBreathingLightLayer:(CALayer *)contentLayer atPoint:(CGPoint)point
{
    self.staticHeartLayer.position = point;
    [contentLayer addSublayer:self.staticHeartLayer];
    
    self.dynamicHeartLayer.position = point;
    [contentLayer addSublayer:self.dynamicHeartLayer];
    [self.dynamicHeartLayer addAnimation:[self createBreathingLightAnimationWithTime:1.5] forKey:nil];
}

- (CAAnimationGroup *)createBreathingLightAnimationWithTime:(double)time
{
    // 缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @0;
    scaleAnimation.toValue = @2.5;
    scaleAnimation.duration = time;
    scaleAnimation.repeatCount = HUGE_VALF;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;

    // 透明度动画
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1.0;
    opacityAnimation.toValue = @0;
    opacityAnimation.duration = time;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    // 动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = time;
    group.autoreverses = NO;
    group.animations = @[scaleAnimation, opacityAnimation];
    group.repeatCount = HUGE_VALF;

    return group;
}

#pragma mark - getter/setter

- (CAShapeLayer *)timeLineLayer {
    if (!_timeLineLayer) {
        _timeLineLayer = [CAShapeLayer layer];
        _timeLineLayer.lineWidth = 1;
        _timeLineLayer.fillColor = [UIColor clearColor].CGColor;
        _timeLineLayer.strokeColor = [UIColor ty_colorWithHexString:@"#0083FF"].CGColor;
        _timeLineLayer.lineCap = kCALineCapRound;
        _timeLineLayer.lineJoin = kCALineJoinRound;
    }
    return _timeLineLayer;
}

- (CAShapeLayer *)backgroundLineLayer {
    if (!_backgroundLineLayer) {
        _backgroundLineLayer = [CAShapeLayer layer];
        _backgroundLineLayer.lineWidth = 1;
        _backgroundLineLayer.fillColor = [UIColor ty_colorWithHexString:@"#123B7EEE"].CGColor;
        _backgroundLineLayer.strokeColor = [UIColor ty_colorWithHexString:@"#123B7EEE"].CGColor;
        _backgroundLineLayer.lineCap = kCALineCapRound;
        _backgroundLineLayer.lineJoin = kCALineJoinRound;
    }
    return _backgroundLineLayer;
}

- (CAShapeLayer *)avegPriceLayer {
    if (!_avegPriceLayer) {
        _avegPriceLayer = [CAShapeLayer layer];
        _avegPriceLayer.lineWidth = 1;
        _avegPriceLayer.fillColor = [UIColor clearColor].CGColor;
        _avegPriceLayer.strokeColor = [UIColor ty_colorWithHexString:@"#FF9100"].CGColor;
        _avegPriceLayer.lineCap = kCALineCapRound;
        _avegPriceLayer.lineJoin = kCALineJoinRound;
    }
    return _avegPriceLayer;
}

- (CAShapeLayer *)timeSeparatorLayer {
    if (!_timeSeparatorLayer) {
        _timeSeparatorLayer = [CAShapeLayer layer];
        _timeSeparatorLayer.lineWidth = 0.5;
        _timeSeparatorLayer.fillColor = [UIColor ty_colorWithHexString:@"#E8E8E8"].CGColor;
        _timeSeparatorLayer.strokeColor = [UIColor ty_colorWithHexString:@"#E8E8E8"].CGColor;
        _timeSeparatorLayer.lineCap = kCALineCapButt;
        _timeSeparatorLayer.lineJoin = kCALineJoinMiter;
    }
    return _timeSeparatorLayer;
}

- (CAShapeLayer *)staticHeartLayer {
    if (!_staticHeartLayer) {
        _staticHeartLayer = [CAShapeLayer layer];
        _staticHeartLayer.frame = CGRectMake(0, 0, 4, 4);
        _staticHeartLayer.lineWidth = 1;
        _staticHeartLayer.fillColor = [UIColor ty_colorWithHexString:@"#0083FF"].CGColor;
        _staticHeartLayer.strokeColor = [UIColor ty_colorWithHexString:@"#0083FF"].CGColor;
        _staticHeartLayer.lineCap = kCALineCapButt;
        _staticHeartLayer.lineJoin = kCALineJoinMiter;
        _staticHeartLayer.opacity = 0.8;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(2, 2) radius:2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
        _staticHeartLayer.path = path.CGPath;
    }
    return _staticHeartLayer;
}

- (CAShapeLayer *)dynamicHeartLayer {
    if (!_dynamicHeartLayer) {
        _dynamicHeartLayer = [CAShapeLayer layer];
        _dynamicHeartLayer.frame = CGRectMake(0, 0, 4, 4);
        _dynamicHeartLayer.lineWidth = 1;
        _dynamicHeartLayer.fillColor = [UIColor ty_colorWithHexString:@"#0083FF"].CGColor;
        _dynamicHeartLayer.strokeColor = [UIColor ty_colorWithHexString:@"#0083FF"].CGColor;
        _dynamicHeartLayer.lineCap = kCALineCapButt;
        _dynamicHeartLayer.lineJoin = kCALineJoinMiter;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(2, 2) radius:2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
        _dynamicHeartLayer.path = path.CGPath;
    }
    return _dynamicHeartLayer;
}

@end
