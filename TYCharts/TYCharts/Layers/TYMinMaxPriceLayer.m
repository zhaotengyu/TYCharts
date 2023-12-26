//
//  TYMinMaxPriceLayer.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYMinMaxPriceLayer.h"

@interface TYMinMaxPriceLayer ()

@property (nonatomic, strong) CAShapeLayer *minMaxLayer;
@property (nonatomic, strong) CATextLayer *maxTextLayer;
@property (nonatomic, strong) CATextLayer *minTextLayer;

@end

@implementation TYMinMaxPriceLayer

- (void)drawChart:(CALayer *)contentLayer
{
    [super drawChart:contentLayer];
    
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    
    // 绘制最高、最低价格
    
    CGFloat maxWidth = CGRectGetWidth(contentLayer.bounds);
    
    TYChartMaxMinModel *maxModel = data.maxModel;
    TYChartMaxMinModel *minModel = data.minModel;
    
    // 最高价
    CGFloat maxX = maxWidth - (maxModel.pointX + data.config.candleWidth / 2) + data.config.contentOffset.x;
    CGFloat hightY = [self transformCoordinateWithCurrentValue:maxModel.value bounds:contentLayer.bounds];
    CGPoint maxPoint = CGPointMake(maxX, hightY);
    
    // 最低价
    CGFloat minX = maxWidth - (minModel.pointX + data.config.candleWidth / 2) + data.config.contentOffset.x;
    CGFloat lowY = [self transformCoordinateWithCurrentValue:minModel.value bounds:contentLayer.bounds];
    CGPoint minPoint = CGPointMake(minX, lowY);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    // 最大值
    NSString *maxValueText = [NSString stringWithFormat:@"%.2f", maxModel.value];
    self.maxTextLayer.string = maxValueText;
    CGSize maxTextSize = [self.maxTextLayer preferredFrameSize];
    BOOL maxDirectionLeft = (maxPoint.x + 20 + maxTextSize.width) > maxWidth;
    self.maxTextLayer.frame = CGRectMake((maxDirectionLeft ? (maxPoint.x - 20 - maxTextSize.width) : maxPoint.x + 20),
                                    maxPoint.y - 1.5 - maxTextSize.height / 2,
                                    maxTextSize.width,
                                    maxTextSize.height);
    
    // 最小值
    NSString *minValueText = [NSString stringWithFormat:@"%.2f", minModel.value];
    self.minTextLayer.string = minValueText;
    CGSize minTextSize = [self.minTextLayer preferredFrameSize];
    BOOL minDirectionLeft = (minPoint.x + 20 + minTextSize.width) > contentLayer.bounds.size.width;

    self.minTextLayer.frame = CGRectMake((minDirectionLeft ? minPoint.x - 18 - minTextSize.width : minPoint.x + 18),
                                    minPoint.y + 1.5 - minTextSize.height / 2,
                                    minTextSize.width,
                                    minTextSize.height);
    
    // 最大值最小值指示线
    UIBezierPath *maxPath = [self _addLinePath:maxPoint directionLeft:maxDirectionLeft directionTop:YES];
    UIBezierPath *minPath = [self _addLinePath:minPoint directionLeft:minDirectionLeft directionTop:NO];
    [maxPath appendPath:minPath];
    self.minMaxLayer.path = maxPath.CGPath;
    
    [contentLayer addSublayer:self.minMaxLayer];
    self.minMaxLayer.frame = contentLayer.bounds;
    [CATransaction commit];
}

/// 绘制线段
/// - Parameters:
///   - point: 起始点
///   - directionLeft: 左右
///   - directionTop: 上下
- (UIBezierPath *)_addLinePath:(CGPoint)point directionLeft:(BOOL)directionLeft directionTop:(BOOL)directionTop
{
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;

    if (directionTop) { // 上方
        startPoint.y = point.y - 1.5;
        endPoint.y = startPoint.y;
    } else { // 下方
        startPoint.y = point.y + 1.5;
        endPoint.y = startPoint.y;
    }

    if (directionLeft) { // 左侧
        startPoint.x = point.x - 2;
        endPoint.x = startPoint.x - 14;
    } else { // 右侧
        startPoint.x = point.x + 2;
        endPoint.x = startPoint.x + 14;
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path addArcWithCenter:endPoint radius:1 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    return path;
}

#pragma mark - getter/setter

- (CAShapeLayer *)minMaxLayer
{
    if (!_minMaxLayer) {
        _minMaxLayer = [CAShapeLayer layer];
        _minMaxLayer.lineWidth = 0.5;
        _minMaxLayer.fillColor = [UIColor ty_colorWithHexString:@"#333333"].CGColor;
        _minMaxLayer.strokeColor = [UIColor ty_colorWithHexString:@"#333333"].CGColor;
        _minMaxLayer.lineCap = kCALineCapButt;
        _minMaxLayer.lineJoin = kCALineJoinMiter;
    }
    return _minMaxLayer;
}

- (CATextLayer *)maxTextLayer
{
    if (!_maxTextLayer) {
        _maxTextLayer = [CATextLayer layer];
        [self.minMaxLayer addSublayer:_maxTextLayer];
        _maxTextLayer.font = (__bridge CTFontRef)self.data.config.font;
        _maxTextLayer.fontSize = self.data.config.font.pointSize;
        _maxTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _maxTextLayer.alignmentMode = kCAAlignmentNatural;
        _maxTextLayer.foregroundColor = self.data.config.textColor.CGColor;
    }
    return _maxTextLayer;
}

- (CATextLayer *)minTextLayer
{
    if (!_minTextLayer) {
        _minTextLayer = [CATextLayer layer];
        [self.minMaxLayer addSublayer:_minTextLayer];
        _minTextLayer.font = (__bridge CTFontRef)self.data.config.font;
        _minTextLayer.fontSize = self.data.config.font.pointSize;
        _minTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _minTextLayer.alignmentMode = kCAAlignmentNatural;
        _minTextLayer.foregroundColor = self.data.config.textColor.CGColor;
    }
    return _minTextLayer;
}

@end
