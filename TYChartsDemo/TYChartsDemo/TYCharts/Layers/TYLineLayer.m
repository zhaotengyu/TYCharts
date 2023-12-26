//
//  TYLineLayer.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYLineLayer.h"

@interface TYLineLayer ()

@property (nonatomic, strong) NSDictionary<NSString *, CAShapeLayer *> *indexLayerDict;

@end

@implementation TYLineLayer

- (void)drawChart:(CALayer *)contentLayer
{
    [super drawChart:contentLayer];
    
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    
    NSArray *items = @[];
    if (self.indicatorType == TYChartIndicatorTypeAmount) {
        items = data.candleMAItems.copy;
    } else if (self.indicatorType == TYChartIndicatorTypeVolume) {
        items = data.candleMAItems.copy;
    } else if (self.indicatorType == TYChartIndicatorTypeKDJ) {
        items = data.KDJItems.copy;
    } else if (self.indicatorType == TYChartIndicatorTypeRSI) {
        items = data.RSIItems.copy;
    } else if (self.indicatorType == TYChartIndicatorTypeWR) {
        items = data.WRItems.copy;
    }
    
    // 折线图
    if (self.indexLayerDict.allKeys.count == 0) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSInteger index = 0; index < items.count; index++) {
            TYIndexConfiguration *item = items[index];

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
    NSArray<TYChartKLineDataModel *> *models = data.models;
    CGRect barRect = CGRectMake(0, 0, data.config.candleWidth, 0);
    
    [self.indexLayerDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CAShapeLayer * _Nonnull obj, BOOL * _Nonnull stop) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        for (NSInteger index = data.xAxis.startIndex; index < data.xAxis.endIndex; index ++) {
            TYChartKLineDataModel *model = models[index];
            TYTechnicalIndexModel *indexModel;
            if (self.indicatorType == TYChartIndicatorTypeAmount) {
                indexModel = model.amountMAIndexModel;
            } else if (self.indicatorType == TYChartIndicatorTypeVolume) {
                indexModel = model.volumeMAIndexModel;
            } else if (self.indicatorType == TYChartIndicatorTypeKDJ) {
                indexModel = model.KDJIndexModel;
            } else if (self.indicatorType == TYChartIndicatorTypeRSI) {
                indexModel = model.RSIIndexModel;
            } else if (self.indicatorType == TYChartIndicatorTypeWR) {
                indexModel = model.WRIndexModel;
            }
            
            NSNumber *number = indexModel.indexDict[key];
            CGPoint currentPoint = CGPointMake(model.pointX + barRect.size.width / 2, [self transformCoordinateWithCurrentValue:number.doubleValue bounds:contentLayer.bounds]);
            if (index == data.xAxis.startIndex) {
                if (number.doubleValue != CGFLOAT_MIN) {
                    [linePath moveToPoint:currentPoint];
                }
            } else {
                if (number.doubleValue != CGFLOAT_MIN) {
                    [linePath addLineToPoint:currentPoint];
                }
            }
        }

        obj.frame = contentLayer.bounds;
        obj.path = linePath.CGPath;
        [contentLayer addSublayer:obj];
    }];
}

#pragma mark -

- (NSDictionary<NSString *, CAShapeLayer *> *)indexLayerDict
{
    if (!_indexLayerDict) {
        _indexLayerDict = [[NSDictionary alloc] init];
    }
    return _indexLayerDict;
}

@end
