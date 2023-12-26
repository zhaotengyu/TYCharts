//
//  TYTimeIndexChartContainerView.m
//  TYCharts
//
//  Created by ty on 2023/10/31.
//

#import "TYTimeIndexChartContainerView.h"
#import "Masonry.h"
#import "TYBarLineView.h"

@interface TYTimeIndexChartContainerView () <TYChartViewDelegate, TYChartViewDataSource>

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) TYBarLineView *barLineView;

@property (nonatomic, strong) TYChartDataSource *dataSource;

@end

@implementation TYTimeIndexChartContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    UILabel *tipLabel = [[UILabel alloc] init];
    [self addSubview:tipLabel];
    tipLabel.text = @"";
    self.tipLabel = tipLabel;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    UIView *containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.bottom.right.mas_equalTo(self);
    }];

    TYBarLineView *barLineView = [[TYBarLineView alloc] initWithChartLineType:TYChartLineTypeTimeLine];
    [containerView addSubview:barLineView];
    barLineView.indicatorType = TYChartIndicatorTypeAmount;
    barLineView.delegate = self;
    barLineView.dataSource = self;
    self.barLineView = barLineView;
    [barLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    self.dataSource.models = datas;
    [self.barLineView drawChart];
}

- (void)setMainChartView:(TYTimeIndexChartView *)mainChartView
{
    _mainChartView = mainChartView;
    [TYChartView addReactChains:@[self.mainChartView, self.barLineView]];
}

#pragma mark - TYChartViewDataSource

- (TYChartDataSource *)chartViewDataSource:(TYChartView *)chartView
{
    return self.dataSource;
}

#pragma mark - TYChartViewDelegate

- (void)chartView:(TYChartView *)chartView displayIndexText:(NSAttributedString *)attributedText
{
    self.tipLabel.attributedText = attributedText;
}

#pragma mark - lazy

- (TYChartDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[TYChartDataSource alloc] init];
    }
    return _dataSource;
}

@end
