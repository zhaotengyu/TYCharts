//
//  NSArray+Filter.m
//  SNBCharts
//
//  Created by ty on 2023/7/17.
//

#import "NSArray+Filter.h"

@implementation NSArray (Filter)

- (NSMutableArray *)filterObjectsMatchingPredicate:(BOOL (^)(id object))filterBlock {
    NSMutableArray *filteredArray = [NSMutableArray new];
    for (id item in self) {
        if (filterBlock(item)) {
            [filteredArray addObject:item];
        }
    }
    return filteredArray;
}

- (BOOL)removeObjectsMatchingPredicate:(BOOL (^)(id object))filterBlock {
    if (![self respondsToSelector:@selector(removeObject:)]) {
        return NO;
    }
    NSMutableArray *mutableSelf = (NSMutableArray *)self;
    NSMutableArray *filteredArray = [self filterObjectsMatchingPredicate:filterBlock];
    for (id obj in filteredArray) {
        [mutableSelf removeObject:obj];
    }
    return YES;
}

@end
