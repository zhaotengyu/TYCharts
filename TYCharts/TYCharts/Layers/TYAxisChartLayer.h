//
//  TYAxisChartLayer.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartBaseLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYAxisChartLayer : TYChartBaseLayer

/// 绘制y轴分割线
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawYAxisGridLine:(CALayer *)contentLayer;

/// 绘制y轴价格
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawYAxisTickIntervalPrices:(CALayer *)contentLayer;

/// 绘制x轴分割线
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawXAxisGridLine:(CALayer *)contentLayer;

/// 月份
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawDateTextLayer:(CALayer *)contentLayer;

/// 绘制分时y轴数据
/// - Parameter contentLayer: <#contentLayer description#>
- (void)drawTimeLineYAxisTextLayer:(CALayer *)contentLayer;

@end

NS_ASSUME_NONNULL_END
