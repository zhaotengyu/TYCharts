//
//  TimeLineViewController.m
//  TYCharts
//
//  Created by ty on 2023/10/30.
//

#import "TimeLineViewController.h"
#import "NSDate+Extension.h"
#import "YYModel.h"
#import "Masonry.h"
#import "NetworkHelper.h"
#import "TYDecimalNumberTool.h"
#import "TimeLineMinuteModel.h"
#import "TYTimeIndexChartView.h"
#import "TYTimeIndexChartContainerView.h"

@interface TimeLineViewController () <TYChartViewDelegate, TYChartViewDataSource>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) TYTimeIndexChartView *chartView;
@property (nonatomic, strong) TYTimeIndexChartContainerView *indexView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) TYChartDataSource *dataSource;

@end

@implementation TimeLineViewController

- (void)viewDidLoad {
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
    
    TYTimeIndexChartView *chartView = [[TYTimeIndexChartView alloc] initWithChartLineType:TYChartLineTypeTimeLine];
    [self.view addSubview:chartView];
    chartView.delegate = self;
    chartView.dataSource = self;
    self.chartView = chartView;
    [chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textField.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(240);
    }];
}

- (void)confirmButtonAction:(UIButton *)sender
{
    [self loadDataWithStokeCode:self.textField.text];
}

- (void)loadDataWithStokeCode:(NSString *)code
{
    NSString *url = [NSString stringWithFormat:@"https://stock.xueqiu.com/v5/stock/chart/minute.json?symbol=%@&period=1d", code];
    
    [[[NetworkHelper share].session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        if (!jsonDic) {
            return;
        }
        
        NSArray *items = jsonDic[@"data"][@"items"];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in items) {
            TimeLineMinuteModel *model = [TimeLineMinuteModel yy_modelWithDictionary:dic];
            TYChartKLineDataModel *item = [[TYChartKLineDataModel alloc] init];
            item.date = [[NSDate alloc] dateFromTimeStamap:[NSString stringWithFormat:@"%ld", (long)model.timestamp]];
            NSString *volume = [TYDecimalNumberTool keepDoubleOfValue:model.volume / 100.0 scale:0];
            item.volume = [NSNumber numberWithInteger:[volume integerValue]];
            item.highPrice = [NSNumber numberWithDouble:[model.high doubleValue]];
            item.lowPrice = [NSNumber numberWithDouble:[model.low doubleValue]];
            item.yClosePrice = [NSNumber numberWithDouble:[jsonDic[@"data"][@"last_close"] doubleValue]];
            item.changing = [NSNumber numberWithDouble:[model.chg doubleValue]];
            item.percent = [NSNumber numberWithDouble:[model.percent doubleValue]];
            item.amount = [NSNumber numberWithDouble:model.amount];
            item.avg_price = [NSNumber numberWithDouble:[model.avg_price doubleValue]];
            item.current = [NSNumber numberWithDouble:[model.current doubleValue]];
            [arr addObject:item];
        }
        
        [self.datas addObjectsFromArray:arr];
        self.dataSource.models = [self.datas copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.indexView.datas = [self.datas copy];
            [self.chartView drawChart];
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
