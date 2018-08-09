//
//  MapFileVC.m
//  sfsf
//
//  Created by Jinniu on 2018/7/31.
//  Copyright © 2018年 Jinniu. All rights reserved.
//

#import "MapFileVC.h"
#import "GetMapView.h"
#import "GetLocFile.h"
#import <MapKit/MapKit.h>
@interface MapFileVC (){
    GetMapView * v;
}
@property(nonatomic,retain)MKMapView * mapView;
@end

@implementation MapFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地图";
    self.view.backgroundColor = [UIColor whiteColor];
    v = [[GetMapView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 450)];
    v.isShowUser = YES;
    v.JQMapType = 0;
    v.isPutPin = YES;
//    v.isOpenUnlimitPut = YES;
    NSMutableArray * pinaRR = [NSMutableArray new];
    for (int i = 0 ; i< 3 ; i++) {
        JQAnnotation * an = [JQAnnotation new];
        an.title = [NSString stringWithFormat:@"标题%d",i];
        an.subtitle = [NSString stringWithFormat:@"副标题%d",i];
        an.icon = @"category_5";
//        an.detailIcon = @"me";
        [pinaRR addObject:an];
    }
    v.pinArray = pinaRR;
    v.isTrackUser = YES;//显示你现在的确切位置，会有一个缩放的动画
    
    //导航功能，跟上放注释不要混，虽然我也不知道混了会怎么样，应该没什么关系
//    NSString *address1 = @"北京";
//    NSString *address2 = @"广州";
//    //地理编码出2个位置
//    [v.geocoder geocodeAddressString:address1 completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error) return;
//
//        CLPlacemark *fromPm = [placemarks firstObject];
//
//        [self->v.geocoder geocodeAddressString:address2 completionHandler:^(NSArray *placemarks, NSError *error) {
//            if (error) return;
//
//            CLPlacemark *toPm = [placemarks firstObject];
//
//            [self->v addLineFrom:fromPm to:toPm andColor:[UIColor blueColor]];
//        }];
//    }];
    [self.view addSubview:v];
    
    //移除点击放大头针的功能
    UIButton * closeManage  = [[UIButton alloc]initWithFrame:CGRectMake(10, 64, 60, 60)];
    [closeManage addTarget:self action:@selector(closeBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    closeManage.backgroundColor = [UIColor redColor];
    [self.view addSubview:closeManage];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //代码添加大头针
//    CLLocationCoordinate2D corr = CLLocationCoordinate2DMake(35.653553826407951, 98.962031499999952);
//    [v pointTransformPin:corr title:@"标题1" subTitle:@"子标题1" animate:YES];
}
-(void)closeBtnCLick{
    [v removeTapGesture];
}
@end
