//
//  AppConfigEntity.h
//  WandaKTV
//
//  Created by Wei Mao on 7/9/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfigEntity : NSObject
+ (AppConfigEntity *)shared;

+(BOOL)isLatestVersion;//是否是最新版本
+(NSString *)currentAppBuildNumber;//当前的AppBuild版本号
+(int)currentAppNumberVersion;
+(NSString *)currentAppStringVersion;//当前的App字符串版本
+(NSString *)appName;
//版本升级
@property (nonatomic, assign) BOOL forceUpgrade;//是否强制用户升级
@property (nonatomic, assign) int upgradeVersion;//强制用户升级到的版本
@property (nonatomic, copy) NSString *upgradeText;//强制用户升级文本
@property (nonatomic, copy) NSString *upgradeUrl;//强制用户升级跳转网址
@property (nonatomic, assign) NSTimeInterval lastCheckUpgradeTime;//上一次检查升级时间
@property (nonatomic, assign) NSTimeInterval lastUploadDeviceInfoTime;//上一次上传设备信息时间
@property (nonatomic, copy) NSString *deviceToken;//设备的Token
@property (nonatomic, readonly) NSString *imei;
@property (nonatomic, readonly) NSString *manufacture;
@property (nonatomic, readonly) NSString *channelCode;
@property (nonatomic, readonly) NSString *localLanguages;
@property (nonatomic, readonly) NSString *screenSize;
//引导页
@property (nonatomic, assign) BOOL introGuideFlag;//启动引导页的标志

@end
