//
//  TYChartKLineDataModel.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartLineBaseModel.h"
#import "TYTechnicalIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 股票涨跌
typedef NS_ENUM(NSInteger, TYChartLineTrend) {
    TYChartLineTrendUp,
    TYChartLineTrendDown,
    TYChartLineTrendEqual
};

@interface TYChartKLineDataModel : TYChartLineBaseModel

/// 最高价
@property (nonatomic, strong) NSNumber *highPrice;
/// 最低价
@property (nonatomic, strong) NSNumber *lowPrice;
/// 开盘价
@property (nonatomic, strong) NSNumber *openPrice;
/// 收盘价
@property (nonatomic, strong) NSNumber *closePrice;
/// 昨收价
@property (nonatomic, strong) NSNumber *yClosePrice;
/// 成交量
@property (nonatomic, strong) NSNumber *volume;
/// 成交额
@property (nonatomic, strong) NSNumber *amount;
/// 涨跌幅度百分比
@property (nonatomic, strong) NSNumber *percent;
/// 涨跌额
@property (nonatomic, strong) NSNumber *changing;
/// 换手率
@property (nonatomic, strong) NSNumber *turnoverrate;
/// 均价
@property (nonatomic, strong) NSNumber *avg_price;
/// 最新价
@property (nonatomic, strong) NSNumber *current;
/// 时间
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign) BOOL displayMonthLine;

/// 涨跌走势
@property (nonatomic, assign, readonly) TYChartLineTrend trend;

@property (nonatomic, strong) TYTechnicalIndexModel *MAIndexModel;
@property (nonatomic, strong) TYTechnicalIndexModel *volumeMAIndexModel;
@property (nonatomic, strong) TYTechnicalIndexModel *amountMAIndexModel;
@property (nonatomic, strong) TYTechnicalIndexModel *KDJIndexModel;
@property (nonatomic, strong) TYTechnicalIndexModel *RSIIndexModel;
@property (nonatomic, strong) TYTechnicalIndexModel *WRIndexModel;

@end

NS_ASSUME_NONNULL_END
