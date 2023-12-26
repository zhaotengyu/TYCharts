//
//  TYChartAlgorithm.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartAlgorithm.h"

@implementation TYChartAlgorithm

/// 计算成交额、成交量均值
/// - Parameters:
///   - indicatorType: 成交额、成交量
///   - maItems: 均值参数
///   - models: 数据源
+ (void)calculateMAWithIndicatorType:(TYChartIndicatorType)indicatorType
                             MAItems:(NSArray<TYIndexConfiguration *> *)maItems
                               model:(NSArray<TYChartKLineDataModel *> *)models
{
    models = [[models reverseObjectEnumerator] allObjects];
    [models enumerateObjectsUsingBlock:^(TYChartKLineDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TYTechnicalIndexModel *MAIndexModel = [[TYTechnicalIndexModel alloc] init];

        for (TYIndexConfiguration *item in maItems) {
            NSInteger day = [item.day integerValue];
            CGFloat maValue = CGFLOAT_MIN;
            if (idx >= (day - 1)) {
                maValue = [self _calculateAverageValueWithChartType:indicatorType totalDay:day endIndex:idx datas:models];
            }
            [MAIndexModel.indexDict setObject:[NSNumber numberWithDouble:maValue] forKey:item.title];
        }

        if (indicatorType == TYChartIndicatorTypeAmount) {
            obj.amountMAIndexModel = MAIndexModel;
        } else if (indicatorType == TYChartIndicatorTypeVolume) {
            obj.volumeMAIndexModel = MAIndexModel;
        }
    }];
}

/**
 RSV(n)=（今日收盘价－n日内最低价）÷（n日内最高价－n日内最低价）× 100
 K(n)=（当日RSV值 + 前一日K值）÷ n
 D(n)=（当日K值 + 前一日D值）÷ n
 J = 3K－2D
 */
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
{
    models = [[models reverseObjectEnumerator] allObjects];
    
    CGFloat k = 0.0;
    CGFloat d = 0.0;
    CGFloat j = 0.0;
    CGFloat rsv = 0.0;

    for (NSInteger index = 0; index < models.count; index ++) {
        TYChartKLineDataModel *model = models[index];

        CGFloat maxValue = CGFLOAT_MIN;
        CGFloat minValue = CGFLOAT_MAX;

        NSInteger startIndex = index - kDayTime + 1;
        if (startIndex < 0) { startIndex = 0; }
        for (NSInteger i = startIndex; i <= index; i++) {
            TYChartKLineDataModel *rsvModel = models[i];
            maxValue = MAX(maxValue, rsvModel.highPrice.doubleValue);
            minValue = MIN(minValue, rsvModel.lowPrice.doubleValue);
        }

        if (maxValue - minValue != 0) {
            rsv = 100.0 * (model.closePrice.doubleValue - minValue) / (maxValue - minValue);
        } else {
            rsv = 0.0;
        }

        if (index == 0) {
            k = 100;
            d = 100;
        } else {
            k = ((2.0 * k) + rsv) / dDayTime;
            d = ((2.0 * d) + k) / jDayTime;
        }

        j = 3.0 * k - 2.0 * d;

        TYTechnicalIndexModel *kdjModel = [[TYTechnicalIndexModel alloc] init];
        [kdjModel.indexDict setObject:[NSNumber numberWithDouble:k] forKey:@"K"];
        [kdjModel.indexDict setObject:[NSNumber numberWithDouble:d] forKey:@"D"];
        [kdjModel.indexDict setObject:[NSNumber numberWithDouble:j] forKey:@"J"];
        model.KDJIndexModel = kdjModel;
    }
}

/**
 A(n) n个周期中所有收盘价上涨数之和 / n    n参数：周期数    n是用户自定义参数  6,12,24
 B(n) = n个周期中所有收盘价下跌数之和 / n (取绝对值)
 RSI(n) = A(n) /(A(n) + B(n)) * 100
 RSI(N) = SMA(MAX(Close-LastClose,0) , N, 1) / SMA( ABS(Close-LastClose), N ,1) * 100
 */
/// 计算RSI指标
/// - Parameters:
///   - dayTime: 周期
///   - models: 数据源
+ (void)calculateRSIWithDayTime:(NSInteger)dayTime
                          model:(NSArray<TYChartKLineDataModel *> *)models
{
    models = [[models reverseObjectEnumerator] allObjects];
    
    CGFloat lastGain = 0.0;
    CGFloat lastLoss = 0.0;
    CGFloat rsiValue = 0.0;
    
    for (NSInteger index = 0; index < models.count; index++) {
        TYChartKLineDataModel *currentModel = models[index];
        TYChartKLineDataModel *lastModel = index == 0 ? models[index] : models[index - 1];
        
        // 收盘价涨幅
        CGFloat gain = MAX(0.0, currentModel.closePrice.doubleValue - lastModel.closePrice.doubleValue);
        // 收盘价跌幅
        CGFloat loss = ABS(currentModel.closePrice.doubleValue - lastModel.closePrice.doubleValue);
        
        lastGain = (gain + (dayTime - 1.0) * lastGain) / dayTime;
        lastLoss = (loss + (dayTime - 1.0) * lastLoss) / dayTime;
        rsiValue = (lastLoss == 0) ? 0.0 : (lastGain / lastLoss) * 100.0;
        
        TYTechnicalIndexModel *indexModel = currentModel.RSIIndexModel;
        [indexModel.indexDict setObject:[NSNumber numberWithDouble:rsiValue] forKey:[NSString stringWithFormat:@"RSI%ld", (long)dayTime]];
    }
}

/**
 WR（n日）=（Hn — C）÷（Hn — Ln）× 100
 C 为第n日收盘价
 Hn为n天内最高价
 Ln为14天内最低价
 */
/// 计算WR指标
/// - Parameters:
///   - dayTime: 周期
///   - models: 数据源
+ (void)calculateWRWithDayTime:(NSInteger)dayTime
                         model:(NSArray<TYChartKLineDataModel *> *)models
{
    models = [[models reverseObjectEnumerator] allObjects];

    CGFloat wrValue = CGFLOAT_MIN;
    for (NSInteger index = 0; index < models.count; index++) {

        TYChartKLineDataModel *currentModel = models[index];
        
        if (index >= (dayTime - 1)) {
            CGFloat max = CGFLOAT_MIN;
            CGFloat min = CGFLOAT_MAX;
  
            for (NSInteger j = (index - dayTime + 1); j <= index; j++) {
                TYChartKLineDataModel *model = models[j];
                max = MAX(max, model.highPrice.doubleValue);
                min = MIN(min, model.lowPrice.doubleValue);
            }

            wrValue = (max - currentModel.closePrice.doubleValue) / (max - min) * 100;
        }
        TYTechnicalIndexModel *indexModel = currentModel.WRIndexModel;
        [indexModel.indexDict setObject:[NSNumber numberWithDouble:wrValue] forKey:[NSString stringWithFormat:@"WR%ld", (long)dayTime]];
    }
}

/// 计算平均值
/// - Parameters:
///   - count: <#count description#>
///   - endIndex: <#endIndex description#>
///   - datas: <#datas description#>
+ (CGFloat)_calculateAverageValueWithChartType:(TYChartIndicatorType)indicatorType
                                      totalDay:(NSInteger)day
                                      endIndex:(NSInteger)endIndex
                                         datas:(NSArray *)datas
{
    CGFloat result = 0;
    if (endIndex < (day - 1)) {
        return result;
    }
    
    CGFloat sum = 0.0;
    NSInteger i = endIndex;
    while (i > (endIndex - day)) {
        TYChartKLineDataModel *itemModel = datas[i];
        CGFloat value = 0;
        if (indicatorType == TYChartIndicatorTypeAmount) {
            value = itemModel.amount.doubleValue;
        } else {
            value = itemModel.volume.doubleValue;
        }
        sum += value;
        i -= 1;
    }
    
    result = sum / day;
    
    return result;
}

@end
