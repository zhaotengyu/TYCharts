//
//  TYXAxisModel.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYXAxisModel : NSObject

/// 可见区域开始下标
@property (nonatomic, assign) NSInteger startIndex;
/// 可见区域结束下标
@property (nonatomic, assign) NSInteger endIndex;

@end

NS_ASSUME_NONNULL_END
