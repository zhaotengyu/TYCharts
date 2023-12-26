//
//  TYChartAlgorithm.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <Foundation/Foundation.h>
#import "TYIndexConfiguration.h"
#import "TYChartKLineDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYChartAlgorithm : NSObject

/// 计算成交额、成交量均值
/// - Parameters:
///   - indicatorType: 成交额、成交量
///   - maItems: 均值参数
///   - models: 数据源
+ (void)calculateMAWithIndicatorType:(TYChartIndicatorType)indicatorType
                             MAItems:(NSArray<TYIndexConfiguration *> *)maItems
                               model:(NSArray<TYChartKLineDataModel *> *)models;

/// 计算KDJ指标
/// - Parameters:
///   - kDayTime: k时间周期
///   - dDayTime: d时间周期
///   - jDayTime: j时间周期
///   - models: 数据源
+ (void)calculateKDJWithKDayTime:(NSInteger)kDayTime
                        dDayTime:(NSInteger)dDayTime
                        jDayTime:(NSInteger)jDayTime
                           model:(NSArray<TYChartKLineDataModel *> *)models;

/// 计算RSI指标
/// - Parameters:
///   - dayTime: 周期
///   - models: 数据源
+ (void)calculateRSIWithDayTime:(NSInteger)dayTime
                          model:(NSArray<TYChartKLineDataModel *> *)models;

/// 计算WR指标
/// - Parameters:
///   - dayTime: 周期
///   - models: 数据源
+ (void)calculateWRWithDayTime:(NSInteger)dayTime
                         model:(NSArray<TYChartKLineDataModel *> *)models;

@end

NS_ASSUME_NONNULL_END
