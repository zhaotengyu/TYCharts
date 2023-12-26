//
//  TYCandleStickView.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYCandleStickView.h"
#import "MJRefresh.h"
#import "TYCandleStickLayer.h"
#import "TYMinMaxPriceLayer.H"
#import "TYChartKLineDataModel.h"

@interface TYCandleStickView ()

@property (nonatomic, strong) TYCandleStickLayer *mainLayer;
@property (nonatomic, strong) TYMinMaxPriceLayer *priceLayer;
@property (nonatomic, assign) TYTechnicalIndexType indexType;

@end

@implementation TYCandleStickView

/// 初始化
- (void)prepare
{
    [super prepare];
    
    self.chartLineType = TYChartLineTypeKLine;
    
    TYIndexConfiguration *item = [[TYIndexConfiguration alloc] init];
    item.day = @5;
    item.title = @"MA5";
    item.strokeColor = [UIColor ty_colorWithHexString:@"#FF9100"];
    
    TYIndexConfiguration *item1 = [[TYIndexConfiguration alloc] init];
    item1.day = @10;
    item1.title = @"MA10";
    item1.strokeColor = [UIColor ty_colorWithHexString:@"#2E8AE6"];
    
    TYIndexConfiguration *item2 = [[TYIndexConfiguration alloc] init];
    item2.day = @20;
    item2.title = @"MA20";
    item2.strokeColor = [UIColor ty_colorWithHexString:@"#CC2996"];
    
    self.maItems = @[item, item1, item2];
    
    self.mainScrollView.mj_trailer = [MJRefreshNormalTrailer trailerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadDefault
{
    [super loadDefault];
    self.data.candleMAItems = self.maItems;
    self.data.yAxis.minValueExtraPrecent = 0.08;
    self.data.yAxis.maxValueExtraPrecent = 0.08;
    
    [self.mainScrollView.mj_trailer endRefreshing];
    self.mainScrollView.mj_trailer.hidden = !self.data.haveMoreData;
}

/// 更新图表
- (void)updateChart
{
    [super updateChart];
    [self.priceLayer drawChart:self.axisChartView.layer];
}

/// 更新Y轴数据
- (void)updateYAxisData
{
    CGFloat maxHigh = CGFLOAT_MIN;
    CGFloat minLow = CGFLOAT_MAX;
    
    CGFloat maxValue = CGFLOAT_MIN;
    CGFloat minValue = CGFLOAT_MAX;
    
    NSInteger maxIndex = 0;
    NSInteger minIndex = 0;
    
    NSInteger startIndex = self.data.xAxis.startIndex;
    NSInteger endIndex = self.data.xAxis.endIndex;
    
    NSArray *models = self.data.models;
    
    TYChartMaxMinModel *maxModel = [[TYChartMaxMinModel alloc] init];
    TYChartMaxMinModel *minModel = [[TYChartMaxMinModel alloc] init];
    
    for (NSInteger index = startIndex; index < endIndex; index++) {
        TYChartKLineDataModel *model = models[index];
        
        maxValue = MAX(model.highPrice.doubleValue, maxValue);
        minValue = MIN(model.lowPrice.doubleValue, minValue);
        
        switch (self.indexType) {
            case TYTechnicalIndexTypeMA:
            {
                maxValue = MAX(model.MAIndexModel.maxValue, maxValue);
                minValue = MIN(model.MAIndexModel.minValue, minValue);
            }
                break;
            default:
                break;
        }
        
        if (self.data.config.plotWidth == 1) {
            if (maxHigh < model.closePrice.doubleValue) {
                maxHigh = model.closePrice.doubleValue;
                maxIndex = index;
                maxModel.value = maxHigh;
                maxModel.pointX = model.pointX;
            }
            
            if (minLow > model.closePrice.doubleValue) {
                minLow = model.closePrice.doubleValue;
                minIndex = index;
                minModel.value = minLow;
                minModel.pointX = model.pointX;
            }
        } else {
            if (maxHigh < model.highPrice.doubleValue) {
                maxHigh = model.highPrice.doubleValue;
                maxIndex = index;
                maxModel.value = maxHigh;
                maxModel.pointX = model.pointX;
            }
            
            if (minLow > model.lowPrice.doubleValue) {
                minLow = model.lowPrice.doubleValue;
                minIndex = index;
                minModel.value = minLow;
                minModel.pointX = model.pointX;
            }
        }
    }
    
    self.data.maxModel = maxModel;
    self.data.minModel = minModel;
    [self.data.yAxis calculateMinMax:minValue maxValue:maxValue];
}

/// 配置指标数据
- (void)updateTechnicalIndexData
{
    NSArray *models = [[self.data.models reverseObjectEnumerator] allObjects];
    [models enumerateObjectsUsingBlock:^(TYChartKLineDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TYTechnicalIndexModel *MAIndexModel = [[TYTechnicalIndexModel alloc] init];
        
        for (TYIndexConfiguration *item in self.maItems) {
            NSInteger day = [item.day integerValue];
            CGFloat maValue = CGFLOAT_MIN;
            if (idx >= (day - 1)) {
                maValue = [self _calculateAverageValue:day endIndex:idx datas:models];
            }
            [MAIndexModel.indexDict setObject:[NSNumber numberWithDouble:maValue] forKey:item.title];
        }
        
        obj.MAIndexModel = MAIndexModel;
    }];
}

/// 更新选中数据文字
/// - Parameter index: <#index description#>
- (void)updateIndexText:(NSInteger)index
{
    [super updateIndexText:index];

    NSArray *models = self.data.models;
    TYChartKLineDataModel *model = models[index];
    
    NSMutableAttributedString *attributedString = nil;
    switch (self.indexType) {
        case TYTechnicalIndexTypeMA:
        {
            attributedString = [[NSMutableAttributedString alloc] initWithString:@"均线  "];
            [self.maItems enumerateObjectsUsingBlock:^(TYIndexConfiguration * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSNumber *number = model.MAIndexModel.indexDict[obj.title];
                NSString *string = [NSString stringWithFormat:@"%@:%@  ", obj.title, [TYDecimalNumberTool convertDecimalsToString:number.doubleValue]];
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{ NSForegroundColorAttributeName : obj.strokeColor }]];
            }];
            
            [attributedString addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:11] } range:NSMakeRange(0, attributedString.length)];
        }
            break;
        default:
            attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:displayIndexText:)]) {
        [self.delegate chartView:self displayIndexText:attributedString];
    }
}

#pragma mark - Private

/// 计算平均值
/// - Parameters:
///   - count: <#count description#>
///   - endIndex: <#endIndex description#>
///   - datas: <#datas description#>
- (CGFloat)_calculateAverageValue:(NSInteger)count endIndex:(NSInteger)endIndex datas:(NSArray *)datas
{
    CGFloat result = 0;
    if (endIndex < (count - 1)) {
        return result;
    }

    CGFloat sum = 0.0;
    NSInteger i = endIndex;
    while (i > (endIndex - count)) {
        TYChartKLineDataModel *itemModel = datas[i];
        sum += itemModel.closePrice.doubleValue;
        i -= 1;
    }

    result = sum / count;

    return result;
}

/// 加载更多数据
- (void)loadMoreData
{
    TYChartKLineDataModel *model = self.data.models.lastObject;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chartViewLoadMoreData:withDate:)]) {
        [self.delegate chartViewLoadMoreData:self withDate:model.date];
    }
}

#pragma mark - setter/getter

- (TYCandleStickLayer *)mainLayer
{
    if (!_mainLayer) {
        _mainLayer = [TYCandleStickLayer layerWithDataSource:self.data];
    }
    return _mainLayer;
}

- (TYMinMaxPriceLayer *)priceLayer
{
    if (!_priceLayer) {
        _priceLayer = [TYMinMaxPriceLayer layerWithDataSource:self.data];
    }
    return _priceLayer;
}

@end
