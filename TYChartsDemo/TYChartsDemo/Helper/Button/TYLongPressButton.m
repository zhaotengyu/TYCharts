//
//  TYLongPressButton.m
//  TYKLineCharts
//
//  Created by ty on 2023/8/7.
//

#import "TYLongPressButton.h"
#import "NSArray+Filter.h"
#import "TYWeakTimer.h"

const UIControlEvents UIControlEventLongPress = 1 << 9;

@interface DXTargetActionProxy : NSProxy

@property(nonatomic, weak) id dxtarget;
@property(nonatomic, assign) SEL dxaction;

@end

@implementation DXTargetActionProxy

@end

@interface TYLongPressButton ()
{
    BOOL _isPressed;
    UIEvent *_touchEvent;
    NSMutableArray *_targetActionArray;
}

@property (nonatomic, strong) TYWeakTimer *timer;

@end

@implementation TYLongPressButton

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeIvars];
        [self addLongPressGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeIvars];
        [self addLongPressGesture];
    }
    return self;
}

- (void)initializeIvars
{
    _longPressInterval = 0.1;
    _targetActionArray = [NSMutableArray new];
    _longPressCancelsOtherEvents = YES;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)addLongPressGesture
{
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    [self addGestureRecognizer:longPressGes];
}

- (void)startTimerAction
{
    [self performSelector:@selector(touchedAndHeldForLongTime:)
               withObject:self
               afterDelay:0.0];
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _isPressed = YES;
            self.timer = [TYWeakTimer timerWithTimeInterval:_longPressInterval target:self selector:@selector(startTimerAction) repeats:YES];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            _isPressed = NO;
            [self.timer invalidate];
        }
            break;
            
        default:
            break;
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventLongPress) {
        target = [self responderForTarget:target Withaction:action];
        DXTargetActionProxy *targetAction = [DXTargetActionProxy alloc];
        targetAction.dxtarget = target;
        targetAction.dxaction = action;
        [_targetActionArray addObject:targetAction];
    }
    [super addTarget:target action:action forControlEvents:controlEvents];
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventLongPress) {
        [self removeTargetAction:action];
    }
    [super removeTarget:target action:action forControlEvents:controlEvents];
}

- (void)removeTargetAction:(SEL)action
{
    [_targetActionArray removeObjectsMatchingPredicate:^BOOL(DXTargetActionProxy *object) {
        return object.dxaction == action;
    }];
}

- (UIResponder *)responderForTarget:(UIResponder *)target Withaction:(SEL)action
{
    UIResponder *responder = target?:[self nextResponder];
    while (responder) {
        if ([responder respondsToSelector:action]) {
            break;
        }
        responder = [responder nextResponder];
    }
    return responder;
}

- (void)touchedAndHeldForLongTime:(UIButton *)sender
{
    if (_isPressed) {
        for (DXTargetActionProxy *targetAction in _targetActionArray) {
            if (targetAction.dxtarget) {
                NSMethodSignature *theSignature = [targetAction.dxtarget methodSignatureForSelector:targetAction.dxaction];
                NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:theSignature];
                [theInvocation setTarget:targetAction.dxtarget];
                [theInvocation setSelector:targetAction.dxaction];
                NSUInteger argumentCount = [theSignature numberOfArguments] - 2;
                for (int i = 0; i < argumentCount; ++i) {
                    if (i == 0) {
                        [theInvocation setArgument:&sender atIndex:(i + 2)];
                    } else if (i == 1) {
                        [theInvocation setArgument:&_touchEvent atIndex:(i + 2)];
                    } else {
                        void *nilParam = NULL;
                        [theInvocation setArgument:&nilParam atIndex:(i + 2)];
                    }
                }
                [theInvocation invoke];
            }
        }
        if (self.shouldLongPressCancelOtherEvents) {
            [self cancelTrackingWithEvent:nil];
        }
    }
}

@end
