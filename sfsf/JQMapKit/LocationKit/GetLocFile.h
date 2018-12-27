//
//  GetLocFile.h
//  O2OUser
//
//  Created by 金牛 on 2018/4/16.
//  Copyright © 2018年 vicnic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, AreaMonitorType) {
    AreaMonitorTypeIn,          //进入了区域
    AreaMonitorTypeOut,         //离开了区域
    AreaMonitorTypeUnknown,     //不知是否在区域内
    AreaMonitorTypeInside,      //在区域内
    AreaMonitorTypeOutside,     //在区域外
};

typedef void (^UnopenLocServiceBlock)(void);
typedef void (^PlaceMrakBlock)(CLPlacemark* placeMark);
typedef void (^SearchLocTextBlock)(MKLocalSearchResponse * response);
typedef void (^AreaMonitorBlock)(AreaMonitorType areaType);
@interface GetLocFile : NSObject
//获取定位管理者
-(CLLocationManager *)ShareLocationManager;
/** 获取当前定位的位置信息
 配合placeMarkBlock使用：
 country            -> 国家
 administrativeArea -> 省 直辖市
 locality           -> 地级市 直辖市区
 subLocality        -> 县 区
 thoroughfare       -> 街道
 subThoroughfare    -> 子街道
 */
-(void)VicGetLocationAuth;

/**根据经纬度获取该经纬度对应的位置信息，定位信息默认在PlaceMrakBlock中返回
 */
-(void)getLocationInfoWithLong:(CGFloat)lng andLat:(CGFloat)lat andBackBlock:(PlaceMrakBlock)placeBlcok;

/** 根据给定的字符串返回附近的地址
 MKLocalSearchResponse的主要属性:
 name               -> 附近地名
 phoneNumber        -> 电话号码（没卵用）
 url
 timeZone           -> 时区
 isCurrentLocation  -> 是否是当前位置
 */
-(void)searchAroundWithText:(NSString*)text andBackBlock:(SearchLocTextBlock)sblcok;
/** 根据给定的经纬度返回附近的地址
 MKLocalSearchResponse的主要属性:
 name               -> 附近地名
 phoneNumber        -> 电话号码（没卵用）
 url
 timeZone           -> 时区
 isCurrentLocation  -> 是否是当前位置
 */
-(void)searchAroundWithLong:(CGFloat)lng andLat:(CGFloat)lat andBackBlock:(SearchLocTextBlock)sblcok;

/**区域监听中心：center
 区域监听半径：  Radius
 CLLocationCoordinate2DMake(x, y);
 */
-(void)MonitorAreaWithCenter:(CLLocationCoordinate2D)center Radius:(double)radius;

/** 定位精度，默认kCLLocationAccuracyBest
 kCLLocationAccuracyBestForNavigation  最精准
 kCLLocationAccuracyBest;              最好的,米级
 kCLLocationAccuracyNearestTenMeters;  十米
 kCLLocationAccuracyHundredMeters;     百米
 kCLLocationAccuracyKilometer;         一公里
 kCLLocationAccuracyThreeKilometers;   三公里
 */
@property(assign, nonatomic) CLLocationAccuracy locationAccuracy;

//调用代理方法的极限距离 例如：设置为10，表示距离移动超过十米，才会调用代理方法
@property(assign, nonatomic) double limitDistance;

//监听区域后返回的状态
@property(nonatomic,copy)AreaMonitorBlock areaBlock;
//未开启定位
@property(nonatomic,copy)UnopenLocServiceBlock unOpenBlock;
/**返回当前定位的位置信息*/
@property(nonatomic,copy)PlaceMrakBlock placeMarkBlock;
/**使用经纬度返回附近的地址的时候用到的搜索周边的范围，默认500米
 */
@property(nonatomic,assign)CGFloat radius;
@end
