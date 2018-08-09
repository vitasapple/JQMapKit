//
//  GetMapView.m
//  sfsf
//
//  Created by Jinniu on 2018/7/31.
//  Copyright © 2018年 Jinniu. All rights reserved.
//

#import "GetMapView.h"

#import "GetLocFile.h"
@interface GetMapView ()<MKMapViewDelegate>{
    GetLocFile * _file;
    UITapGestureRecognizer * _tmpTap;
    UIColor * _directiNavColor/*导航路线颜色*/;
}

@property (nonatomic,strong) CLLocationManager * locationManager;
@end
@implementation GetMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _file = [GetLocFile new];
        self.locationManager = [_file ShareLocationManager];
        self.delegate = self;
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}
- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
-(MKMapView*)shareMapView{
    return self;
}
-(CLLocationManager *)ShareLocationManager{
    return self.locationManager;
}
- (void)tapMapView:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:tap.view];
    CLLocationCoordinate2D coordinate = [self convertPoint:point toCoordinateFromView:self];
    if (self.getPutLocBlock) {
        self.getPutLocBlock(coordinate);
    }
    JQAnnotation *anno = [[JQAnnotation alloc] init];
    anno.coordinate = coordinate;
    if (_pinArray.count>0) {
        JQAnnotation * an = _pinArray[0];
        anno.title = an.title;
        anno.subtitle = an.subtitle;
        anno.icon = an.icon;
        [_pinArray removeObjectAtIndex:0];
    }
    [self addAnnotation:anno];
}
-(void)removeTapGesture{
    if (self.isPutPin) {
        self.isPutPin = NO;
        [self removeGestureRecognizer:_tmpTap];
    }
}
- (void)addLineFrom:(CLPlacemark *)fromPm to:(CLPlacemark *)toPm andColor:(UIColor*)col{
    _directiNavColor = col;
    // 1.根据编码的位置添加2个大头针
    JQAnnotation *fromAnno = [[JQAnnotation alloc] init];
    fromAnno.coordinate = fromPm.location.coordinate;
    fromAnno.title = fromPm.name;
    [self addAnnotation:fromAnno];
    
    JQAnnotation *toAnno = [[JQAnnotation alloc] init];
    toAnno.coordinate = toPm.location.coordinate;
    toAnno.title = toPm.name;
    [self addAnnotation:toAnno];
    // 2.查找路线
    // 方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    // 设置起点
    MKPlacemark *sourcePm = [[MKPlacemark alloc] initWithPlacemark:fromPm];
    request.source = [[MKMapItem alloc] initWithPlacemark:sourcePm];
    // 设置终点
    MKPlacemark *destinationPm = [[MKPlacemark alloc] initWithPlacemark:toPm];
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationPm];
    // 方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    // 计算路线
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
//        NSLog(@"总共=====%d条路线", response.routes.count);
        // 遍历所有的路线
        for (MKRoute *route in response.routes) {
            // 添加路线遮盖(就回调用下面的代理方法)
            /*
             注意：这里不像添加大头针那样，只要我们添加了大头针模型，默认就会在地图上添加系统的大头针视图
             添加覆盖层，需要我们实现对应的代理方法，在代理方法中返回对应的覆盖层
             */
            [self addOverlay:route.polyline];
        }
    }];
}
#pragma mark set方法
-(void)setIsShowUser:(BOOL)isShowUser{
    _isShowUser = isShowUser;
    self.showsUserLocation = isShowUser;
}
-(void)setJQMapType:(MKMapType)JQMapType{
    _JQMapType = JQMapType;
    self.mapType = JQMapType;
}
-(void)setIsTrackUser:(BOOL)isTrackUser{
    _isTrackUser = isTrackUser;
    if (self.isTrackUser) {
        [self.locationManager requestAlwaysAuthorization];
        self.userTrackingMode = MKUserTrackingModeFollow;
    }
}
-(void)setIsPutPin:(BOOL)isPutPin{
    _isPutPin = isPutPin;
    if (isPutPin) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMapView:)];
        _tmpTap = tap;
        [self addGestureRecognizer:tap];
    }
}
-(void)setPinArray:(NSMutableArray<JQAnnotation *> *)pinArray{
    _pinArray = pinArray;
}
-(void)setIsOpenUnlimitPut:(BOOL)isOpenUnlimitPut{
    _isOpenUnlimitPut = isOpenUnlimitPut;
}
#pragma  mark -MKMapViewDelegate
/*
 当用户的位置更新，就会调用（不断地监控用户的位置，调用频率特别高）
 userLocation 表示地图上蓝色那颗大头针的数据
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//1.给userLocation设置数据
    userLocation.title = @"我是主标题";
    userLocation.subtitle = @"我是子标题";
//2. 设置显示地图的中心点(将当前用户的位置设置为地图的中心点)
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//3. 设置地图的展示范围，我们如何拿到这个范围呢: 1. 实现下面的代理方法. 2. 拖动地图放大,一直放到认为合适的位置 3    . 在下面代理方法中,拿到相应的span
    MKCoordinateSpan span = MKCoordinateSpanMake(0.021321, 0.019366);
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [mapView setRegion:region animated:YES];
}
/*用户缩放时,就会调用,该方法可用于调试出适合的跨度,然后用到setRegion方法中*/
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    NSLog(@"%f %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
}
-(void)pointTransformPin:(CLLocationCoordinate2D)point title:(NSString*)title subTitle:(NSString*)subTitle icon:(NSString*)iconName animate:(BOOL)animate{
    if (self) {
        JQAnnotation *anno = [[JQAnnotation alloc] init];
        anno.title = title;
        anno.subtitle = subTitle;
        anno.coordinate = point;
        if (iconName.length>0) {
            anno.icon = iconName;
        }
        [self addAnnotation:anno];
    }else{
        NSLog(@"地图尚未创建");
    }
}
/*
 Overlay: 遮盖的意思
 跟这个方法很相似(根据模型返回大头针视图)
 - (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
 那么这个方法就是根据overlay模型来返回遮盖
 MKPolyline系统自带的overlay模型
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = _directiNavColor==nil?[UIColor redColor]:_directiNavColor;
    return renderer;
}
#pragma mark MKMapViewDelegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if (self.isOpenUnlimitPut) return nil;
    //用户位置这个大头针不是JQAnnotation 而是(MKUserLocation *)userLocation
    if (![annotation isKindOfClass:[JQAnnotation class]]) return nil;
    static NSString *ID = @"tuangou";
    // 从缓存池中取出可以循环利用的大头针view
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        annoView.canShowCallout = YES;//点击大头针,显示标题和子标题
        annoView.calloutOffset = CGPointMake(0, -10);//设置大头针的偏移量
    }
    // 传递模型
    annoView.annotation = annotation;
    //设置图片
    JQAnnotation *anno = annotation;
    annoView.image = [UIImage imageNamed:anno.icon];
    return annoView;
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view isKindOfClass:[JQAnnotation class]]) { //点击自定义的大头针视图

    }else{ //点击系统自带的大头针视图
        //1.拿到系统自带大头针的模型
//        JQAnnotation * anno = view.annotation;
        
    }
}
@end
