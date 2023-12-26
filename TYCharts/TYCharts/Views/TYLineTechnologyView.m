//
//  TYLineTechnologyView.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYLineTechnologyView.h"
#import "TYLineLayer.h"
#import "TYChartAlgorithm.h"

@interface TYLineTechnologyView ()

@property (nonatomic, strong) TYLineLayer *mainLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *yAxisTextLayers;

@end

@implementation TYLineTechnologyView

/// 初始化
- (void)prepare
{
    [super prepare];
    
}

- (void)loadDefault
{
    [super loadDefault];
    
    self.data.yAxis.minValueExtraPrecent = 0;
    self.data.yAxis.maxValueExtraPrecent = 0;
    self.data.yAxis.tickInterval = 0;
    self.data.yAxis.displayYAxisText = NO;
}

/// 更新图表
- (void)updateChart
{
    [super updateChart];
    [self.axisLayer drawDateTextLayer:self.layer];
    [self drawYAxisTickIntervalPrices:self.axisChartView.layer];
    [self drawSeparatorLine:self.separatoreView.layer];
}

/// 更新Y轴数据
- (void)updateYAxisData
{
    CGFloat maxValue = CGFLOAT_MIN;
    CGFloat minValue = CGFLOAT_MAX;

    NSInteger startIndex = self.data.xAxis.startIndex;
    NSInteger endIndex = self.data.xAxis.endIndex;

    NSArray *models = self.data.models;

    for (NSInteger index = startIndex; index < endIndex; index++) {
        TYChartKLineDataModel *model = models[index];

        if (self.indicatorType == TYChartIndicatorTypeKDJ) {
            maxValue = MAX(model.KDJIndexModel.maxValue, maxValue);
            minValue = MIN(model.KDJIndexModel.minValue, minValue);
        } else if (self.indicatorType == TYChartIndicatorTypeRSI) {
            maxValue = MAX(model.RSIIndexModel.maxValue, maxValue);
            minValue = MIN(model.RSIIndexModel.minValue, minValue);
        } else if (self.indicatorType == TYChartIndicatorTypeWR) {
            maxValue = MAX(model.WRIndexModel.maxValue, maxValue);
            minValue = MIN(model.WRIndexModel.minValue, minValue);
        }
    }

    [self.data.yAxis calculateMinMax:minValue maxValue:maxValue];
}

/// 配置指标数据
- (void)updateTechnicalIndexData
{
    if (self.indicatorType == TYChartIndicatorTypeKDJ) {
        [self setupKDJConfig];
        [TYChartAlgorithm calculateKDJWithKDayTime:9 dDayTime:3 jDayTime:3 model:self.data.models];
    } else if (self.indicatorType == TYChartIndicatorTypeRSI) {
        [self setupRSIConfig];
        [TYChartAlgorithm calculateRSIWithDayTime:6 model:self.data.models];
        [TYChartAlgorithm calculateRSIWithDayTime:12 model:self.data.models];
        [TYChartAlgorithm calculateRSIWithDayTime:24 model:self.data.models];
    } else if (self.indicatorType == TYChartIndicatorTypeWR) {
        [self setupWRConfig];
        [TYChartAlgorithm calculateWRWithDayTime:6 model:self.data.models];
        [TYChartAlgorithm calculateWRWithDayTime:10 model:self.data.models];
    }
}

/// 更新选中数据文字
/// - Parameter index: <#index description#>
- (void)updateIndexText:(NSInteger)index
{
    [super updateIndexText:index];

    NSArray *models = self.data.models;
    TYChartKLineDataModel *model = models[index];
    TYTechnicalIndexModel *indexModel;
    if (self.indicatorType == TYChartIndicatorTypeKDJ) {
        indexModel = model.KDJIndexModel;
    } else if (self.indicatorType == TYChartIndicatorTypeRSI) {
        indexModel = model.RSIIndexModel;
    } else if (self.indicatorType == TYChartIndicatorTypeWR) {
        indexModel = model.WRIndexModel;
    }
    
    NSString *string = @"(";
    for (NSInteger index = 0; index < self.maItems.count; index++) {
        TYIndexConfiguration *item = self.maItems[index];
        NSString *num = [NSString stringWithFormat:@"%@", item.day];
        string = [string stringByAppendingString:num];
        if (index != self.maItems.count - 1) {
            string = [string stringByAppendingString:@","];
        }
    }
    string = [string stringByAppendingString:@")  "];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [self.maItems enumerateObjectsUsingBlock:^(TYIndexConfiguration * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *number = indexModel.indexDict[obj.title];
        NSString *string = [NSString stringWithFormat:@"%@:%@  ", obj.title, [TYDecimalNumberTool convertDecimalsToString:[number doubleValue]]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{ NSForegroundColorAttributeName : obj.strokeColor }]];
    }];

    [attributedString addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:11] } range:NSMakeRange(0, attributedString.length)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:displayIndexText:)]) {
        [self.delegate chartView:self displayIndexText:attributedString];
    }
}

#pragma mark - Private

/// 绘制固定价格 @[@80, @50, @20];
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawYAxisTickIntervalPrices:(CALayer *)contentLayer
{
    if (self.yAxisTextLayers.count) {
        for (CATextLayer *layer in self.yAxisTextLayers) {
            [layer removeFromSuperlayer];
        }
        [self.yAxisTextLayers removeAllObjects];
    }

    NSArray *prices = @[@80, @50, @20];

    CGFloat minAxisValue = self.data.yAxis.minYAxisValue;
    CGFloat maxAxisValue = self.data.yAxis.maxYAxisValue;

    CGFloat maxHeight = CGRectGetHeight(contentLayer.frame);
    CGFloat heightRate = (maxHeight) / (maxAxisValue - minAxisValue);

    for (NSInteger index = 0; index < prices.count; index ++) {

        CGFloat currentValue = [prices[index] doubleValue];
        if (currentValue < minAxisValue || currentValue > maxAxisValue) {
            continue;
        }

        CGFloat pointY = maxHeight - (currentValue - minAxisValue) * heightRate;
        CATextLayer *yAxisLabel = nil;
        if (self.yAxisTextLayers.count != prices.count) {
            yAxisLabel = [CATextLayer layer];
            [contentLayer addSublayer:yAxisLabel];
            yAxisLabel.fontSize = 10;
            yAxisLabel.contentsScale = [UIScreen mainScreen].scale;
            yAxisLabel.alignmentMode = kCAAlignmentCenter;
            yAxisLabel.foregroundColor = [UIColor ty_colorWithHexString:@"#555555"].CGColor;
            yAxisLabel.backgroundColor = [UIColor clearColor].CGColor;
            [self.yAxisTextLayers addObject:yAxisLabel];
        } else {
            yAxisLabel = [self.yAxisTextLayers objectAtIndex:index];
        }
        yAxisLabel.string = [NSString stringWithFormat:@"%.2f", currentValue];

        CGSize textSize = [yAxisLabel preferredFrameSize];
        textSize.height = 13;
        pointY -= textSize.height;
        if (pointY < 0) {
            pointY = 0;
        }
        yAxisLabel.frame = CGRectMake(2, pointY, textSize.width, textSize.height);
    }
}

/// 绘制固定分割线 @[@80, @50, @20]
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawSeparatorLine:(CALayer *)contentLayer
{
    NSArray *prices = @[@80, @50, @20];

    // 额外百分比
    CGFloat minAxisValue = self.data.yAxis.minYAxisValue;
    CGFloat maxAxisValue = self.data.yAxis.maxYAxisValue;

    CGFloat maxHeight = CGRectGetHeight(contentLayer.frame);
    CGFloat heightRate = (maxHeight) / (maxAxisValue - minAxisValue);

    UIBezierPath *path = [UIBezierPath bezierPath];

    for (NSInteger index = 0; index < prices.count; index++) {

        CGFloat currentValue = [prices[index] doubleValue];
        CGFloat pointY = maxHeight - (currentValue - minAxisValue) * heightRate;

        CGPoint startPoint = CGPointMake(0, pointY);
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(contentLayer.frame), pointY);

        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
    }

    [contentLayer addSublayer:self.lineLayer];
    self.lineLayer.frame = contentLayer.bounds;
    self.lineLayer.path = path.CGPath;
}

- (void)setupKDJConfig
{
    TYIndexConfiguration *item6 = [[TYIndexConfiguration alloc] init];
    item6.day = @9;
    item6.title = @"K";
    item6.strokeColor = [UIColor ty_colorWithHexString:@"#FF9100"];

    TYIndexConfiguration *item7 = [[TYIndexConfiguration alloc] init];
    item7.day = @3;
    item7.title = @"D";
    item7.strokeColor = [UIColor ty_colorWithHexString:@"#2E8AE6"];

    TYIndexConfiguration *item8 = [[TYIndexConfiguration alloc] init];
    item8.day = @3;
    item8.title = @"J";
    item8.strokeColor = [UIColor ty_colorWithHexString:@"#CC2996"];

    self.maItems = @[item6, item7, item8];
}

- (void)setupRSIConfig
{
    TYIndexConfiguration *item6 = [[TYIndexConfiguration alloc] init];
    item6.day = @6;
    item6.title = @"RSI6";
    item6.strokeColor = [UIColor ty_colorWithHexString:@"#FF9100"];
    
    TYIndexConfiguration *item7 = [[TYIndexConfiguration alloc] init];
    item7.day = @12;
    item7.title = @"RSI12";
    item7.strokeColor = [UIColor ty_colorWithHexString:@"#2E8AE6"];
    
    TYIndexConfiguration *item8 = [[TYIndexConfiguration alloc] init];
    item8.day = @24;
    item8.title = @"RSI24";
    item8.strokeColor = [UIColor ty_colorWithHexString:@"#CC2996"];
    
    self.maItems = @[item6, item7, item8];
}

- (void)setupWRConfig
{
    // MA指标配置
    TYIndexConfiguration *item1 = [[TYIndexConfiguration alloc] init];
    item1.day = @6;
    item1.title = @"WR6";
    item1.strokeColor = [UIColor ty_colorWithHexString:@"#FF9100"];

    TYIndexConfiguration *item2 = [[TYIndexConfiguration alloc] init];
    item2.day = @10;
    item2.title = @"WR10";
    item2.strokeColor = [UIColor ty_colorWithHexString:@"#2E8AE6"];
    
    self.maItems = @[item1, item2];
}

#pragma mark - getter/setter

- (void)setMaItems:(NSArray<TYIndexConfiguration *> *)maItems
{
    _maItems = maItems;
    if (maItems.count != 0) {
        if (self.indicatorType == TYChartIndicatorTypeRSI) {
            self.data.RSIItems = maItems;
        } else if (self.indicatorType == TYChartIndicatorTypeKDJ) {
            self.data.KDJItems = maItems;
        } else if (self.indicatorType == TYChartIndicatorTypeWR) {
            self.data.WRItems = maItems;
        }
    }
}

- (TYLineLayer *)mainLayer
{
    if (!_mainLayer) {
        _mainLayer = [TYLineLayer layerWithDataSource:self.data];
        _mainLayer.indicatorType = self.indicatorType;
    }
    return _mainLayer;
}

- (CAShapeLayer *)lineLayer
{
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.lineWidth = 1;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        _lineLayer.strokeColor = [UIColor ty_colorWithHexString:@"#666666"].CGColor;
        _lineLayer.masksToBounds = YES;
        [_lineLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1], nil]];
    }
    return _lineLayer;
}

- (NSMutableArray<CATextLayer *> *)yAxisTextLayers
{
    if (!_yAxisTextLayers) {
        _yAxisTextLayers = [[NSMutableArray alloc] init];
    }
    return _yAxisTextLayers;
}

@end
