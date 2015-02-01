//
//  G2RNetworkInfo.m
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "YumiNetworkInfo.h"
#import "AccountEntity.h"
#import "AppConfigEntity.h"

@implementation YumiNetworkInfo

// 此处的代码是配置服务器地址的
+ (ApiAddressType)apiAddress
{
    return SERVER_IS_PRODUCT?kApiAddressProduct:kApiAddressTest;
}

+ (NSString *)baseURL
{
    switch ([YumiNetworkInfo apiAddress]) {
        case kApiAddressTest:
            return SERVER_HOST_TEST;
        case kApiAddressProduct:
            return SERVER_HOST_PRODUCT;
        default:
            return @"";
    }
}
+ (NSString *)baseUCenterURL
{
    switch ([YumiNetworkInfo apiAddress]) {
        case kApiAddressTest:
            return SERVER_UCENTER_HOST_TEST;
        case kApiAddressProduct:
            return SERVER_UCENTER_HOST_PRODUCT;
        default:
            return @"";
    }
}


-(void)clearCookies{
    NSURL *url = [NSURL URLWithString:[YumiNetworkInfo baseURL]];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
//    [YumiNetworkProvider clearCookies];
}

- (int)apiVersion
{
    return 1;
}


#pragma mark -
#pragma mark Server URL
+ (NSString *)imageServerURLFormat
{
    switch ([YumiNetworkInfo apiAddress]) {
        case kApiAddressTest:
            return SERVER_IMAGE_HOST_TEST;
        case kApiAddressProduct:
            return SERVER_IMAGE_HOST_PRODUCT;
        default:
            return @"";
    }
}

+ (NSString *)imageURLWithHead:(NSString *)headURL type:(NSString *)type
{
    NSString *url_idstr = headURL;
    int hashid = 0;


    NSString *format = [NSString stringWithFormat:@"%@/%@%@", [YumiNetworkInfo imageServerURLFormat], type,headURL];
    if (url_idstr.length > 0) {
        hashid = [[NSNumber numberWithChar:[url_idstr characterAtIndex:0]] intValue]%4;
    }
    return [NSString stringWithFormat:format, hashid];
}

+ (NSString *)imageSmallWithUrl:(NSString *)headURL
{
    return [YumiNetworkInfo imageURLWithHead:headURL type:@""];
}
+ (NSString *)imageMiddleURLWithHead:(NSString *)headURL
{
    return [YumiNetworkInfo imageURLWithHead:headURL type:@"singmiddle"];
}
+ (NSString *)imageBigURLWithHead:(NSString *)headURL
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[headURL split:@"/"]];
    if (arr.count>1) {
        [arr insertObject:@"d" atIndex:1];
        NSString *str = [arr componentsJoinedByString:@"/"];
        return [YumiNetworkInfo imageURLWithHead:str type:@""];
    }
    return [YumiNetworkInfo imageURLWithHead:headURL type:@""];
}
+ (NSString *)imageOrigURLWithHead:(NSString *)headURL
{
    return [YumiNetworkInfo imageURLWithHead:headURL type:@"orig"];
}





#pragma mark - Singal Instance
static YumiNetworkInfo *sharedInstance = nil;
#pragma mark - Constructor And Destructor
- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - Singleton Model
+ (YumiNetworkInfo *)shared
{
    @synchronized(self) {
        if(sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (void)releaseInstance
{
    sharedInstance = nil;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if(sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


@end

@implementation NSString(ImageURL)

-(NSString *)imageSmall{
    return [YumiNetworkInfo imageURLWithHead:self type:@""];
}

@end