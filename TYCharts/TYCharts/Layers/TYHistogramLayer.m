//
//  TYHistogramLayer.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYHistogramLayer.h"

@interface TYHistogramLayer ()

@property (nonatomic, strong) CAShapeLayer *upLayer;
@property (nonatomic, strong) CAShapeLayer *downLayer;

@end

@implementation TYHistogramLayer

- (void)drawChart:(CALayer *)contentLayer
{
    [super drawChart:contentLayer];
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    [self drawBarChart:data inContentLayer:contentLayer];
}

- (void)drawBarChart:(TYChartDataSource *)data inContentLayer:(CALayer *)contentLayer
{
    CGFloat maxHeight = CGRectGetHeight(contentLayer.bounds);

    // 上涨蜡烛图
    UIBezierPath *upPath = [UIBezierPath bezierPath];

    // 下跌蜡烛图
    UIBezierPath *downPath = [UIBezierPath bezierPath];

    UIBezierPath *path = [UIBezierPath bezierPath];

    NSArray<TYChartKLineDataModel *> *models = data.models;
    CGRect barRect = CGRectMake(0, 0, data.config.candleWidth, 0);
    
    for (NSInteger index = data.xAxis.startIndex; index < data.xAxis.endIndex; index++) {
        TYChartKLineDataModel *model = models[index];
        
        CGFloat value = 0;
        if (self.indicatorType == TYChartIndicatorTypeAmount) {
            value = model.amount.doubleValue;
        } else {
            value = model.volume.doubleValue;
        }
        
        [path removeAllPoints];
        
        barRect.origin.x = model.pointX;
        barRect.size.height = maxHeight - [self transformCoordinateWithCurrentValue:value bounds:contentLayer.bounds];
        barRect.origin.y = [self transformCoordinateWithCurrentValue:value bounds:contentLayer.bounds];
        path = [UIBezierPath bezierPathWithRect:barRect];
        [path closePath];
        
        if (model.trend == TYChartLineTrendDown) { // 下跌
            [downPath appendPath:path];
        } else { // 上涨或者平盘
            [upPath appendPath:path];
        }
    }

    [contentLayer addSublayer:self.upLayer];
    self.upLayer.path = upPath.CGPath;
    self.upLayer.frame = contentLayer.bounds;
    
    [contentLayer addSublayer:self.downLayer];
    self.downLayer.path = downPath.CGPath;
    self.downLayer.frame = contentLayer.bounds;
}

#pragma mark - getter/setter

- (CAShapeLayer *)upLayer
{
    if (!_upLayer) {
        _upLayer = [CAShapeLayer layer];
        _upLayer.lineWidth = self.data.config.lineWidth;
        _upLayer.fillColor = [UIColor clearColor].CGColor;
        _upLayer.strokeColor = self.data.config.upColor.CGColor;
        _upLayer.lineCap = kCALineCapButt;
        _upLayer.lineJoin = kCALineJoinMiter;
    }
    return _upLayer;
}

- (CAShapeLayer *)downLayer
{
    if (!_downLayer) {
        _downLayer = [CAShapeLayer layer];
        _downLayer.lineWidth = self.data.config.lineWidth;
        _downLayer.fillColor = self.data.config.downColor.CGColor;
        _downLayer.strokeColor = self.data.config.downColor.CGColor;
        _downLayer.lineCap = kCALineCapButt;
        _downLayer.lineJoin = kCALineJoinMiter;
    }
    return _downLayer;
}

@end
