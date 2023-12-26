//
//  TYChartDataSource.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartDataSource.h"

@implementation TYChartDataSource

- (TYChartConfiguration *)config
{
    if (!_config) {
        _config = [[TYChartConfiguration alloc] init];
    }
    return _config;
}

- (TYXAxisModel *)xAxis
{
    if (!_xAxis) {
        _xAxis = [[TYXAxisModel alloc] init];
    }
    return _xAxis;
}

- (TYYAxisModel *)yAxis
{
    if (!_yAxis) {
        _yAxis = [[TYYAxisModel alloc] init];
    }
    return _yAxis;
}

@end
