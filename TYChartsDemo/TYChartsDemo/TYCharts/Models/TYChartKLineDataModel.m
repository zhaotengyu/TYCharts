//
//  TYChartKLineDataModel.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartKLineDataModel.h"

@implementation TYChartKLineDataModel

- (TYChartLineTrend)trend
{
    if (self.openPrice.doubleValue > self.closePrice.doubleValue) { // 开盘价大于收盘价
        return TYChartLineTrendDown;
    } else if (self.openPrice.doubleValue < self.closePrice.doubleValue) { // 开盘价小于收盘价
        return TYChartLineTrendUp;
    } else { // 开盘价等于收盘价
        if (self.changing.doubleValue > 0) {
            return TYChartLineTrendUp;
        } else if (self.changing.doubleValue < 0) {
            return TYChartLineTrendDown;
        } else {
            return TYChartLineTrendEqual;
        }
    }
}

- (TYTechnicalIndexModel *)RSIIndexModel
{
    if (!_RSIIndexModel) {
        _RSIIndexModel = [[TYTechnicalIndexModel alloc] init];
    }
    return _RSIIndexModel;
}

- (TYTechnicalIndexModel *)WRIndexModel
{
    if (!_WRIndexModel) {
        _WRIndexModel = [[TYTechnicalIndexModel alloc] init];
    }
    return _WRIndexModel;
}

@end
