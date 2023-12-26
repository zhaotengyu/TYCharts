//
//  TimeLineMinuteModel.h
//  TYCharts
//
//  Created by ty on 2023/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeLineMinuteModel : NSObject

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, copy) NSString *avg_price;
@property (nonatomic, copy) NSString *chg;
@property (nonatomic, copy) NSString *current;
@property (nonatomic, copy) NSString *high;
@property (nonatomic, copy) NSString *kdj;
@property (nonatomic, copy) NSString *low;
@property (nonatomic, copy) NSString *macd;
@property (nonatomic, copy) NSString *percent;
@property (nonatomic, copy) NSString *ratio;
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, assign) NSInteger volume;

//capital =     {
//    large = "-1.86";
//    medium = "-1.88";
//    small = "4.49";
//    xlarge = "-0.75";
//};
//
//"volume_compare" =     {
//    "volume_sum" = 59231302;
//    "volume_sum_last" = 73117540;
//};

@end

NS_ASSUME_NONNULL_END
