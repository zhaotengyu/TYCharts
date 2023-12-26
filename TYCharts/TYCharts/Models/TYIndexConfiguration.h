//
//  TYIndexConfiguration.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYIndexConfiguration : NSObject

@property (nonatomic, strong) id day;
/// 指标文案
@property (nonatomic, strong) NSString *title;
/// 指标的颜色
@property (nonatomic, strong) UIColor *strokeColor;

@end

NS_ASSUME_NONNULL_END
