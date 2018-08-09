//
//  ViewController.m
//  sfsf
//
//  Created by Jinniu on 2018/7/30.
//  Copyright © 2018年 Jinniu. All rights reserved.
//

#import "ViewController.h"
#import "LocFileVC.h"
#import "MapFileVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * locBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [locBtn addTarget:self action:@selector(locBtnClick) forControlEvents:UIControlEventTouchUpInside];
    locBtn.backgroundColor = [UIColor lightGrayColor];
    [locBtn setTitle:@"定位" forState:UIControlStateNormal];
    [self.view addSubview:locBtn];
    
    UIButton * mapBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 180, 50, 50)];
    [mapBtn addTarget:self action:@selector(mapBtnClick) forControlEvents:UIControlEventTouchUpInside];
    mapBtn.backgroundColor = [UIColor lightGrayColor];
    [mapBtn setTitle:@"地图" forState:UIControlStateNormal];
    [self.view addSubview:mapBtn];
}
-(void)locBtnClick{
    [self.navigationController pushViewController:[LocFileVC new] animated:YES];
}
-(void)mapBtnClick{
    [self.navigationController pushViewController:[MapFileVC new] animated:YES];
}
@end
