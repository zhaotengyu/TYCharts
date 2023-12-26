//
//  TYTechnicalIndexModel.h
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYTechnicalIndexModel : NSObject

@property (nonatomic, assign, readonly) CGFloat maxValue;
@property (nonatomic, assign, readonly) CGFloat minValue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *indexDict;

@end

NS_ASSUME_NONNULL_END
