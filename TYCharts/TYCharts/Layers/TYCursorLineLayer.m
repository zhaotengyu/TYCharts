//
//  TYCursorLineLayer.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYCursorLineLayer.h"

@interface TYCursorLineLayer ()

@property (nonatomic, strong) CAShapeLayer *cursorLineLayer;
@property (nonatomic, strong) CATextLayer *yAxisTextLayer;
@property (nonatomic, strong) CATextLayer *xAxisTextLayer;
@property (nonatomic, assign) BOOL isShow;

@end

@implementation TYCursorLineLayer

/// 显示十字线
/// - Parameters:
///   - contentLayer: <#contentLayer description#>
///   - point: <#point description#>
- (void)showCursorLine:(NSString *)yAxisText inContentLayer:(CALayer *)contentLayer atPoint:(CGPoint)point
{
    if (!self.isShow) {
        self.isShow = YES;
    }
    
    CGFloat topY = 0;
    CGFloat bottomY = contentLayer.ty_height;
    CGFloat leftX = 0;
    CGFloat rightX = contentLayer.ty_width;
    
    // 竖线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(point.x, topY)];
    [path addLineToPoint:CGPointMake(point.x, bottomY)];

    // 横线
    [path moveToPoint:CGPointMake(leftX, point.y)];
    [path addLineToPoint:CGPointMake(rightX, point.y)];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.cursorLineLayer.path = path.CGPath;
    [contentLayer addSublayer:self.cursorLineLayer];
    self.cursorLineLayer.frame = contentLayer.bounds;
    [CATransaction commit];
    
    [self showYAxisText:yAxisText inContentLayer:contentLayer atPoint:point];
}

/// 隐藏十字线
- (void)hide
{
    self.isShow = NO;
    [self.cursorLineLayer removeFromSuperlayer];
    [self.yAxisTextLayer removeFromSuperlayer];
    [self.xAxisTextLayer removeFromSuperlayer];
}

/// 更新y轴上标签文字、位置
/// - Parameters:
///   - text: 标签文字
///   - point: 位置
- (void)showYAxisText:(NSString *)text inContentLayer:(CALayer *)contentLayer atPoint:(CGPoint)point
{
    if (point.y < 0 || point.y > CGRectGetMaxY(contentLayer.bounds)) {
        self.yAxisTextLayer.hidden = YES;
        return;
    } else {
        self.yAxisTextLayer.hidden = NO;
    }
    
    NSString *yAxisText = [NSString stringWithFormat:@"%@", text];

    self.yAxisTextLayer.string = yAxisText;
    CGSize yTextSize = [self.yAxisTextLayer preferredFrameSize];
    yTextSize = CGSizeMake(yTextSize.width + 3, 13);

    CGFloat textX = point.x < contentLayer.ty_width / 4 ? contentLayer.ty_width - yTextSize.width : 0;
    
    CGFloat textY = 0;
    if ((point.y - yTextSize.height * 0.5) < 0) {
        textY = 0;
    } else if ((point.y - yTextSize.height * 0.5) > (CGRectGetMaxY(self.cursorLineLayer.frame) - yTextSize.height)) {
        textY = (CGRectGetMaxY(self.cursorLineLayer.frame) - yTextSize.height);
    } else {
        textY = (point.y - yTextSize.height * 0.5);
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.yAxisTextLayer.frame = CGRectMake(textX, textY, yTextSize.width, yTextSize.height);
    [contentLayer addSublayer:self.yAxisTextLayer];
    [CATransaction commit];
}

- (void)showXAxisText:(NSString *)text inContentLayer:(CALayer *)contentLayer atPoint:(CGPoint)point
{
    // x轴上标签
    self.xAxisTextLayer.string = text;
    CGSize xTextSize = [self.xAxisTextLayer preferredFrameSize];
    
    CGFloat textX = (point.x - xTextSize.width / 2);
    if (point.x < xTextSize.width / 2) {
        textX = 0;
    } else if (point.x > contentLayer.ty_width - xTextSize.width / 2) {
        textX = contentLayer.ty_width - xTextSize.width;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.xAxisTextLayer.frame = CGRectMake(textX, CGRectGetMaxY(contentLayer.bounds), xTextSize.width, xTextSize.height);
    [contentLayer addSublayer:self.xAxisTextLayer];
    [CATransaction commit];
}

#pragma mark - getter/setter

- (CAShapeLayer *)cursorLineLayer
{
    if (!_cursorLineLayer) {
        _cursorLineLayer = [CAShapeLayer layer];
        _cursorLineLayer.strokeColor = [UIColor ty_colorWithHexString:@"#555555"].CGColor;
        _cursorLineLayer.lineWidth = 0.5;
        _cursorLineLayer.fillColor = UIColor.clearColor.CGColor;
        _cursorLineLayer.lineCap = kCALineCapButt;
        _cursorLineLayer.lineJoin = kCALineJoinMiter;
        _cursorLineLayer.masksToBounds = YES;
    }
    return _cursorLineLayer;
}

- (CATextLayer *)yAxisTextLayer
{
    if (!_yAxisTextLayer) {
        _yAxisTextLayer = [CATextLayer layer];
        _yAxisTextLayer.font = (__bridge CFTypeRef _Nullable)([UIFont DinMediumFontWithSize:10]);
        _yAxisTextLayer.fontSize = [UIFont DinMediumFontWithSize:10].pointSize;
        _yAxisTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _yAxisTextLayer.alignmentMode = kCAAlignmentCenter;
        _yAxisTextLayer.foregroundColor = [UIColor ty_colorWithHexString:@"#0083FF"].CGColor;
        _yAxisTextLayer.backgroundColor = [UIColor ty_colorWithHexString:@"#E8E8E8"].CGColor;
    }
    return _yAxisTextLayer;
}

- (CATextLayer *)xAxisTextLayer
{
    if (!_xAxisTextLayer) {
        _xAxisTextLayer = [CATextLayer layer];
        _xAxisTextLayer.font = (__bridge CFTypeRef _Nullable)([UIFont DinMediumFontWithSize:10]);
        _xAxisTextLayer.fontSize = [UIFont DinMediumFontWithSize:10].pointSize;
        _xAxisTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _xAxisTextLayer.alignmentMode = kCAAlignmentCenter;
        _xAxisTextLayer.foregroundColor = [UIColor ty_colorWithHexString:@"#0083FF"].CGColor;
        _xAxisTextLayer.backgroundColor = [UIColor ty_colorWithHexString:@"#E8E8E8"].CGColor;
    }
    return _xAxisTextLayer;
}

@end
