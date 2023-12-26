//
//  TYLongPressButton.h
//  TYKLineCharts
//
//  Created by ty on 2023/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern const UIControlEvents UIControlEventLongPress;

@interface TYLongPressButton : UIButton

@property (nonatomic, assign) CGFloat longPressInterval;

@property (nonatomic, assign, getter=shouldLongPressCancelOtherEvents) BOOL longPressCancelsOtherEvents;

@end

NS_ASSUME_NONNULL_END
