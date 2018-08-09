//
//  GetMapView.h
//  sfsf
//
//  Created by Jinniu on 2018/7/31.
//  Copyright © 2018年 Jinniu. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "JQAnnotation.h"
typedef void (^GetPutPinLoc)(CLLocationCoordinate2D coor2D);
@interface GetMapView : MKMapView
/**获取定位管理者*/
-(CLLocationManager *)ShareLocationManager;
/**获取当前地图对象*/
-(MKMapView*)shareMapView;
/**将经纬度转为大头针*/
-(void)pointTransformPin:(CLLocationCoordinate2D)point title:(NSString*)title subTitle:(NSString*)subTitle icon:(NSString*)iconName animate:(BOOL)animate;
/**移除点击放大头针的手势*/
-(void)removeTapGesture;
/**给两个地点绘制导航路线,颜色传nil默认redColor*/
- (void)addLineFrom:(CLPlacemark *)fromPm to:(CLPlacemark *)toPm andColor:(UIColor*)col;
/**
 MKMapTypeStandard = 0, 普通地图
 MKMapTypeSatellite,    卫星云图
 MKMapTypeHybrid,       混合模式（普通地图覆盖于卫星云图之上 ）
 MKMapTypeSatelliteFlyover  3D立体卫星 （iOS9.0）
 MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
 MKMapTypeMutedStandard NS_ENUM_AVAILABLE(10_13, 11_0)
 */
@property(nonatomic)MKMapType JQMapType;
//是否显示用户位置 默认不显示
@property(nonatomic,assign)BOOL isShowUser;
//是否追踪用户位置 默认不追踪
@property(nonatomic,assign)BOOL isTrackUser;
//是否开启点击地图放大头针的功能
@property(nonatomic,assign)BOOL isPutPin;
//如果开启了点击地图放大头针，看是否要返回点击的经纬度
@property(nonatomic,copy)GetPutPinLoc getPutLocBlock;
//是否开启无限制点击就放大头针的功能，默认系统大头针图片
@property(nonatomic,assign)BOOL isOpenUnlimitPut;
@property (nonatomic, strong) CLGeocoder *geocoder;
/**设置放置的大头针的标题副标题
 如果点击的数超过数组个数，比如设置三个，但是点击了八次屏幕，则后五次都默认没有标题副标题
 如果要在中间的数组没有标题副标题，则JQAnnotation对象的title和subtitle传空字符串
 如果要自定义图片，则必须传pinArray，如果isOpenUnlimitPut=YES的话默认这个属性失效
 */
@property(nonatomic,retain)NSMutableArray <JQAnnotation*> * pinArray;
@end
