//
//  NSArray+Filter.h
//  SNBCharts
//
//  Created by ty on 2023/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Filter)

- (NSMutableArray *)filterObjectsMatchingPredicate:(BOOL (^)(id object))filterBlock;

- (BOOL)removeObjectsMatchingPredicate:(BOOL (^)(id object))filterBlock;

@end

NS_ASSUME_NONNULL_END
