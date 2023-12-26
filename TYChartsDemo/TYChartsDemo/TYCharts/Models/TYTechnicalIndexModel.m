//
//  TYTechnicalIndexModel.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYTechnicalIndexModel.h"

@implementation TYTechnicalIndexModel

- (CGFloat)maxValue
{
    __block CGFloat maxValue = CGFLOAT_MIN;
    [self.indexDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.doubleValue != CGFLOAT_MIN) {
            maxValue = MAX(maxValue, obj.doubleValue);
        }
    }];
    return maxValue;
}

- (CGFloat)minValue
{
    __block CGFloat minValue = CGFLOAT_MAX;
    [self.indexDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.doubleValue != CGFLOAT_MIN) {
            minValue = MIN(minValue, obj.doubleValue);
        }
    }];
    return minValue;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)indexDict
{
    if (!_indexDict) {
        _indexDict = [[NSMutableDictionary alloc] init];
    }
    return _indexDict;
}

@end
