//
//  JQAnnotation.h
//  sfsf
//
//  Created by Jinniu on 2018/7/31.
//  Copyright © 2018年 Jinniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface JQAnnotation : NSObject<MKAnnotation>
/** 坐标位置 */
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subtitle;
//大头针图片
@property (nonatomic,strong) NSString *icon;
@end
