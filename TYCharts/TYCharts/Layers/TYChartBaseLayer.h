//
//  TYChartBaseLayer.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <Foundation/Foundation.h>
#import "TYChartDataSource.h"
#import "TYChartKLineDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYChartBaseLayer : NSObject

+ (instancetype)layerWithDataSource:(TYChartDataSource *)data;

@property (nonatomic, strong, readonly) TYChartDataSource *data;

- (void)drawChart:(CALayer *)contentLayer;

- (CGFloat)transformCoordinateWithCurrentValue:(CGFloat)currentValue bounds:(CGRect)bounds;

@end

NS_ASSUME_NONNULL_END
