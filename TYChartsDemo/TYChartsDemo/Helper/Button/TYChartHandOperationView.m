//
//  TYChartHandOperationView.m
//  TYKLineCharts
//
//  Created by ty on 2023/8/7.
//

#import "TYChartHandOperationView.h"
#import "TYLongPressButton.h"
#import "Masonry.h"

@interface TYChartHandOperationView ()

@property (nonatomic, strong) TYLongPressButton *enlargeButton;
@property (nonatomic, strong) TYLongPressButton *reduceButton;
@property (nonatomic, strong) TYLongPressButton *leftButton;
@property (nonatomic, strong) TYLongPressButton *rightButton;

@end

@implementation TYChartHandOperationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    [self addSubview:self.enlargeButton];
    [self addSubview:self.reduceButton];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    [buttons addObject:self.enlargeButton];
    [buttons addObject:self.reduceButton];
    [buttons addObject:self.leftButton];
    [buttons addObject:self.rightButton];
    
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
    }];
}

- (void)operationButtonAction:(TYLongPressButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chartHandOperationView:didClickOperationType:)]) {
        [self.delegate chartHandOperationView:self didClickOperationType:sender.tag];
    }
}

#pragma mark - lazy

- (TYLongPressButton *)enlargeButton {
    if (!_enlargeButton) {
        _enlargeButton = [TYLongPressButton buttonWithType:UIButtonTypeCustom];
        [_enlargeButton setImage:[UIImage imageNamed:@"icon_enlarge"] forState:UIControlStateNormal];
        [_enlargeButton addTarget:self action:@selector(operationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_enlargeButton addTarget:self action:@selector(operationButtonAction:) forControlEvents:UIControlEventLongPress];
        _enlargeButton.longPressInterval = 0.1;
        _enlargeButton.tag = TYOperationTypeEnlarge;
    }
    return _enlargeButton;
}

- (TYLongPressButton *)reduceButton {
    if (!_reduceButton) {
        _reduceButton = [TYLongPressButton buttonWithType:UIButtonTypeCustom];
        [_reduceButton setImage:[UIImage imageNamed:@"icon_reduce"] forState:UIControlStateNormal];
        [_reduceButton addTarget:self action:@selector(operationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reduceButton addTarget:self action:@selector(operationButtonAction:) forControlEvents:UIControlEventLongPress];
        _reduceButton.longPressInterval = 0.1;
        _reduceButton.tag = TYOperationTypeReduce;
    }
    return _reduceButton;
}

- (TYLongPressButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [TYLongPressButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"icon_left"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(operationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton addTarget:self action:@selector(operationButtonAction:) forControlEvents:UIControlEventLongPress];
        _leftButton.longPressInterval = 0.01;
        _leftButton.tag = TYOperationTypeLeft;
    }
    return _leftButton;
}

- (TYLongPressButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [TYLongPressButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"icon_right"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(operationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton addTarget:self action:@selector(operationButtonAction:) forControlEvents:UIControlEventLongPress];
        _rightButton.longPressInterval = 0.01;
        _rightButton.tag = TYOperationTypeRight;
    }
    return _rightButton;
}


@end
