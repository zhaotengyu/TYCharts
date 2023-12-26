//
//  TYChartView.m
//  TYCharts
//
//  Created by ty on 2023/10/26.
//

#import "TYChartView.h"
#import "TYChartBaseLayer.h"
#import "UIView+TYFrame.h"
#import "UIColor+HXColor.h"
#import "NSDate+Extension.h"

@interface TYChartView () <CALayerDelegate, UIScrollViewDelegate>

/// 边框View
@property (nonatomic, strong) UIView *borderView;
/// 分割线View
@property (nonatomic, strong) UIView *separatoreView;
/// 主容器（放大手势、滚动手势）
@property (nonatomic, strong) UIScrollView *mainScrollView;
/// 图表容器（点击手势、长按手势）
@property (nonatomic, strong) UIView *mainChartView;
/// 辅助图（存放最大最小价格等）
@property (nonatomic, strong) UIView *axisChartView;

/// 主图表Layer（蜡烛图、交易图等）
@property (nonatomic, strong) TYChartBaseLayer *mainLayer;

@property (nonatomic, strong) TYAxisChartLayer *axisLayer;
/// 十字线Layer
@property (nonatomic, strong) TYCursorLineLayer *cursorLineLayer;

@property (nonatomic, assign, getter=isReverseScrolling) BOOL reverseScrolling;

/// 捏合手势标识
@property (nonatomic, assign, getter=isPinching) BOOL pinching;

/// 点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
/// 捏合手势
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
/// 长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

/// 图表显示大小
@property (nonatomic, assign) CGFloat chartWidth;
/// 图表所需补偿宽度
@property (nonatomic, assign) CGFloat notEnoughWidth;
/// 图表整体大小
@property (nonatomic, assign) CGFloat chartContentWidth;
/// 长按选中下标
@property (nonatomic, assign) NSInteger selectedIndex;

/// 关联图表数组
@property (nonatomic, strong) NSMutableArray<NSValue *> *reactChains;

@end

@implementation TYChartView

- (instancetype)initWithChartLineType:(TYChartLineType)chartLineType
{
    self = [super init];
    if (self) {
        self.chartLineType = chartLineType;
        [self prepare];
        [self setupViews];
        [self addGesture];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepare];
        [self setupViews];
        [self addGesture];
    }
    return self;
}

#pragma mark - Defaults

/// 初始化
- (void)prepare
{
    
}

/// Views
- (void)setupViews
{
    // 边框View
    [self addSubview:self.borderView];
    // 分割线View
    [self addSubview:self.separatoreView];
    // 滚动View
    [self addSubview:self.mainScrollView];
    // 加载图表主View
    [self.mainScrollView addSubview:self.mainChartView];
    // 辅助线View
    [self addSubview:self.axisChartView];
}

/// 添加手势
- (void)addGesture
{
    // 点击手势
    [self.mainChartView addGestureRecognizer:self.tapGesture];
    // 捏合手势
    [self.mainScrollView addGestureRecognizer:self.pinchGesture];
    // 长按手势
    [self.mainChartView addGestureRecognizer:self.longPressGesture];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (CGSizeEqualToSize(self.mainScrollView.ty_size, CGSizeZero)) {
        CGRect borderRect = CGRectMake(self.data.config.chartContentEdgeInsets.left,
                                       self.data.config.chartContentEdgeInsets.top,
                                       self.bounds.size.width - self.data.config.chartContentEdgeInsets.left - self.data.config.chartContentEdgeInsets.right,
                                       self.bounds.size.height - self.data.config.chartContentEdgeInsets.top - self.data.config.chartContentEdgeInsets.bottom);
        // 边框
        self.borderView.frame = borderRect;
        CGRect mainRect = CGRectMake(borderRect.origin.x + 0.5, borderRect.origin.y + 0.5, borderRect.size.width - 0.5 * 2, borderRect.size.height - 0.5 * 2);
        // 分割线
        self.separatoreView.frame = mainRect;
        // 滚动View
        self.mainScrollView.frame = mainRect;
        // 加载图表主View
        self.mainChartView.frame = self.mainScrollView.bounds;
        
        self.axisChartView.frame = self.mainScrollView.frame;
        
        self.chartWidth = CGRectGetWidth(self.mainScrollView.bounds);
    }
}

- (void)drawRect:(CGRect)rect
{
    
}

- (void)displayLayer:(CALayer *)layer
{
    // 计算默认数据
    [self loadDefault];
    if (self.data.models.count == 0) {
        return;
    }
    // 更新图表
    [self updateChart];
}

#pragma mark - Private

/// 计算默认数据
- (void)loadDefault
{
    TYChartDataSource *dataSource = [self.dataSource chartViewDataSource:self];
    self.data = dataSource;
}

/// 更新图表
- (void)updateChart
{
    // 绘制分割线
    [self.axisLayer drawYAxisGridLine:self.separatoreView.layer];
    // 计算图表整体大小
    [self updateChartContentWidth];
    // 计算可见区域数据
    [self calculateVisibleModels];
    // 计算点坐标
    [self updateAllDataPoint];
    // 计算指标数据
    [self updateTechnicalIndexData];
    // 设置Y轴
    [self updateYAxisData];
    // 绘制x轴网格线
    [self.axisLayer drawXAxisGridLine:self.mainChartView.layer];
    // 绘制主视图
    [self.mainLayer drawChart:self.mainChartView.layer];
    // 绘制Y轴价格线
    [self.axisLayer drawYAxisTickIntervalPrices:self.axisChartView.layer];
    // 更新选中线数据
    [self updateIndexText:self.selectedIndex];
}

/// 计算图表整体大小
- (void)updateChartContentWidth
{
    NSArray *datas = self.data.models;
    CGFloat contentSizeWidth = datas.count * self.data.config.plotWidth;
    
    if (self.chartLineType == TYChartLineTypeKLine) {
            
        if (contentSizeWidth < self.chartWidth) {
            self.notEnoughWidth = self.chartWidth - contentSizeWidth;
            contentSizeWidth = self.chartWidth;
        } else {
            self.notEnoughWidth = 0;
        }
    } else {
        contentSizeWidth = self.mainScrollView.ty_width;
        self.notEnoughWidth = 0;
    }
    
    self.mainScrollView.contentSize = CGSizeMake(contentSizeWidth, 0);
    self.mainChartView.ty_width = contentSizeWidth;
    self.chartContentWidth = contentSizeWidth;
}

/// 处理可见区域内的各项数据
- (void)calculateVisibleModels
{
    NSArray *datas = self.data.models;
    
    NSInteger startIndex = 0;
    NSInteger endIndex = 0;
    
    CGFloat plotWidth = self.data.config.plotWidth;
    
    CGFloat contentSizeWidth = datas.count * plotWidth;
    
    CGFloat contentOffsetX = self.data.config.contentOffset.x;
    startIndex = floor(contentOffsetX / plotWidth);
    endIndex = ceil((contentOffsetX - self.notEnoughWidth + self.chartWidth) / plotWidth);
    
    startIndex = startIndex > 0 ? startIndex : 0;
    endIndex = endIndex > datas.count ? datas.count : endIndex;
    
    if (contentSizeWidth <= self.chartWidth && contentOffsetX > 0) {
        startIndex = 0;
    }
    
    if (startIndex == 0 && endIndex == 0) {
        return;
    }
    
    self.data.xAxis.startIndex = startIndex;
    self.data.xAxis.endIndex = endIndex;
    self.selectedIndex = startIndex;
}

/// 计算坐标点等数据
- (void)updateAllDataPoint
{
    NSArray<TYChartKLineDataModel *> *models = self.data.models;
    
    NSInteger monthInterval = 1;
    if (self.data.config.plotWidth <= 1) {
        monthInterval = 3;
    } else if (self.data.config.plotWidth <= (6 - 4 * (5.0/6.0))) { // 每2个月画一条线
        monthInterval = 2;
    } else { // 每个月画一跳线
        monthInterval = 1;
    }
    
    NSInteger flag = monthInterval;
    for (NSInteger index = 0; index < models.count; index++) {
        
        TYChartKLineDataModel *currentModel = models[index];
        // 计算x坐标
        CGFloat pointX = self.data.config.lineWidth / 2 + self.data.config.plotWidth * index + self.notEnoughWidth;
        currentModel.pointX = pointX;
        currentModel.displayMonthLine = NO;
        // 处理月份
        if ((index + 1) >= models.count) {
            break;
        }
        
        TYChartKLineDataModel *lsatModel = models[index + 1];
        if (currentModel.date.month != lsatModel.date.month) {
            flag --;
            if (flag == 0) {
                currentModel.displayMonthLine = YES;
                flag = monthInterval;
            }
            
        }
    }
}

/// 更新Y轴数据
- (void)updateYAxisData
{
    
}

/// 配置指标数据
- (void)updateTechnicalIndexData
{
    
}

/// 更新选中数据文字
/// - Parameter index: <#index description#>
- (void)updateIndexText:(NSInteger)index
{
    
}

#pragma mark - Public

/// 更新图表
- (void)drawChart
{
    [self setNeedsDisplay];
}

/// 放大、缩小图表
/// - Parameter isEnlarge: <#isEnlarge description#>
- (void)zoomChartWithEnlarge:(BOOL)isEnlarge
{
    if (self.data.models.count == 0) {
        return;
    }
    
    [self hideCursorLine];
    [self updateChartWidthWithEnlarge:isEnlarge];
    [self reactChainsHandleOperationWtihCompletion:^(TYChartView *chartView) {
        [chartView updateChartWidthWithEnlarge:isEnlarge];
    }];
}

/// 滚动图表
/// - Parameter direction: 方向
- (void)moveCharWithDirection:(TYMoveChartDirection)direction
{
    if (self.data.models.count == 0) {
        return;
    }
    
    BOOL isDirection = (direction == TYMoveChartDirectionRight);
    CGPoint point = self.data.config.contentOffset;
    
    if (isDirection) { // 右滑操作
        point.x = point.x - self.data.config.plotWidth;
    } else { // 左滑操作
        point.x = point.x + self.data.config.plotWidth;
    }
    
    if (point.x >= (self.mainScrollView.contentSize.width - self.chartWidth)) {
        point.x = self.mainScrollView.contentSize.width - self.chartWidth;
    } else if (point.x <= 0) {
        point.x = 0;
    }

    [self.mainScrollView setContentOffset:point animated:NO];
    [self reactChainsHandleOperationWtihCompletion:^(TYChartView *chartView) {
        [chartView.mainScrollView setContentOffset:point animated:NO];
    }];
}

#pragma mark - 图表关联

+ (void)addReactChains:(NSArray<TYChartView *> *)chartViews
{
    [chartViews enumerateObjectsUsingBlock:^(TYChartView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        for (TYChartView *curView in chartViews) {
            if (curView != obj) {
                [mArr addObject:curView];
            }
        }
        [obj addReactChains:[mArr copy]];
    }];
}

- (void)addReactChains:(NSArray<TYChartView *> *)chartViews
{
    [chartViews enumerateObjectsUsingBlock:^(TYChartView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TYChartView class]]) {
            NSValue *weakObj = [NSValue valueWithNonretainedObject:obj];
            if (![self.reactChains containsObject:weakObj]) {
                [self.reactChains addObject:weakObj];
            }
        }
    }];
}

/// 执行联动操作
/// - Parameter completion: <#completion description#>
- (void)reactChainsHandleOperationWtihCompletion:(void(^)(TYChartView *chartView))completion
{
    // 手势同步
    [self.reactChains enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TYChartView *chartView = (TYChartView *)obj.nonretainedObjectValue;
        if (chartView != self) {
            if (completion) {
                completion(chartView);
            }
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isReverseScrolling || self.isPinching || self.data.models.count == 0) {
        return;
    }
    
    // 同步滚动
    if (scrollView == self.mainScrollView &&
        (self.mainScrollView.isDragging ||
         self.mainScrollView.isDecelerating ||
         self.mainScrollView.isTracking)) {
        [self reactChainsHandleOperationWtihCompletion:^(TYChartView *chartView) {
            [chartView.mainScrollView setContentOffset:scrollView.contentOffset animated:NO];
        }];
    }

    // 隐藏十字线
    [self hideCursorLine];
    // 设置偏移量
    self.data.config.contentOffset = scrollView.contentOffset;
    // 更新图表
    [self updateChart];
}

#pragma mark - Gesture Recognizer

/// 点击手势
/// - Parameter recognizer: <#recognizer description#>
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer
{
    [self hideCursorLine];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickChartView:)]) {
        [self.delegate didClickChartView:self];
    }
}

/// 长按手势
/// - Parameter recognizer: <#recognizer description#>
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (self.data.models.count == 0) {
        return;
    }
    CGPoint point = [recognizer locationInView:self.mainScrollView];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self startLongPress];
            [self reactChainsHandleOperationWtihCompletion:^(TYChartView *chartView) {
                [chartView startLongPress];
            }];
        }
            
        case UIGestureRecognizerStateChanged:
        {
            [self showCursorLineAtPoint:point];
            // 长按图表手势联动
            [self reactChainsHandleOperationWtihCompletion:^(TYChartView *chartView) {
                CGPoint currentViewPoint = [chartView convertPoint:point fromView:self];
                [chartView showCursorLineAtPoint:currentViewPoint];
            }];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            [self endLongPress];
            [self reactChainsHandleOperationWtihCompletion:^(TYChartView *chartView) {
                [chartView endLongPress];
            }];
        }
            
        default:
            break;
    }
}

/// 捏合手势
/// - Parameter recognizer: <#recognizer description#>
- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer
{
    if (self.data.models.count == 0) {
        return;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self startPinch];
            [self reactChainsHandleOperationWtihCompletion:^(TYChartView *chartView) {
                [chartView startPinch];
            }];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            if (fabs(recognizer.scale - 1) > 0.02) {
                BOOL isEnlarge = (recognizer.scale - 1) > 0;
                [self updateChartWidthWithEnlarge:isEnlarge];
                if (recognizer == self.pinchGesture) {
                    [self reactChainsHandleOperationWtihCompletion:^(TYChartView *chartView) {
                        [chartView updateChartWidthWithEnlarge:isEnlarge];
                    }];
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self endPinch];
            [self reactChainsHandleOperationWtihCompletion:^(TYChartView *chartView) {
                [chartView endPinch];
            }];
        }
            break;
            
        default:
            break;
    }
    
    if (self.pinchGesture == recognizer) {
        recognizer.scale = 1;
    }
}

/// 开始捏合手势
- (void)startPinch
{
    self.pinching = YES;
    self.mainScrollView.scrollEnabled = NO;
    [self hideCursorLine];
}

/// 结束捏合手势
- (void)endPinch
{
    self.pinching = NO;
    self.mainScrollView.scrollEnabled = YES;
}

/// 开始长按
- (void)startLongPress
{
    dispatch_async(dispatch_get_main_queue(),^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideCursorLine) object:nil];
    });
}

/// 结束长按
- (void)endLongPress
{
    dispatch_async(dispatch_get_main_queue(),^{
        [self performSelector:@selector(hideCursorLine) withObject:nil afterDelay:3];
    });
}

/// 展示十字线
/// - Parameter point: 十字线中线点
- (void)showCursorLineAtPoint:(CGPoint)point
{
    CGFloat maxWidth = CGRectGetWidth(self.axisChartView.frame);
    
    TYChartDataSource *data = self.data;
    NSArray<TYChartKLineDataModel *> *models = data.models;
    
    CGFloat startIndex = data.xAxis.startIndex;
    CGFloat endIndex = data.xAxis.endIndex;
    
    for (NSInteger index = startIndex; index < endIndex; index++) {
        
        TYChartKLineDataModel *currentModel = models[index];
        NSInteger nextIndex = index + 1 >= models.count ? index : index + 1;
        TYChartKLineDataModel *nextModel = models[nextIndex];
        
        CGFloat currentPointX = currentModel.pointX;
        CGFloat nextPointX = nextModel.pointX;
        
        if (point.x >= currentPointX && point.x < nextPointX) {
            if (self.selectedIndex == index) {
                break;
            }
            self.selectedIndex = index;
            break;
        }
    }
    
    TYChartKLineDataModel *lastModel = models.lastObject;
    if (point.x >= lastModel.pointX) {
        self.selectedIndex = models.count - 1;
    }
    
    if (self.selectedIndex < models.count) {
        TYChartKLineDataModel *model = models[self.selectedIndex];
        CGFloat pointX = 0;
        if (self.chartLineType == TYChartLineTypeKLine) { // k线
            pointX = maxWidth - (model.pointX + data.config.candleWidth / 2) + data.config.contentOffset.x;
        } else { // 分时、5日分时
            pointX = model.pointX + data.config.candleWidth / 2;
        }        
        CGFloat pointY = point.y;
        CGPoint linePoint = CGPointMake(pointX, pointY);
        [self showXAxisCursorLineWithModel:model atPoint:linePoint];
        [self updateIndexText:self.selectedIndex];
    }
}

/// 展示十字线
/// - Parameter point: <#point description#>
- (void)showXAxisCursorLineWithModel:(TYChartKLineDataModel *)model atPoint:(CGPoint)point
{
    TYChartDataSource *data = self.data;
    CGFloat maxHeight = TYGetChartMaxHeight(self.axisChartView.layer.bounds);
    CGFloat minAxisValue = data.yAxis.minYAxisValue;
    CGFloat maxAxisValue = data.yAxis.maxYAxisValue;
    CGFloat heightRate = maxAxisValue == minAxisValue ? 0 : (maxHeight) / (maxAxisValue - minAxisValue);
    
    CGFloat price = (CGRectGetMinY(self.axisChartView.layer.bounds) + maxHeight - point.y) / heightRate + minAxisValue;
    NSString *priceText = [NSString stringWithFormat:@"%.2f", price];
    [self.cursorLineLayer showCursorLine:priceText inContentLayer:self.axisChartView.layer atPoint:point];
    
    NSString *format = @"yyyy-MM-dd";
    NSString *text = [model.date stringWithFormat:format];
    [self.cursorLineLayer showXAxisText:text inContentLayer:self.layer atPoint:point];
}

/// 隐藏十字线
- (void)hideCursorLine
{
    if (self.cursorLineLayer.isShow) {
        [self.cursorLineLayer hide];
        self.selectedIndex = self.data.xAxis.startIndex;
        [self updateIndexText:self.selectedIndex];
    }
}

/// 更新图表大小
/// - Parameter enlarge: <#enlarge description#>
- (void)updateChartWidthWithEnlarge:(BOOL)enlarge
{
    TYChartDataSource *data = self.data;
    if (data.models.count == 0) {
        return;
    }
    
    CGFloat newCandleWidth = data.config.plotWidth;

    if (enlarge) { // 放大
        newCandleWidth = newCandleWidth >= 6 ? (newCandleWidth + 1) : (newCandleWidth + (5.0/6.0));
    } else { //缩小
        newCandleWidth = newCandleWidth <= 6 ? (newCandleWidth - (5.0/6.0)) : (newCandleWidth - 1);
    }

    if (newCandleWidth > 16 || newCandleWidth < 1) {
        return;
    }
    
    data.config.candleWidth = newCandleWidth - data.config.lineWidth - data.config.candleSpacing;
    
    // 重新计算图表大小
    [self updateChartContentWidth];

    CGFloat contentOffset = self.chartContentWidth - self.chartWidth;
    // 当图表数据足够时，计算移动距离
    if (contentOffset > 0) {
        // 新的偏移量
        CGFloat newOffsetX = newCandleWidth * data.xAxis.startIndex;
        if (newOffsetX > self.chartContentWidth - self.chartWidth) {
            newOffsetX = self.chartContentWidth - self.chartWidth;
        }
        newOffsetX += 0.5;
        CGPoint newOffset = CGPointMake(newOffsetX, 0);
        data.config.contentOffset = newOffset;
        [self.mainScrollView setContentOffset:newOffset animated:NO];
    }
    
    [self updateChart];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:zoomChartByCandleWidth:)]) {
        [self.delegate chartView:self zoomChartByCandleWidth:data.config.candleWidth];
    }
}

#pragma mark - getter/setter

- (void)setChartLineType:(TYChartLineType)chartLineType
{
    _chartLineType = chartLineType;
    
    CGAffineTransform transform = CGAffineTransformIdentity;

    BOOL isTimeLine = chartLineType == TYChartLineTypeTimeLine || chartLineType == TYChartLineType5DTimeLine;
    self.pinchGesture.enabled = !isTimeLine;
    self.mainScrollView.scrollEnabled = !isTimeLine;
    self.mainScrollView.transform = CGAffineTransformScale(transform, isTimeLine ? 1.0 : -1.0, 1.0);
}

- (UIView *)borderView
{
    if (!_borderView) {
        _borderView = [[UIView alloc] init];
        _borderView.layer.borderWidth = 0.5;
        _borderView.layer.borderColor = [UIColor ty_colorWithHexString:@"#E8E8E8"].CGColor;
    }
    return _borderView;
}

- (UIView *)separatoreView
{
    if (!_separatoreView) {
        _separatoreView = [[UIView alloc] init];
    }
    return _separatoreView;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.delegate = self;
        _mainScrollView.scrollsToTop = NO;
        _mainScrollView.alwaysBounceVertical = NO;
        _mainScrollView.alwaysBounceHorizontal = YES;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

- (UIView *)mainChartView
{
    if (!_mainChartView) {
        _mainChartView = [[UIView alloc] init];
    }
    return _mainChartView;
}

- (UIView *)axisChartView
{
    if (!_axisChartView) {
        _axisChartView = [[UIView alloc] init];
        _axisChartView.userInteractionEnabled = NO;
        _axisChartView.layer.masksToBounds = YES;
    }
    return _axisChartView;
}

- (TYChartBaseLayer *)mainLayer
{
    return nil;
}

- (TYAxisChartLayer *)axisLayer
{
    if (!_axisLayer) {
        _axisLayer = [TYAxisChartLayer layerWithDataSource:self.data];
    }
    return _axisLayer;
}

- (TYCursorLineLayer *)cursorLineLayer
{
    if (!_cursorLineLayer) {
        _cursorLineLayer = [TYCursorLineLayer layerWithDataSource:self.data];
    }
    return _cursorLineLayer;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture){
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        _tapGesture.enabled = YES;
    }
    return _tapGesture;
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture){
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    }
    return _longPressGesture;
}

- (UIPinchGestureRecognizer *)pinchGesture
{
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
        _pinchGesture.scale = 1.0;
    }
    return _pinchGesture;
}

- (TYChartDataSource *)data
{
    if (!_data) {
        _data = [[TYChartDataSource alloc] init];
    }
    return _data;
}

- (NSMutableArray<NSValue *> *)reactChains
{
    if (!_reactChains){
        _reactChains = [NSMutableArray array];
    }
    return _reactChains;
}

@end
