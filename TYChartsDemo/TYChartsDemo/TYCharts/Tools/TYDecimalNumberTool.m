//
//  TYDecimalNumberTool.m
//  TYCharts
//
//  Created by ty on 2023/10/27.
//

#import <UIKit/UIKit.h>
#import "TYDecimalNumberTool.h"

@implementation TYDecimalNumberTool

+ (NSString *)convertDecimalsToString:(double)value
{
    if (value == CGFLOAT_MIN) {
        return @"--";
    }
    NSString *sign = value >= 0 ? @"" : @"-";
    value = fabs(value);
    if (value >= 1000000000000) {
        value = value / 1000000000000;
        NSString *result = [self keepDoubleOfValue:value scale:2];
        return [NSString stringWithFormat:@"%@%@万亿", sign, result];
    } else if (value >= 100000000) { // 亿
        value = value / 100000000;
        NSString *result = [self keepDoubleOfValue:value scale:2];
        return [NSString stringWithFormat:@"%@%@亿", sign, result];
    } else if (value >= 100000) { // 万
        value = value / 10000;
        NSString *result = [self keepDoubleOfValue:value scale:2];
        return [NSString stringWithFormat:@"%@%@万", sign, result];
    } else {
        NSString *result = [self keepDoubleOfValue:value scale:2];
        return result;
    }
}

// 保留指定位数的小数
+ (NSString *)keepDoubleOfValue:(double)value scale:(NSInteger)scale
{
    NSDecimalNumber *valueNum = [NSDecimalNumber decimalNumberWithString:[@(value) description]];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.usesGroupingSeparator = NO;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = scale;
    formatter.zeroSymbol = @"0.00";
    return [formatter stringFromNumber:valueNum];
}

@end
