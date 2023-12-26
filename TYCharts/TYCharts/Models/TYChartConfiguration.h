//
//  TYChartConfiguration.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYChartConfiguration : NSObject

/// 柱体宽度
@property (nonatomic, assign) CGFloat candleWidth;
/// 柱体间距
@property (nonatomic, assign) CGFloat candleSpacing;
/// 线宽
@property (nonatomic, assign) CGFloat lineWidth;
/// 上涨颜色
@property (nonatomic, strong) UIColor *upColor;
/// 下跌颜色
@property (nonatomic, strong) UIColor *downColor;
/// 图表上下左右间距
@property (nonatomic, assign) UIEdgeInsets chartContentEdgeInsets;

@property (nonatomic, assign) CGSize chartMainSize;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) CGPoint contentOffset;

/// 整体宽度（线宽+柱体+间距）
@property (nonatomic, assign, readonly) CGFloat plotWidth;

@end

NS_ASSUME_NONNULL_END
