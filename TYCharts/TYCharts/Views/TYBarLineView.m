//
//  TYBarLineView.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYBarLineView.h"
#import "TYLineLayer.h"
#import "TYHistogramLayer.h"
#import "TYChartAlgorithm.h"

@interface TYBarLineView ()

@property (nonatomic, strong) TYLineLayer *lineLayer;
@property (nonatomic, strong) TYHistogramLayer *mainLayer;

@end

@implementation TYBarLineView

/// 初始化
- (void)prepare
{
    [super prepare];
    
    self.indicatorType = TYChartIndicatorTypeAmount;
    
    TYIndexConfiguration *item = [[TYIndexConfiguration alloc] init];
    item.day = @5;
    item.title = @"MA5";
    item.strokeColor = [UIColor ty_colorWithHexString:@"#FF9100"];
    
    TYIndexConfiguration *item1 = [[TYIndexConfiguration alloc] init];
    item1.day = @10;
    item1.title = @"MA10";
    item1.strokeColor = [UIColor ty_colorWithHexString:@"#2E8AE6"];
    
    self.maItems = @[item, item1];
}

- (void)loadDefault
{
    [super loadDefault];
    
    if (self.chartLineType != TYChartLineTypeKLine) {
        NSInteger count = TYChartTimeLinePointCount;
        if (self.chartLineType == TYChartLineType5DTimeLine) {
            count = TYChart5DTimeLinePointCount;
        } else if (self.chartLineType == TYChartLineTypeTimeLine) {
            count = TYChartTimeLinePointCount;
        }
        CGFloat width = CGRectGetWidth(self.mainScrollView.bounds) * 2.0 / (count * 3 - 1);
        self.data.config.lineWidth = width;
        self.data.config.candleSpacing = width / 2;
        self.data.config.candleWidth = 0;
        
    } else {
        self.data.candleMAItems = self.maItems;
    }
    
    self.data.yAxis.minValueExtraPrecent = 0;
    self.data.yAxis.maxValueExtraPrecent = 0;
    self.data.yAxis.tickInterval = 2;
    self.data.yAxis.displayYAxisText = YES;
    self.data.yAxis.displayYAxisZeroText = NO;
}

/// 更新图表
- (void)updateChart
{
    [super updateChart];
    [self.axisLayer drawDateTextLayer:self.layer];
    [self.lineLayer drawChart:self.mainChartView.layer];
}

/// 更新Y轴数据
- (void)updateYAxisData
{
    CGFloat maxValue = CGFLOAT_MIN;
    CGFloat minValue = 0;

    NSInteger startIndex = self.data.xAxis.startIndex;
    NSInteger endIndex = self.data.xAxis.endIndex;

    NSArray *models = self.data.models;

    for (NSInteger index = startIndex; index < endIndex; index++) {
        TYChartKLineDataModel *model = models[index];

        if (self.indicatorType == TYChartIndicatorTypeAmount) {
            maxValue = MAX(model.amount.doubleValue, maxValue);
            minValue = MIN(model.amount.doubleValue, minValue);
            
            maxValue = MAX(model.amountMAIndexModel.maxValue, maxValue);
            minValue = MIN(model.amountMAIndexModel.minValue, minValue);
        } else if (self.indicatorType == TYChartIndicatorTypeVolume) {
            maxValue = MAX(model.volume.doubleValue, maxValue);
            minValue = MIN(model.volume.doubleValue, minValue);
            
            maxValue = MAX(model.volumeMAIndexModel.maxValue, maxValue);
            minValue = MIN(model.volumeMAIndexModel.minValue, minValue);
        }
    }
    
    [self.data.yAxis calculateMinMax:minValue maxValue:maxValue];
}

/// 配置指标数据
- (void)updateTechnicalIndexData
{
    [TYChartAlgorithm calculateMAWithIndicatorType:self.indicatorType MAItems:self.data.candleMAItems model:self.data.models];
}

/// 更新选中数据文字
/// - Parameter index: <#index description#>
- (void)updateIndexText:(NSInteger)index
{
    [super updateIndexText:index];

    NSArray *models = self.data.models;
    TYChartKLineDataModel *model = models[index];
    
    TYTechnicalIndexModel *indexModel = nil;
    CGFloat value = 0;
    if (self.indicatorType == TYChartIndicatorTypeAmount) {
        indexModel = model.amountMAIndexModel;
        value = model.amount.doubleValue;
    } else if (self.indicatorType == TYChartIndicatorTypeVolume) {
        indexModel = model.volumeMAIndexModel;
        value = model.volume.doubleValue;
    }
    
    NSString *valueString = [TYDecimalNumberTool convertDecimalsToString:value];
    NSString *suffixString = self.indicatorType == TYChartIndicatorTypeVolume ? @"手" : @"";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@%@", valueString, suffixString]];
    
    [self.data.candleMAItems enumerateObjectsUsingBlock:^(TYIndexConfiguration * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *number = indexModel.indexDict[obj.title];
        CGFloat numberValue = self.indicatorType == TYChartIndicatorTypeVolume ? [number doubleValue] : [number doubleValue];
        NSString *string = [NSString stringWithFormat:@" %@:%@%@", obj.title, [TYDecimalNumberTool convertDecimalsToString:numberValue], suffixString];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{ NSForegroundColorAttributeName : obj.strokeColor }]];
    }];
    
    [attributedString addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:11] } range:NSMakeRange(0, attributedString.length)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:displayIndexText:)]) {
        [self.delegate chartView:self displayIndexText:attributedString];
    }
}

#pragma mark - getter/setter

- (TYLineLayer *)lineLayer
{
    if (!_lineLayer) {
        _lineLayer = [TYLineLayer layerWithDataSource:self.data];
        _lineLayer.indicatorType = self.indicatorType;
    }
    return _lineLayer;
}

- (TYHistogramLayer *)mainLayer
{
    if (!_mainLayer) {
        _mainLayer = [TYHistogramLayer layerWithDataSource:self.data];
        _mainLayer.indicatorType = self.indicatorType;
    }
    return _mainLayer;
}

@end
