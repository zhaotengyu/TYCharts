//
//  TYYAxisModel.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYYAxisModel.h"

@interface TYYAxisModel ()

@property (nonatomic, strong) NSArray<NSNumber *> *yAxisTexts;
@property (nonatomic, assign) CGFloat maxYAxisValue;
@property (nonatomic, assign) CGFloat minYAxisValue;

@end

@implementation TYYAxisModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineColor = [UIColor ty_colorWithHexString:@"#E8E8E8"];
        self.lineWidth = 0.5;
        self.font = [UIFont systemFontOfSize:10];
        self.textColor = [UIColor ty_colorWithHexString:@"#555555"];
        self.tickInterval = 5;
        self.displayYAxisText = YES;
        self.displayYAxisZeroText = YES;
        self.minValueExtraPrecent = 0.08;
        self.maxValueExtraPrecent = 0.08;
    }
    return self;
}

- (void)calculateMinMax:(CGFloat)minValue maxValue:(CGFloat)maxValue
{
    CGFloat range = maxValue - minValue;
    CGFloat max = maxValue + self.maxValueExtraPrecent * range;
    CGFloat min = minValue - self.minValueExtraPrecent * range;
    
    self.minYAxisValue = min;
    self.maxYAxisValue = max;
    
    CGFloat diffValue = self.maxYAxisValue - self.minYAxisValue;
    if (diffValue == 0) {
        self.yAxisTexts = @[];
        return;
    }

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    CGFloat stepValue = diffValue / (self.tickInterval - 1);

    // 最小值
    [arr addObject:@(self.minYAxisValue)];
    // 中间值
    for (NSInteger index = 1; index < self.tickInterval - 1; index++) {
        CGFloat currentValue = self.minYAxisValue + stepValue * index;
        [arr addObject:@(currentValue)];
    }
    // 最大值
    [arr addObject:@(self.maxYAxisValue)];

    self.yAxisTexts = [arr copy];
}

@end
