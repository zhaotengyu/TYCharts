//
//  TYTimeIndexChartLayer.h
//  TYCharts
//
//  Created by ty on 2023/10/30.
//

#import "TYChartBaseLayer.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TYTimeLineIndexType) {
    TYTimeLineIndexTypeMinute,
    TYTimeLineIndexType5DMinute
};

@interface TYTimeIndexChartLayer : TYChartBaseLayer

@property (nonatomic, assign) TYTimeLineIndexType timeLineType;

@end

NS_ASSUME_NONNULL_END
