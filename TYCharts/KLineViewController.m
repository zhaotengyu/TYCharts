//
//  KLineViewController.m
//  TYCharts
//
//  Created by ty on 2023/10/30.
//

#import "KLineViewController.h"
#import "Masonry.h"
#import "NetworkHelper.h"
#import "TYCandleStickView.h"
#import "TYChartContainerView.h"
#import "TYChartHandOperationView.h"

@interface KLineViewController () <TYChartViewDelegate, TYChartViewDataSource, TYChartHandOperationViewDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *candleLabel;
@property (nonatomic, strong) TYCandleStickView *candleView;
@property (nonatomic, strong) TYChartContainerView *chartView;
@property (nonatomic, strong) TYChartHandOperationView *operationView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) TYChartDataSource *dataSource;

@end

@implementation KLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
}

- (void)setupViews
{
    UITextField *textField = [[UITextField alloc] init];
    textField.text = @"SZ000001";
    [self.view addSubview:textField];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:confirmButton];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.backgroundColor = [UIColor blackColor];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(textField);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textField.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(0);
    }];
    
    UILabel *candleLabel = [[UILabel alloc] init];
    [scrollView addSubview:candleLabel];
    candleLabel.text = @"";
    self.candleLabel = candleLabel;
    [candleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollView);
        make.left.right.mas_equalTo(scrollView);
    }];

    TYCandleStickView *candleView = [[TYCandleStickView alloc] initWithChartLineType:TYChartLineTypeKLine];
    [scrollView addSubview:candleView];
    candleView.dataSource = self;
    candleView.delegate = self;
    self.candleView = candleView;
    [candleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(candleLabel.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(scrollView);
        make.width.mas_equalTo(scrollView);
        make.height.mas_equalTo(240);
    }];
    
    TYChartContainerView *chartView = [[TYChartContainerView alloc] init];
    [scrollView addSubview:chartView];
    chartView.mainChartView = self.candleView;
    self.chartView = chartView;
    [chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(candleView.mas_bottom);
        make.left.right.mas_equalTo(scrollView);
        make.width.mas_equalTo(scrollView);
        make.height.mas_equalTo(112);
        make.bottom.mas_equalTo(scrollView);
    }];
    
    // 展开按钮
    UIButton *expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [expandButton setImage:[UIImage imageNamed:@"icon_fold"] forState:UIControlStateNormal];
    [expandButton setImage:[UIImage imageNamed:@"icon_expand"] forState:UIControlStateSelected];
    [expandButton addTarget:self action:@selector(expandButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:expandButton];
    [expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(self.candleView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    // 左、右移动 放大、缩小等按钮
    TYChartHandOperationView *operationView = [[TYChartHandOperationView alloc] init];
    operationView.delegate = self;
    [self.view addSubview:operationView];
    self.operationView = operationView;
    [operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(expandButton.mas_right);
        make.centerY.mas_equalTo(expandButton);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
}

/// 收起、折叠
/// - Parameter sender: <#sender description#>
- (void)expandButtonAction:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    self.operationView.hidden = sender.isSelected;
}

- (void)confirmButtonAction:(UIButton *)sender
{
    NSDate *currentDate = [NSDate date];
    NSDate *lastDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:currentDate];
    NSInteger time = (NSInteger)[lastDay timeIntervalSince1970] * 1000;
    [self loadDataWithStokeCode:self.textField.text count:450 time:time];
}

- (void)loadDataWithStokeCode:(NSString *)code count:(NSInteger)count time:(NSInteger)time
{
    NSString *url = [NSString stringWithFormat:@"https://stock.xueqiu.com/v5/stock/chart/kline.json?symbol=%@&begin=%@&period=day&type=before&count=-%ld&indicator=kline,pe,pb,ps,pcf,market_capital,agt,ggt,balance", code, @(time), count];
    
    [[[NetworkHelper share].session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        if (!jsonDic) {
            return;
        }
        
        NSArray *items = jsonDic[@"data"][@"item"];

        items = [[items reverseObjectEnumerator] allObjects];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSArray *models in items) {
            TYChartKLineDataModel *item = [[TYChartKLineDataModel alloc] init];
            item.date = [[NSDate alloc] dateFromTimeStamap:models[0]];
            NSString *volume = [TYDecimalNumberTool keepDoubleOfValue:[models[1] doubleValue] / 100.0 scale:0];
            
            item.volume = [NSNumber numberWithInteger:[volume integerValue]];
            item.openPrice = [NSNumber numberWithDouble:[models[2] doubleValue]];
            item.highPrice = [NSNumber numberWithDouble:[models[3] doubleValue]];
            item.lowPrice = [NSNumber numberWithDouble:[models[4] doubleValue]];
            item.closePrice = [NSNumber numberWithDouble:[models[5] doubleValue]];
            item.changing = [NSNumber numberWithDouble:[models[6] doubleValue]];
            item.percent = [NSNumber numberWithDouble:[models[7] doubleValue]];
            item.turnoverrate = [NSNumber numberWithDouble:[models[8] doubleValue]];
            item.amount = [NSNumber numberWithDouble:[models[9] doubleValue]];
            [arr addObject:item];
        }
        
        [self.datas addObjectsFromArray:arr];
        self.dataSource.models = [self.datas copy];
        
        
        self.dataSource.haveMoreData = (items.count >= count);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.chartView.datas = [self.datas copy];
            [self.candleView drawChart];
        });
    }] resume];
}

#pragma mark - TYChartViewDataSource

- (TYChartDataSource *)chartViewDataSource:(TYChartView *)chartView
{
    return self.dataSource;
}

#pragma mark - TYChartViewDelegate

- (void)chartView:(TYChartView *)chartView displayIndexText:(NSAttributedString *)attributedText
{
    self.candleLabel.attributedText = attributedText;
}

- (void)chartViewLoadMoreData:(TYChartView *)chartView withDate:(NSDate *)date
{
    
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
    NSInteger time = (NSInteger)[lastDay timeIntervalSince1970] * 1000;
    [self loadDataWithStokeCode:self.textField.text count:375 time:time];
}

#pragma mark - TYChartHandOperationViewDelegate

- (void)chartHandOperationView:(TYChartHandOperationView *)view didClickOperationType:(TYOperationType)type {
    switch (type) {
        case TYOperationTypeLeft:
            [self.candleView moveCharWithDirection:TYMoveChartDirectionLeft];
            break;
        case TYOperationTypeRight:
            [self.candleView moveCharWithDirection:TYMoveChartDirectionRight];
            break;
        case TYOperationTypeReduce:
            [self.candleView zoomChartWithEnlarge:NO];
            break;
        case TYOperationTypeEnlarge:
            [self.candleView zoomChartWithEnlarge:YES];
            break;
    }
}

#pragma mark - lazy

- (TYChartDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[TYChartDataSource alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

@end
