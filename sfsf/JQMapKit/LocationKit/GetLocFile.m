//
//  GetLocFile.m
//  O2OUser
//
//  Created by 金牛 on 2018/4/16.
//  Copyright © 2018年 vicnic. All rights reserved.
//

#import "GetLocFile.h"

@interface GetLocFile()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager * locationManager;
@end
@implementation GetLocFile
-(void)VicGetLocationAuth{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        if (self.authBlock) {
            self.authBlock(AuthLocationUnOpen);
        }
    }else{
        [self startLocation];
    }
}
-(CLLocationManager *)ShareLocationManager{
    CLLocationManager * loc = nil;
    if (_locationManager == nil) {
        loc=[[CLLocationManager alloc]init];
        //设置代理
        loc.delegate=self;
        return loc;
    }
    return _locationManager;
}
-(void)startLocation{
    self.locationManager = [self ShareLocationManager];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    }else{
        self.locationManager.desiredAccuracy=self.locationAccuracy==0?kCLLocationAccuracyBest:self.locationAccuracy;
        CLLocationDistance distance=self.limitDistance==0?10:self.limitDistance;
        self.locationManager.distanceFilter=distance;
        [self.locationManager startUpdatingLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            if (self.placeMarkBlock) {
                self.placeMarkBlock(placemark);
            }
        }
    }];
    [self.locationManager stopUpdatingLocation];
}
-(void)getLocationInfoByLongtitude:(CGFloat)longitude lat:(CGFloat)latitude andBackBlock:(LocationInfoBlock)sblcok{
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [clGeoCoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks,NSError *error) {
        if (!error) {
            sblcok(placemarks);
        }
    }];
}
-(void)searchAroundWithText:(NSString*)text coordinate:(CLLocationCoordinate2D)coor2D range:(CGFloat)range andBackBlock:(SearchLocTextBlock)sblcok{
    int flag = 0;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    
    if (coor2D.latitude>0 && coor2D.longitude>0 && range>0) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coor2D,range, range);
        request.region = region;
        flag ++ ;
    }
    if (text.length>0) {
        request.naturalLanguageQuery = text;
        flag ++;
    }
    if (flag ==0) {
        NSLog(@"---->>内容文本或者经纬度至少要传一个<<---");
        return;
    }
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (!error) {
            sblcok(response);
        }else{
            NSLog(@"GetLocFile.m lines:68 error : %@",error);
        }
    }];
}
#pragma mark 区域监听方法和代理
-(void)MonitorAreaWithCenter:(CLLocationCoordinate2D)center Radius:(double)radius{
    self.locationManager = [self ShareLocationManager];
    [self.locationManager requestAlwaysAuthorization];
    CLLocationDistance distance = radius;
    if (radius>self.locationManager.maximumRegionMonitoringDistance) {
        NSLog(@"监听区域超过了最大值，将调用系统最大值");
        radius = self.locationManager.maximumRegionMonitoringDistance;
    }
    CLRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:distance identifier:@"vic_areaidentify"];
    //class: 监听的区域是什么种类: 圆形(CLCircularRegion)
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        //2. 监听区域
        [self.locationManager startMonitoringForRegion:region];
        //2.1 请求当前区域的状态(程序已启动,先查看当前位置是不是在对应区域内)
        [self.locationManager requestStateForRegion:region];
    }else{
        NSLog(@"不能监听区域");
    }
}
//进入区域时调用
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if (self.areaBlock) {
        self.areaBlock(AreaMonitorTypeIn);
    }
}
//离开区域时调用
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    if (self.areaBlock) {
        self.areaBlock(AreaMonitorTypeOut);
    }
}
/*
 情况:
 因为上面的两个代理方法,只有在动作即区域改变的时候才会调用,但是在有些时候,程序加载之后,我就要展示当前位置是否在区域内,这就需要这个代理方法了
 该代理方法跟: [self.locationManager requestStateForRegion:region];结合使用
 */
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    switch (state) {
        case CLRegionStateUnknown:{
            if (self.areaBlock) {
                self.areaBlock(AreaMonitorTypeUnknown);
            }
        }break;
        case CLRegionStateInside:{
            if (self.areaBlock) {
                self.areaBlock(AreaMonitorTypeInside);
            }
        }break;
        case CLRegionStateOutside:{
            if (self.areaBlock) {
                self.areaBlock(AreaMonitorTypeOutside);
            }
        }break;
        default:
            break;
    }
}
#pragma mark 监控用户会否授权
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self startLocation];
    }
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{//NSLog(@"用户还未决定授权");
        }break;
        case kCLAuthorizationStatusRestricted:{//NSLog(@"访问受限");
            if (self.authBlock) {
                self.authBlock(AuthLocationLimit);
            }
        }break;
        case kCLAuthorizationStatusDenied:{
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                //                NSLog(@"定位服务开启，被拒绝");
                if (self.authBlock) {
                    self.authBlock(AuthLocationRefuse);
                }
            } else {
                //                NSLog(@"定位服务关闭，不可用");
                if (self.authBlock) {
                    self.authBlock(AuthLocationUnOpen);
                }
            }
        }break;
        case kCLAuthorizationStatusAuthorizedAlways:{//NSLog(@"获得前后台授权");
            if (self.authBlock) {
                self.authBlock(AuthLocationAccept);
            }
        }break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:{//NSLog(@"获得前台授权");
            if (self.authBlock) {
                self.authBlock(AuthLocationAccept);
            }
        }break;
        default:
            break;
    }
}
@end
