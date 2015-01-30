//
//  AppConfigEntity.m
//  WandaKTV
//
//  Created by Wei Mao on 7/9/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "AppConfigEntity.h"
#import "TMMemoryCache.h"
#import "AppInfo.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "AppInfo.h"

#define kCurrentAppShortVersion        @"kCurrentAppShortVersion"
#define kCurrentAppStringVersion       @"kCurrentAppStringVersion"
#define kCurrentAppBuildNumber         @"kCurrentAppBuildNumber"
#define kForceUpgrade                  @"kForceUpgrade"
#define kUpgradeVersion                @"kUpgradeVersion"
#define kUpgradeText                   @"kUpgradeText"
#define kUpgradeUrl                    @"kUpgradeUrl"
#define kLastCheckUpgradeTime          @"kLastCheckUpgradeTime"
#define kLastUploadDeviceInfoTime      @"kLastUploadDeviceInfoTime"
#define kDeviceToken                   @"kDeviceToken"
#define kIntroGuideFlag                @"kIntroGuideFlag"
#define kPlugInSongPK                  @"kPlugInSongPK"

@interface AppConfigEntity()

@property (nonatomic, copy) NSString *imeiPrivate;

@end

@implementation AppConfigEntity

+ (AppConfigEntity *)shared{
    static AppConfigEntity *shared_ = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shared_ = [[AppConfigEntity alloc] init];
    });
    return shared_;
}
+(BOOL)isLatestVersion{
    if ([[self shared] upgradeVersion]) {
        return [[self shared] upgradeVersion]<=[AppConfigEntity currentAppNumberVersion];
    }
    return YES;
}
+(int)currentAppNumberVersion{
    return [AppInfo bundleShortVersionNumber];//1000;
}
+(NSString *)currentAppStringVersion{
    return [AppInfo bundleShortVersionString];//1.0.0
}
+(NSString *)currentAppBuildNumber{
    NSString *build = [[TMMemoryCache sharedCache] objectForKey:kCurrentAppBuildNumber];
    if (!build) {
        build = [AppInfo bundleVersion];//12345
        [[TMMemoryCache sharedCache] setObject:build forKey:kCurrentAppBuildNumber block:nil];
    }
    return build;
}
+(NSString *)appName{
    return [AppInfo appBundleIdentifier];
}
//版本升级
-(BOOL)forceUpgrade{
    BOOL force = [[NSUserDefaults standardUserDefaults] boolForKey:kForceUpgrade];
    if (force) {
        force = [self upgradeVersion]>[AppConfigEntity currentAppNumberVersion];
        [self setForceUpgrade:force];
    }
    return force;
}
-(void)setForceUpgrade:(BOOL)forceUpgrade{
    [[NSUserDefaults standardUserDefaults] setBool:forceUpgrade forKey:kForceUpgrade];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(int)upgradeVersion{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:kUpgradeVersion];
}
-(void)setUpgradeVersion:(int)upgradeVersion{
    [[NSUserDefaults standardUserDefaults] setInteger:upgradeVersion forKey:kUpgradeVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)upgradeText{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUpgradeText];
}
-(void)setUpgradeText:(NSString *)upgradeText{
    [[NSUserDefaults standardUserDefaults] setObject:upgradeText forKey:kUpgradeText];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)upgradeUrl{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUpgradeUrl];
}
-(void)setUpgradeUrl:(NSString *)upgradeUrl{
    [[NSUserDefaults standardUserDefaults] setObject:upgradeUrl forKey:kUpgradeUrl];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSTimeInterval)lastCheckUpgradeTime{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kLastCheckUpgradeTime];
}
-(void)setLastCheckUpgradeTime:(NSTimeInterval)lastCheckUpgradeTime{
    [[NSUserDefaults standardUserDefaults] setDouble:lastCheckUpgradeTime forKey:kLastCheckUpgradeTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSTimeInterval)lastUploadDeviceInfoTime{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kLastUploadDeviceInfoTime];
}
-(void)setLastUploadDeviceInfoTime:(NSTimeInterval)lastUploadDeviceInfoTime{
    [[NSUserDefaults standardUserDefaults] setDouble:lastUploadDeviceInfoTime forKey:kLastUploadDeviceInfoTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)deviceToken{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceToken];
}
-(void)setDeviceToken:(NSString *)deviceToken{
    NSString *str = [[[deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)imei
{
    return [AppInfo shared].IMEI;
}
- (NSString *)manufacture
{
    return @"Apple";
}

- (NSString *)channelCode
{
    return @"channel-appstore";
}

- (NSString *)localLanguages
{
    NSArray *arLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    return [arLanguages objectAtIndex:0];
}

- (NSString *)screenSize
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    return [NSString stringWithFormat:@"%.0f*%.0f*%.0f", size.width, size.height, scale];
}
//
-(BOOL)introGuideFlag{
    NSString *key = [kIntroGuideFlag stringByAppendingString:[AppConfigEntity currentAppStringVersion]];
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}
-(void)setIntroGuideFlag:(BOOL)introGuideFlag{
    NSString *key = [kIntroGuideFlag stringByAppendingString:[AppConfigEntity currentAppStringVersion]];
    [[NSUserDefaults standardUserDefaults] setInteger:introGuideFlag forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
