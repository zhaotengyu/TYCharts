//
//  TYTimeIndexChartView.m
//  TYCharts
//
//  Created by ty on 2023/10/30.
//

#import "TYTimeIndexChartView.h"

@interface TYTimeIndexChartView ()

@property (nonatomic, strong) TYTimeIndexChartLayer *mainLayer;

@end

@implementation TYTimeIndexChartView

/// 初始化
- (void)prepare
{
    [super prepare];

}

- (void)loadDefault
{
    [super loadDefault];
    
    self.data.config.lineWidth = 1;
    self.data.config.candleSpacing = 0;
    self.data.config.candleWidth = 0;
    
    self.data.yAxis.minValueExtraPrecent = 0;
    self.data.yAxis.maxValueExtraPrecent = 0;
    self.data.yAxis.tickInterval = 5;
    self.data.yAxis.displayYAxisText = NO;
}

/// 更新图表
- (void)updateChart
{
    [super updateChart];
    [self.axisLayer drawTimeLineYAxisTextLayer:self.axisChartView.layer];
}

- (void)updateYAxisData
{
    CGFloat maxValue = CGFLOAT_MIN;
    CGFloat minValue = CGFLOAT_MAX;

    NSInteger startIndex = self.data.xAxis.startIndex;
    NSInteger endIndex = self.data.xAxis.endIndex;
    NSArray *models = self.data.models;
    
    TYChartKLineDataModel *model = models.firstObject;
    
    // 昨收
    CGFloat yClose = model.yClosePrice.doubleValue;
    
    CGFloat maxPrice = CGFLOAT_MIN;
    CGFloat minPrice = CGFLOAT_MAX;
    
    // 计算均价和分时价的最大、最小值
    for (NSInteger index = startIndex; index < endIndex; index++) {
        TYChartKLineDataModel *model = models[index];
        maxPrice = MAX(MAX(model.avg_price.doubleValue, model.current.doubleValue), maxPrice);
        minPrice = MIN(MIN(model.avg_price.doubleValue, model.current.doubleValue), minPrice);
    }
    
    if (fabs(maxPrice - yClose) >= fabs(yClose - minPrice)) {
        maxValue = maxPrice;
        minValue = yClose - fabs(maxPrice - yClose);
    } else {
        maxValue = yClose + fabs(yClose - minPrice);
        minValue = minPrice;
    }
    
    [self.data.yAxis calculateMinMax:minValue maxValue:maxValue];
}

/// 配置指标数据
- (void)updateTechnicalIndexData
{
  
}

- (void)updateAllDataPoint
{    
    NSArray<TYChartKLineDataModel *> *models = self.data.models;

    NSInteger count = TYChartTimeLinePointCount;
    if (self.timeLineType == TYTimeLineIndexTypeMinute) {
        count = TYChartTimeLinePointCount;
    } else if (self.timeLineType == TYTimeLineIndexType5DMinute) {
        count = TYChart5DTimeLinePointCount;
    }
    
    CGFloat width = self.mainChartView.ty_width * 2.0 / (count * 3 - 1);
    
    CGFloat step = (self.mainChartView.ty_width - width) / (count - 1);

    for (NSInteger index = 0; index < models.count; index++) {
        
        TYChartKLineDataModel *currentModel = models[index];
        // x坐标
        CGFloat pointX = index * step;
        currentModel.pointX = pointX + 0.5;
    }
}

#pragma mark - getter/setter

- (TYTimeIndexChartLayer *)mainLayer {
    if (!_mainLayer) {
        _mainLayer = [TYTimeIndexChartLayer layerWithDataSource:self.data];
    }
    return _mainLayer;
}

@end
