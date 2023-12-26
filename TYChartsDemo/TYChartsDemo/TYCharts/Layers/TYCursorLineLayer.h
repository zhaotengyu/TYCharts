//
//  TYCursorLineLayer.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartBaseLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYCursorLineLayer : TYChartBaseLayer

@property (nonatomic, assign, readonly) BOOL isShow;

/// 显示十字线
/// - Parameters:
///   - contentLayer: <#contentLayer description#>
///   - point: <#point description#>
- (void)showCursorLine:(NSString *)yAxisText inContentLayer:(CALayer *)contentLayer atPoint:(CGPoint)point;

- (void)showXAxisText:(NSString *)text inContentLayer:(CALayer *)contentLayer atPoint:(CGPoint)point;

/// 隐藏十字线
- (void)hide;

@end

NS_ASSUME_NONNULL_END
