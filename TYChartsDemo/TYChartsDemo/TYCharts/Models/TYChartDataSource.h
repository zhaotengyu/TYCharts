//
//  TYChartDataSource.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <Foundation/Foundation.h>
#import "TYChartKLineDataModel.h"
#import "TYChartConfiguration.h"
#import "TYIndexConfiguration.h"
#import "TYChartMaxMinModel.h"
#import "TYXAxisModel.h"
#import "TYYAxisModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYChartDataSource : NSObject

/// 是否还有更多数据
@property (nonatomic, assign) BOOL haveMoreData;

/// 数据源
@property (nonatomic, strong) NSArray<TYChartKLineDataModel *> *models;
/// 图表样式
@property (nonatomic, strong) TYChartConfiguration *config;
/// x轴
@property (nonatomic, strong) TYXAxisModel *xAxis;
/// y轴
@property (nonatomic, strong) TYYAxisModel *yAxis;

/// 主图均线配置数组
@property (nonatomic, strong) NSArray<TYIndexConfiguration *> *candleMAItems;

@property (nonatomic, strong) NSArray<TYIndexConfiguration *> *KDJItems;

@property (nonatomic, strong) NSArray<TYIndexConfiguration *> *RSIItems;

@property (nonatomic, strong) NSArray<TYIndexConfiguration *> *WRItems;

@property (nonatomic, strong) TYChartMaxMinModel *maxModel;

@property (nonatomic, strong) TYChartMaxMinModel *minModel;

@end

NS_ASSUME_NONNULL_END
