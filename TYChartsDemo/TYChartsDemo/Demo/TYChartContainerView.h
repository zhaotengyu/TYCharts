//
//  TYChartContainerView.h
//  TYCharts
//
//  Created by ty on 2023/10/27.
//

#import <UIKit/UIKit.h>
#import "TYCandleStickView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYChartContainerView : UIView

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) TYCandleStickView *mainChartView;

@end

NS_ASSUME_NONNULL_END
