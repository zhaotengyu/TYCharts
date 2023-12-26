//
//  TYChartView.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <UIKit/UIKit.h>
#import "TYChartConst.h"
#import "TYChartDataSource.h"
#import "TYAxisChartLayer.h"
#import "TYCursorLineLayer.h"

NS_ASSUME_NONNULL_BEGIN

/// 移动方向
typedef NS_ENUM(NSInteger, TYMoveChartDirection) {
    TYMoveChartDirectionLeft,
    TYMoveChartDirectionRight
};

@class TYChartView, TYChartLineBaseModel;

@protocol TYChartViewDataSource <NSObject>

@required
/// 数据源
/// - Parameter chartView: <#chartView description#>
- (TYChartDataSource *)chartViewDataSource:(TYChartView *)chartView;

@end

@protocol TYChartViewDelegate <NSObject>

@optional

/// 展示指标数据
/// - Parameters:
///   - chartView: <#chartView description#>
///   - text: <#text description#>
- (void)chartView:(TYChartView *)chartView displayIndexText:(NSAttributedString *)attributedText;

/// 放大、缩小图表
/// - Parameters:
///   - chartView: <#chartView description#>
///   - candleWidth: <#candleWidth description#>
- (void)chartView:(TYChartView *)chartView zoomChartByCandleWidth:(CGFloat)candleWidth;

- (void)chartViewLoadMoreData:(TYChartView *)chartView withDate:(NSDate *)date;

/// 点击图表
/// - Parameter chartView: <#chartView description#>
- (void)didClickChartView:(TYChartView *)chartView;

@end

@interface TYChartView : UIView

- (instancetype)initWithChartLineType:(TYChartLineType)chartLineType;

@property (nonatomic, weak) id<TYChartViewDelegate> delegate;
@property (nonatomic, weak) id<TYChartViewDataSource> dataSource;

@property (nonatomic, strong, readonly) UIView *separatoreView;
@property (nonatomic, strong, readonly) UIScrollView *mainScrollView;
@property (nonatomic, strong, readonly) UIView *mainChartView;
@property (nonatomic, strong, readonly) UIView *axisChartView;
@property (nonatomic, strong, readonly) TYAxisChartLayer *axisLayer;
@property (nonatomic, strong, readonly) TYCursorLineLayer *cursorLineLayer;

/// 数据源
@property (nonatomic, strong) TYChartDataSource *data;
/// 图标类型
@property (nonatomic, assign) TYChartLineType chartLineType;
/// 指标类型
@property (nonatomic, assign) TYChartIndicatorType indicatorType;

#pragma mark - 子类实现

/// 初始化
- (void)prepare;

- (void)loadDefault;

/// 绘制图表
- (void)updateChart;

/// 计算坐标点等数据
- (void)updateAllDataPoint;

/// 更新Y轴数据
- (void)updateYAxisData;

/// 配置指标数据
- (void)updateTechnicalIndexData;

/// 更新选中数据文字
/// - Parameter index: <#index description#>
- (void)updateIndexText:(NSInteger)index;

#pragma mark - Public

/// 更新图表
- (void)drawChart;

/// 放大、缩小图表
/// - Parameter isEnlarge: <#isEnlarge description#>
- (void)zoomChartWithEnlarge:(BOOL)isEnlarge;

/// 滚动图表
/// - Parameter direction: 方向
- (void)moveCharWithDirection:(TYMoveChartDirection)direction;

#pragma mark - 图表联动

+ (void)addReactChains:(NSArray<TYChartView *> *)chartViews;

@end

NS_ASSUME_NONNULL_END
