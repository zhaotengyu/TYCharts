//
//  TYChartConfiguration.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartConfiguration.h"

@implementation TYChartConfiguration

- (instancetype)init
{
    if (self = [super init]) {
        
        self.lineWidth = 1;
        self.candleWidth = 4;
        self.candleSpacing = 1;
        
        self.upColor = [UIColor ty_colorWithHexString:@"#F54346"];
        self.downColor = [UIColor ty_colorWithHexString:@"#14BB71"];
        
        self.font = [UIFont systemFontOfSize:10];
        self.textColor = [UIColor ty_colorWithHexString:@"#555555"];
        
        self.chartContentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        
        self.chartMainSize = CGSizeZero;
    }
    return self;
}

- (CGFloat)plotWidth
{
    return self.lineWidth + self.candleWidth + self.candleSpacing;
}

@end
