//
//  TYCandleStickLayer.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYCandleStickLayer.h"

@interface TYCandleStickLayer ()

@property (nonatomic, strong) CAShapeLayer *upLayer;
@property (nonatomic, strong) CAShapeLayer *downLayer;
@property (nonatomic, strong) CAShapeLayer *timeLineLayer;

@property (nonatomic, strong) NSDictionary<NSString *, CAShapeLayer *> *indexLayerDict;

@end

@implementation TYCandleStickLayer

- (void)drawChart:(CALayer *)contentLayer
{
    [super drawChart:contentLayer];
    
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    
    if (data.config.plotWidth == 1) {
        [self.indexLayerDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CAShapeLayer * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj removeFromSuperlayer];
        }];
        [self.upLayer removeFromSuperlayer];
        [self.downLayer removeFromSuperlayer];
        [self drawLineLayer:data atContentLayer:contentLayer];
    } else {
        
        [self.timeLineLayer removeFromSuperlayer];
        [self drawCandleLayer:data atContentLayer:contentLayer];
    }
}

/// 缩小到折线图
/// - Parameters:
///   - data: <#data description#>
///   - contentLayer: <#contentLayer description#>
- (void)drawLineLayer:(TYChartDataSource *)data atContentLayer:(CALayer *)contentLayer
{
    NSArray<TYChartKLineDataModel *> *models = data.models;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (NSInteger index = data.xAxis.startIndex; index < data.xAxis.endIndex; index ++) {
        TYChartKLineDataModel *model = models[index];
        CGPoint currentPoint = CGPointMake(model.pointX, [self transformCoordinateWithCurrentValue:model.closePrice.doubleValue bounds:contentLayer.bounds]);
        if (index == data.xAxis.startIndex) {
            [linePath moveToPoint:currentPoint];
        } else {
            [linePath addLineToPoint:currentPoint];
        }
    }

    [contentLayer addSublayer:self.timeLineLayer];
    self.timeLineLayer.path = linePath.CGPath;
    self.timeLineLayer.frame = contentLayer.bounds;
    self.timeLineLayer.lineWidth = self.data.config.lineWidth;
    self.timeLineLayer.fillColor = [UIColor clearColor].CGColor;
    self.timeLineLayer.strokeColor = [UIColor ty_colorWithHexString:@"#2E8AE6"].CGColor;
}

/// 正常蜡烛图
/// - Parameters:
///   - data: <#data description#>
///   - contentLayer: <#contentLayer description#>
- (void)drawCandleLayer:(TYChartDataSource *)data atContentLayer:(CALayer *)contentLayer
{
    CGFloat startIndex = data.xAxis.startIndex;
    CGFloat endIndex = data.xAxis.endIndex;

    // 上涨蜡烛图
    UIBezierPath *upPath = [UIBezierPath bezierPath];

    // 下跌蜡烛图
    UIBezierPath *downPath = [UIBezierPath bezierPath];

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSArray *models = data.models;
            
    for (NSInteger index = startIndex; index < endIndex; index ++) {
        TYChartKLineDataModel *model = models[index];
        [path removeAllPoints];
        
        CGFloat candleX = model.pointX;

        // 最高价
        CGFloat hightY = [self transformCoordinateWithCurrentValue:model.highPrice.doubleValue bounds:contentLayer.bounds];
        // 最低价
        CGFloat lowY = [self transformCoordinateWithCurrentValue:model.lowPrice.doubleValue bounds:contentLayer.bounds];
        // 开盘价
        CGFloat openY = [self transformCoordinateWithCurrentValue:model.openPrice.doubleValue bounds:contentLayer.bounds];
        // 收盘价
        CGFloat closeY = [self transformCoordinateWithCurrentValue:model.closePrice.doubleValue bounds:contentLayer.bounds];

        CGFloat topY = 0;
        CGFloat bottomY = 0;
        switch (model.trend) {
            case TYChartLineTrendUp: // 上涨
                topY = closeY;
                bottomY = openY;
                break;
            case TYChartLineTrendDown: // 下跌
                topY = openY;
                bottomY = closeY;
                break;
            case TYChartLineTrendEqual: // 平盘
                topY = bottomY = openY;
                break;
        }

        CGFloat lineX = candleX + data.config.candleWidth / 2;
        // 上影线
        [path moveToPoint:CGPointMake(lineX, hightY)];
        [path addLineToPoint:CGPointMake(lineX, topY)];
        // 下影线
        [path moveToPoint:CGPointMake(lineX, bottomY)];
        [path addLineToPoint:CGPointMake(lineX, lowY)];

        // 实体
        [path moveToPoint:CGPointMake(candleX, topY)];
        [path addLineToPoint:CGPointMake(candleX + data.config.candleWidth, topY)];
        [path addLineToPoint:CGPointMake(candleX + data.config.candleWidth, bottomY)];
        [path addLineToPoint:CGPointMake(candleX, bottomY)];

        [path closePath];

        if (model.trend == TYChartLineTrendDown) { // 下跌
            [downPath appendPath:path];
        } else {
            [upPath appendPath:path];
        }
    }
    
    [contentLayer addSublayer:self.upLayer];
    self.upLayer.path = upPath.CGPath;
    self.upLayer.frame = contentLayer.bounds;
    self.upLayer.lineWidth = data.config.lineWidth;
    self.upLayer.fillColor = [UIColor clearColor].CGColor;
    self.upLayer.strokeColor = data.config.upColor.CGColor;
    
    [contentLayer addSublayer:self.downLayer];
    self.downLayer.path = downPath.CGPath;
    self.downLayer.frame = contentLayer.bounds;
    self.downLayer.lineWidth = self.data.config.lineWidth;
    self.downLayer.fillColor = self.data.config.downColor.CGColor;
    self.downLayer.strokeColor = self.data.config.downColor.CGColor;
    
    
    // 折线图
    if (self.indexLayerDict.allKeys.count == 0) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSInteger index = 0; index < data.candleMAItems.count; index++) {
            TYIndexConfiguration *item = data.candleMAItems[index];
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.lineCap = kCALineCapRound;
            layer.lineJoin = kCALineJoinRound;
            layer.lineWidth = 1;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = item.strokeColor.CGColor;
            layer.masksToBounds = YES;
            [dict setObject:layer forKey:item.title];
        }
        self.indexLayerDict = [dict copy];
    }

    // 绘制均线折线图
    [self.indexLayerDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CAShapeLayer * _Nonnull obj, BOOL * _Nonnull stop) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        for (NSInteger index = startIndex; index < endIndex; index ++) {
            TYChartKLineDataModel *model = models[index];
            NSNumber *number = model.MAIndexModel.indexDict[key];
            CGPoint currentPoint = CGPointMake(model.pointX + data.config.candleWidth / 2, [self transformCoordinateWithCurrentValue:number.doubleValue bounds:contentLayer.bounds]);
            if (index == startIndex) {
                if (number.doubleValue != CGFLOAT_MIN) {
                    [linePath moveToPoint:currentPoint];
                }
            } else {
                if (number.doubleValue != CGFLOAT_MIN) {
                    [linePath addLineToPoint:currentPoint];
                }
            }
        }

        [contentLayer addSublayer:obj];
        obj.frame = contentLayer.bounds;
        obj.path = linePath.CGPath;
    }];
}

#pragma mark - getter/setter

- (CAShapeLayer *)upLayer
{
    if (!_upLayer) {
        _upLayer = [CAShapeLayer layer];
        _upLayer.lineCap = kCALineCapButt;
        _upLayer.lineJoin = kCALineJoinMiter;
    }
    return _upLayer;
}

- (CAShapeLayer *)downLayer
{
    if (!_downLayer) {
        _downLayer = [CAShapeLayer layer];
        _downLayer.lineCap = kCALineCapButt;
        _downLayer.lineJoin = kCALineJoinMiter;
    }
    return _downLayer;
}

- (CAShapeLayer *)timeLineLayer
{
    if (!_timeLineLayer) {
        _timeLineLayer = [CAShapeLayer layer];
        _timeLineLayer.lineCap = kCALineCapButt;
        _timeLineLayer.lineJoin = kCALineJoinMiter;
    }
    return _timeLineLayer;
}

- (NSDictionary<NSString *, CAShapeLayer *> *)indexLayerDict
{
    if (!_indexLayerDict) {
        _indexLayerDict = [[NSDictionary alloc] init];
    }
    return _indexLayerDict;
}

@end
