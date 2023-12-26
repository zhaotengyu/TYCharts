//
//  TYChartLineBaseModel.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TYChartType) {
    TYChartTypeCandle,
    TYChartTypeVolume,
    TYChartTypeAmount,
    TYChartTypeKDJ,
    TYChartTypeRSI,
    TYChartTypeWR,
    TYChartTypeTimeLine
};

@interface TYChartLineBaseModel : NSObject

@property (nonatomic, assign) CGFloat pointX;

@end

NS_ASSUME_NONNULL_END
