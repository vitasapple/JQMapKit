# JQMapKit
map location 地图 定位
![img1](https://github.com/vitasapple/JQMapKit/blob/master/IMG_0002.PNG)![img1](https://github.com/vitasapple/JQMapKit/blob/master/IMG_0003.PNG)![img1](https://github.com/vitasapple/JQMapKit/blob/master/IMG_0004.PNG)![img1](https://github.com/vitasapple/JQMapKit/blob/master/IMG_0005.PNG)
## 封装系统地图一行代码调用

**是否厌倦了系统的地图繁琐的调用，又不想集成大厂的地图，明明我只要一个很简单的功能却让APP大了几十M(╯‵□′)╯︵┻━┻
现在一切都不再是梦，系统地图封装，一行代码调用，从此APP就是如此苗条\(^o^)/~**

### 敲黑板：该框架目前只提供系统地图的基础功能，需要花式地图的只能绕道 >.<

该框架集成简单，总共就六个文件，拖进去就OK。

- 支持获取定位经纬度
- 获取周边信息，区域判断，地图文件支持显示当前使用者位置
- 支持点击屏幕添加大头针 
- 支持点击屏幕无限制添加大头针 
- 支持点击屏幕添加自定义大头针 
- 自定义标题副标题，（ps：自定义大头针不支持无限制点击添加，需要实现确定好数目） 
- 支持一行代码移除点击添加大头针功能 
- 支持获取点击位置的经纬度
- 支持路径规划，支持自定义颜色的路径规划 
- 暂不支持导航（后期再加入）

- 定位相关文件**LocationKit**
- 地图相关文件**MapKit**

***

### 用法
 
- **LocationKit**

声明一个实例变量或者属性，不要用局部变量
```
@interface LocFileVC (){
    GetLocFile * file;//一定要用实例变量或者属性，不要用局部变量
}
```
#### 获取当前定位

```
file = [GetLocFile new];
    file.placeMarkBlock = ^(CLPlacemark *placeMark) {//获取定位信息
        NSLog(@"%@,%@,%@",placeMark.country,placeMark.name,placeMark.subLocality);
        NSLog(@"+++++++++>%f,%f",placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);//获取当前定位的经纬度
    };
[file VicGetLocationAuth];
```
#### 搜索周边

```
[file searchAroundWithText:@"太子酒店" andBackBlock:^(MKLocalSearchResponse *response) {
        for(MKMapItem *mapItem in response.mapItems){
            NSLog(@"---------->%@", mapItem.name);//获取周边信息
            NSLog(@"==========>%f,%f",mapItem.placemark.location.coordinate.latitude,mapItem.placemark.location.coordinate.longitude);//获取周边信息的经纬度
        }
}];
```
#### 判断是否进入一个区域
```
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
```

### **MapKit**
同样先声明一个实例变量或者属性
```
@interface MapFileVC (){
    GetMapView * v;
}
```

然后初始化它
```
v = [[GetMapView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 450)];
```
相关属性一览
```
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
//当前用户的定位大头针的点击出现的主标题
@property(nonatomic,copy)NSString * mainTitle;
//当前用户的定位大头针的点击出现的副标题
@property(nonatomic,copy)NSString * subMainTitle;
/**若要改变用户定位的图片则调用这个方法*/
- (instancetype)initWithFrame:(CGRect)frame withUserLocImage:(UIImage*)img;
```
### 地图的用法比较多，详细的看demo
