//
//  ViewController.m
//  TYChartsDemo
//
//  Created by 随遇而安 on 2023/12/26.
//  Copyright © 2023 ty. All rights reserved.
//

#import "ViewController.h"
#import "TYChartHeader.h"
#import "KLineViewController.h"
#import "TimeLineViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn1];
    [btn1 setTitle:@"分时" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(0, 100, self.view.ty_width, 40);
    btn1.backgroundColor = [UIColor blackColor];
    btn1.tag = 1;

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn2];
    [btn2 setTitle:@"日K" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame = CGRectMake(0, btn1.ty_bottom + 20, self.view.ty_width, 40);
    btn2.backgroundColor = [UIColor blackColor];
    btn2.tag = 2;
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 1) {
        TimeLineViewController *vc = [[TimeLineViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        KLineViewController *vc = [[KLineViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
