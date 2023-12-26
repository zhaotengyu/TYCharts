//
//  TYChartHandOperationView.h
//  TYKLineCharts
//
//  Created by ty on 2023/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TYChartHandOperationView;

typedef NS_ENUM(NSInteger, TYOperationType) {
    TYOperationTypeLeft,
    TYOperationTypeRight,
    TYOperationTypeReduce,
    TYOperationTypeEnlarge,
};

@protocol TYChartHandOperationViewDelegate <NSObject>

- (void)chartHandOperationView:(TYChartHandOperationView *)view didClickOperationType:(TYOperationType)type;

@end

@interface TYChartHandOperationView : UIView

@property (nonatomic, assign) id<TYChartHandOperationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
