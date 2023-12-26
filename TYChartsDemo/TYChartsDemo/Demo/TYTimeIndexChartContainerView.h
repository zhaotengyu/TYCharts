//
//  TYTimeIndexChartContainerView.h
//  TYCharts
//
//  Created by ty on 2023/10/31.
//

#import <UIKit/UIKit.h>
#import "TYTimeIndexChartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYTimeIndexChartContainerView : UIView

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) TYTimeIndexChartView *mainChartView;

@end

NS_ASSUME_NONNULL_END
