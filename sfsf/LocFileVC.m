//
//  LocFileVC.m
//  sfsf
//
//  Created by Jinniu on 2018/7/31.
//  Copyright © 2018年 Jinniu. All rights reserved.
//

#import "LocFileVC.h"
#import "GetLocFile.h"
@interface LocFileVC (){
    GetLocFile * file;//一定要用实例变量或者属性，不要用局部变量
}

@end

@implementation LocFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"定位";
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    file = [GetLocFile new];
    file.placeMarkBlock = ^(CLPlacemark *placeMark) {//获取定位信息
        NSLog(@"placeMark.country=%@,\n placeMark.name=%@,\n placeMark.locality = %@,\n placeMark.subLocality=%@",placeMark.country,placeMark.name,placeMark.locality, placeMark.subLocality);
        NSLog(@"+++++++++>%f,%f",placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);//获取当前定位的经纬度
    };
    [file VicGetLocationAuth];
    
    [file searchAroundWithLong:118.5855000000 andLat:24.8147900000 andBackBlock:^(MKLocalSearchResponse *response) {
        for(MKMapItem *mapItem in response.mapItems){
            NSLog(@"----------1>%@", mapItem.name);//获取周边信息
            NSLog(@"==========1>%f,%f",mapItem.placemark.location.coordinate.latitude,mapItem.placemark.location.coordinate.longitude);//获取周边信息的经纬度
        }
    }];
    
    [file searchAroundWithText:@"太子酒店" andBackBlock:^(MKLocalSearchResponse *response) {
        for(MKMapItem *mapItem in response.mapItems){
            NSLog(@"----------2>%@", mapItem.name);//获取周边信息
            NSLog(@"==========2>%f,%f",mapItem.placemark.location.coordinate.latitude,mapItem.placemark.location.coordinate.longitude);//获取周边信息的经纬度
        }
    }];
    //block要在方法前调用
    file.areaBlock = ^(AreaMonitorType areaType) {
        switch (areaType) {
            case AreaMonitorTypeIn:
                NSLog(@"进入区域");
                break;
            case AreaMonitorTypeOut:
                NSLog(@"离开区域");
                break;
            case AreaMonitorTypeUnknown:
                NSLog(@"不知道");
                break;
            case AreaMonitorTypeInside:
                NSLog(@"在区域内");
                break;
            case AreaMonitorTypeOutside:
                NSLog(@"在区域外");
                break;
            default:
                break;
        }
    };
    //调用这个方法需要开启后台定位
    [file MonitorAreaWithCenter:CLLocationCoordinate2DMake(24.873368, 118.561840) Radius:100];
}
@end
