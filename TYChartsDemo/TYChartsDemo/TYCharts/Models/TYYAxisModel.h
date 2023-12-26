//
//  TYYAxisModel.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYYAxisModel : NSObject

/// 网格颜色
@property (nonatomic, strong) UIColor *lineColor;
/// 网格线宽
@property (nonatomic, assign) CGFloat lineWidth;
/// y轴字体
@property (nonatomic, strong) UIFont *font;
/// y轴字体颜色
@property (nonatomic, strong) UIColor *textColor;
/// Y轴间隔数
@property (nonatomic, assign) NSInteger tickInterval;
/// 是否显示y轴坐标
@property (nonatomic, assign) BOOL displayYAxisText;
/// 是否显示y轴圆点坐标
@property (nonatomic, assign) BOOL displayYAxisZeroText;
/// 下间距
@property (nonatomic, assign) CGFloat minValueExtraPrecent;
/// 上间距
@property (nonatomic, assign) CGFloat maxValueExtraPrecent;

/// y轴展示数据
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *yAxisTexts;
/// Y轴最大值
@property (nonatomic, assign, readonly) CGFloat maxYAxisValue;
/// Y轴最小值
@property (nonatomic, assign, readonly) CGFloat minYAxisValue;

- (void)calculateMinMax:(CGFloat)minValue maxValue:(CGFloat)maxValue;

@end

NS_ASSUME_NONNULL_END
