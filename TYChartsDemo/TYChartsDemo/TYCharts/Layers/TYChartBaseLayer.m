//
//  TYChartBaseLayer.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartBaseLayer.h"

@interface TYChartBaseLayer ()

@property (nonatomic, strong) TYChartDataSource *data;

@end

@implementation TYChartBaseLayer

+ (instancetype)layerWithDataSource:(TYChartDataSource *)data
{
    TYChartBaseLayer *layer = [[self alloc] init];
    layer.data = data;
    return layer;
}

- (void)drawChart:(CALayer *)contentLayer
{
    if (!self.data) {
        return;
    }
}

- (CGFloat)transformCoordinateWithCurrentValue:(CGFloat)currentValue bounds:(CGRect)bounds
{
    CGFloat minAxisValue = self.data.yAxis.minYAxisValue;
    CGFloat maxAxisValue = self.data.yAxis.maxYAxisValue;
    
    CGFloat maxHeight = TYGetChartMaxHeight(bounds);
    CGFloat heightRate = maxAxisValue == minAxisValue ? 0 : (maxHeight) / (maxAxisValue - minAxisValue);
    CGFloat value = maxHeight - (currentValue - minAxisValue) * heightRate;
    return value;
}

@end
