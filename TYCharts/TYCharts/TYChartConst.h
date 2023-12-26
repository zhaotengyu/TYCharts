#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

// 弱引用
#define TYWeakSelf __weak typeof(self) weakSelf = self;

// RGB颜色
#define TYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define TYGetChartMaxHeight(frame) (CGRectGetHeight(frame) - 0.5)

/// 分时点个数
UIKIT_EXTERN const CGFloat TYChartTimeLinePointCount;
/// 5日分时点个数
UIKIT_EXTERN const CGFloat TYChart5DTimeLinePointCount;
/// k先加载条数
UIKIT_EXTERN const CGFloat TYChartKLineTotalCount;


typedef NS_ENUM(NSInteger, TYChartLineType) {
    TYChartLineTypeKLine,
    TYChartLineTypeTimeLine,
    TYChartLineType5DTimeLine,
};

typedef NS_ENUM(NSInteger, TYChartIndicatorType) {
    TYChartIndicatorTypeVolume,
    TYChartIndicatorTypeAmount,
    TYChartIndicatorTypeKDJ,
    TYChartIndicatorTypeRSI,
    TYChartIndicatorTypeWR,
};

typedef NS_ENUM(NSInteger, TYChartCandleStickType) {
    TYChartCandleStickTypeDay,
    TYChartCandleStickTypeWeek,
    TYChartCandleStickTypeMonth,
    TYChartCandleStickTypeQuarter,
    TYChartCandleStickTypeYear,
    TYChartCandleStickTypeMinute,
};
