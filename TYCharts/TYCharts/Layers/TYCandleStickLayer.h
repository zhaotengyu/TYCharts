//
//  TYCandleStickLayer.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartBaseLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYCandleStickLayer : TYChartBaseLayer

@property (nonatomic, strong) NSArray<TYIndexConfiguration *> *items;

@end

NS_ASSUME_NONNULL_END
