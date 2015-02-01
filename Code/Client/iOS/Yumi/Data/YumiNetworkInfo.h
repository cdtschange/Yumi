//
//  G2RNetworkInfo.h
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import <Foundation/Foundation.h>

// 设备信息
typedef enum DeviceClientType {
    kDeviceClientIOS                        =           1,      // iOS设备
    kDeviceClientAndroid                    =           2,      // Android设备
    kDeviceClientWeb                        =           3,      // Web方式
}DeviceClientType;

typedef enum ApiAddressType {
    kApiAddressDev                          =           1,      // 开发环境
    kApiAddressTest                         =           2,      // 灰度环境
    kApiAddressPre                          =           3,      // 预发布环境
    kApiAddressProduct                      =           4,      // 线上环境
}ApiAddressType;

@interface YumiNetworkInfo : NSObject

- (void)clearCookies;

+ (ApiAddressType)apiAddress;

- (int)apiVersion;

#pragma mark -
#pragma mark Server URL
+ (NSString *)baseURL;
+ (NSString *)baseUCenterURL;
+ (NSString *)imageServerURLFormat;
+ (NSString *)imageSmallWithUrl:(NSString *)headURL;
+ (NSString *)imageMiddleURLWithHead:(NSString *)headURL;
+ (NSString *)imageBigURLWithHead:(NSString *)headURL;
+ (NSString *)imageOrigURLWithHead:(NSString *)headURL;

#pragma mark - Signal Mode
+ (YumiNetworkInfo *)shared;
+ (void)releaseInstance;

@end

@interface NSString(ImageURL)

- (NSString *)imageSmall;

@end
