//
//  TYCandleStickView.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TYTechnicalIndexType) {
    TYTechnicalIndexTypeMA,
    TYTechnicalIndexTypeNone
};

@interface TYCandleStickView : TYChartView

@property (nonatomic, strong) NSArray<TYIndexConfiguration *> *maItems;

@end

NS_ASSUME_NONNULL_END
