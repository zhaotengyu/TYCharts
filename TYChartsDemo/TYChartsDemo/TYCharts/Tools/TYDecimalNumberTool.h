//
//  TYDecimalNumberTool.h
//  TYCharts
//
//  Created by ty on 2023/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYDecimalNumberTool : NSObject

+ (NSString *)convertDecimalsToString:(double)value;

+ (NSString *)keepDoubleOfValue:(double)value scale:(NSInteger)scale;

@end

NS_ASSUME_NONNULL_END
