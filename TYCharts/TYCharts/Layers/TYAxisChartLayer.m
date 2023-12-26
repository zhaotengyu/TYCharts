//
//  TYAxisChartLayer.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYAxisChartLayer.h"

@interface TYAxisChartLayer ()

@property (nonatomic, strong) CAShapeLayer *xAxisLayer;
@property (nonatomic, strong) CAShapeLayer *yAxisLayer;
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *yAxisTextLayers;
/// 当前展示月份图层
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *monthTextLayers;

/// y轴右侧数字
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *rightYAxisTextLayers;
/// y轴左侧数字
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *leftYAxisTextLayers;

@end

@implementation TYAxisChartLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        
        for (NSInteger index = 0; index < 3; index++) {
            CATextLayer * textlayer = [CATextLayer layer];
            textlayer.font = (__bridge CTFontRef)[UIFont systemFontOfSize:10];
            textlayer.fontSize = [UIFont systemFontOfSize:10].pointSize;
            textlayer.contentsScale = UIScreen.mainScreen.scale;
            textlayer.alignmentMode = kCAAlignmentNatural;
            [self.rightYAxisTextLayers addObject:textlayer];
        }
        for (NSInteger index = 0; index < 3; index++) {
            CATextLayer * textlayer = [CATextLayer layer];
            textlayer.font = (__bridge CTFontRef)[UIFont systemFontOfSize:10];
            textlayer.fontSize = [UIFont systemFontOfSize:10].pointSize;
            textlayer.contentsScale = UIScreen.mainScreen.scale;
            textlayer.alignmentMode = kCAAlignmentNatural;
            [self.leftYAxisTextLayers addObject:textlayer];
        }   
    }
    return self;
}

- (void)drawChart:(CALayer *)contentLayer
{
    [super drawChart:contentLayer];
}

/// 绘制y轴分割线
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawYAxisGridLine:(CALayer *)contentLayer
{
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    TYYAxisModel *axisModel = data.yAxis;
    if (axisModel.tickInterval == 0) {
        return;
    }
    
    CGFloat maxHeight = CGRectGetHeight(contentLayer.bounds);
    CGFloat tickIntervalH = maxHeight / (axisModel.tickInterval - 1);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger index = 1; index < axisModel.tickInterval; index++) {
        
        CGFloat pointY = tickIntervalH * index;
        
        CGPoint startPoint = CGPointMake(CGRectGetMinX(contentLayer.bounds), pointY + CGRectGetMinY(contentLayer.bounds));
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(contentLayer.bounds), pointY + CGRectGetMinY(contentLayer.bounds));
        
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
    }
    
    [contentLayer addSublayer:self.yAxisLayer];
    self.yAxisLayer.path = path.CGPath;
    self.yAxisLayer.frame = contentLayer.bounds;
    self.yAxisLayer.lineWidth = data.yAxis.lineWidth;
    self.yAxisLayer.strokeColor = data.yAxis.lineColor.CGColor;
}

/// 绘制y轴价格
- (void)drawYAxisTickIntervalPrices:(CALayer *)contentLayer
{
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    TYYAxisModel *axisModel = data.yAxis;
    if (axisModel.tickInterval == 0 ||
        axisModel.yAxisTexts.count != axisModel.tickInterval ||
        !axisModel.displayYAxisText) {
        return;
    }
    
    CGFloat maxHeight = CGRectGetHeight(contentLayer.bounds);
    CGFloat tickIntervalH = maxHeight / (axisModel.tickInterval - 1);
    
    for (NSInteger index = 0; index < axisModel.tickInterval; index++) {
        CATextLayer *textlayer;
        if (self.yAxisTextLayers.count != axisModel.tickInterval) {
            textlayer = [CATextLayer layer];
            textlayer.font = (__bridge CTFontRef)axisModel.font;
            textlayer.fontSize = axisModel.font.pointSize;
            textlayer.foregroundColor = axisModel.textColor.CGColor;
            textlayer.contentsScale = UIScreen.mainScreen.scale;
            textlayer.alignmentMode = kCAAlignmentNatural;
            [contentLayer addSublayer:textlayer];
            [self.yAxisTextLayers addObject:textlayer];
        } else {
            textlayer = [self.yAxisTextLayers objectAtIndex:index];
        }
        
        NSNumber *num = axisModel.yAxisTexts[index];
        NSString *text = [NSString stringWithFormat:@"%@", [TYDecimalNumberTool convertDecimalsToString:num.doubleValue]];
        if (!axisModel.displayYAxisZeroText && index == 0) {
            text = @"";
        }
        textlayer.string = text;
        
        NSDictionary<NSAttributedStringKey, id> *attributes = @{ NSFontAttributeName : axisModel.font,
        NSForegroundColorAttributeName : axisModel.textColor };
        
        CGSize textSize = CGSizeZero;
        if ([text isKindOfClass:[NSString class]]) {
           textSize = [text sizeWithAttributes:attributes];
        } else {
           textSize = ((NSAttributedString *)text).size;
        }
      
        CGPoint point = CGPointMake(CGRectGetMinX(contentLayer.bounds) ,CGRectGetMaxY(contentLayer.bounds) - tickIntervalH * index);

        if (index == 0) {
            point.y -= (textSize.height);
        }
        textlayer.frame = CGRectMake(point.x, point.y, textSize.width, textSize.height);
    }
}

/// 绘制x轴分割线
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawXAxisGridLine:(CALayer *)contentLayer
{
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    
    CGFloat startIndex = data.xAxis.startIndex;
    CGFloat endIndex = data.xAxis.endIndex;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSArray *models = data.models;
    
    for (NSInteger index = startIndex; index < endIndex; index ++) {
        TYChartKLineDataModel *model = models[index];
        if (model.displayMonthLine) {
            CGFloat candleX = model.pointX;
            CGFloat lineX = candleX + data.config.candleWidth / 2;
            [path moveToPoint:CGPointMake(lineX, CGRectGetMinY(contentLayer.bounds))];
            [path addLineToPoint:CGPointMake(lineX, CGRectGetMaxY(contentLayer.bounds))];
        }
    }
    
    [contentLayer addSublayer:self.xAxisLayer];
    self.xAxisLayer.path = path.CGPath;
    self.xAxisLayer.frame = contentLayer.bounds;
    self.xAxisLayer.lineWidth = self.data.yAxis.lineWidth;
    self.xAxisLayer.strokeColor = self.data.yAxis.lineColor.CGColor;
}

/// 月份
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawDateTextLayer:(CALayer *)contentLayer
{
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    
    if (self.monthTextLayers.count) {
        for (CATextLayer *layer in self.monthTextLayers) {
            [layer removeFromSuperlayer];
        }
        [self.monthTextLayers removeAllObjects];
    }

    CGFloat maxWidth = CGRectGetWidth(contentLayer.bounds);
    CGFloat maxHeight = CGRectGetHeight(contentLayer.bounds);

    CGFloat startIndex = data.xAxis.startIndex;
    CGFloat endIndex = data.xAxis.endIndex;

    NSArray *models = data.models;

    for (NSInteger index = startIndex; index < endIndex; index ++) {
        TYChartKLineDataModel *model = models[index];
        if (model.displayMonthLine) {
            CATextLayer *yAxisLabel = [CATextLayer layer];
            [contentLayer addSublayer:yAxisLabel];
            yAxisLabel.masksToBounds = YES;
            yAxisLabel.string = [model.date stringWithFormat:@"yyyy-MM"];
            yAxisLabel.font = (__bridge CFTypeRef _Nullable)([UIFont DinMediumFontWithSize:10]);
            yAxisLabel.fontSize = [UIFont DinMediumFontWithSize:10].pointSize;
            yAxisLabel.contentsScale = [UIScreen mainScreen].scale;
            yAxisLabel.alignmentMode = kCAAlignmentNatural;
            yAxisLabel.foregroundColor = [UIColor ty_colorWithHexString:@"#555555"].CGColor;
            yAxisLabel.backgroundColor = [UIColor clearColor].CGColor;
            CGSize textSize = [yAxisLabel preferredFrameSize];
            CGFloat x = maxWidth - (model.pointX + data.config.candleWidth / 2) + data.config.contentOffset.x;
            
            CGFloat textX = x - textSize.width * .5 - 5.5;
            
            yAxisLabel.frame = CGRectMake(textX, maxHeight, textSize.width, textSize.height);
            [self.monthTextLayers addObject:yAxisLabel];
        }
    }
}

/// 绘制分时y轴数据
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawTimeLineYAxisTextLayer:(CALayer *)contentLayer
{
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    
    CGFloat maxHeight = CGRectGetHeight(contentLayer.bounds);
    CGFloat tickIntervalH = maxHeight / 2;
    
    CGFloat currentValue = data.yAxis.maxYAxisValue - (data.yAxis.maxYAxisValue - data.yAxis.minYAxisValue) / 2;
    CGFloat maxRate = data.yAxis.maxYAxisValue / currentValue - 1;
    CGFloat minRate = data.yAxis.minYAxisValue / currentValue - 1;
    
    NSArray *leftArrays = @[[NSString stringWithFormat:@"%.2f", data.yAxis.minYAxisValue], [NSString stringWithFormat:@"%.2f", currentValue], [NSString stringWithFormat:@"%.2f", data.yAxis.maxYAxisValue]];
    NSArray *rightArrays = @[[NSString stringWithFormat:@"%.2f%%", minRate * 100], @"0.00%", [NSString stringWithFormat:@"%.2f%%", maxRate * 100]];

    for (NSInteger index = 0; index < 3; index++) {
           
        CGPoint point = CGPointZero;
        // 左侧
        CATextLayer *leftLayer = self.leftYAxisTextLayers[index];
        leftLayer.string = [NSString stringWithFormat:@"%@", leftArrays[index]];
        CGSize leftTextSize = [leftLayer preferredFrameSize];
        point.x = 0;
        point.y = CGRectGetMaxY(contentLayer.bounds) - tickIntervalH * index - leftTextSize.height;
        if (index == 2) {
            point.y += leftTextSize.height;
        }
        leftLayer.frame = CGRectMake(point.x,
                                     point.y,
                                     leftTextSize.width,
                                     leftTextSize.height);
        [contentLayer addSublayer:leftLayer];
        
        // 右侧
        CATextLayer *rightLayer = self.rightYAxisTextLayers[index];
        rightLayer.string = [NSString stringWithFormat:@"%@", rightArrays[index]];
        CGSize rightTextSize = [rightLayer preferredFrameSize];
        point.x = CGRectGetMaxX(contentLayer.bounds) - rightTextSize.width;
        rightLayer.frame = CGRectMake(point.x,
                                      point.y,
                                      rightTextSize.width,
                                      rightTextSize.height);
        [contentLayer addSublayer:rightLayer];
        
        if (index < 1) { // 上涨
            leftLayer.foregroundColor = [UIColor ty_colorWithHexString:@"#FF22A875"].CGColor;
            rightLayer.foregroundColor = [UIColor ty_colorWithHexString:@"#FF22A875"].CGColor;
        } else if (index > 1) { // 下跌
            leftLayer.foregroundColor = [UIColor ty_colorWithHexString:@"#FFF04848"].CGColor;
            rightLayer.foregroundColor = [UIColor ty_colorWithHexString:@"#FFF04848"].CGColor;
        } else {
            leftLayer.foregroundColor = [UIColor ty_colorWithHexString:@"#FF555555"].CGColor;
            rightLayer.foregroundColor = [UIColor ty_colorWithHexString:@"#FF555555"].CGColor;
        }
    }
}

#pragma mark - setter/getter

- (CAShapeLayer *)xAxisLayer
{
    if (!_xAxisLayer) {
        _xAxisLayer = [CAShapeLayer layer];
        _xAxisLayer.masksToBounds = YES;
    }
    return _xAxisLayer;
}

- (CAShapeLayer *)yAxisLayer
{
    if (!_yAxisLayer) {
        _yAxisLayer = [CAShapeLayer layer];
        _yAxisLayer.masksToBounds = YES;
    }
    return _yAxisLayer;
}

- (NSMutableArray<CATextLayer *> *)yAxisTextLayers
{
    if (!_yAxisTextLayers) {
        _yAxisTextLayers = [[NSMutableArray alloc] init];
    }
    return _yAxisTextLayers;
}

- (NSMutableArray<CATextLayer *> *)monthTextLayers
{
    if (!_monthTextLayers) {
        _monthTextLayers = [[NSMutableArray alloc] init];
    }
    return _monthTextLayers;
}

- (NSMutableArray<CATextLayer *> *)rightYAxisTextLayers
{
    if (!_rightYAxisTextLayers) {
        _rightYAxisTextLayers = [[NSMutableArray alloc] init];
    }
    return _rightYAxisTextLayers;
}

- (NSMutableArray<CATextLayer *> *)leftYAxisTextLayers
{
    if (!_leftYAxisTextLayers) {
        _leftYAxisTextLayers = [[NSMutableArray alloc] init];
    }
    return _leftYAxisTextLayers;
}

@end
