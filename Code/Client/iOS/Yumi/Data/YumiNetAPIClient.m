//
//  YumiNetAPIClient.m
//  Yumi
//
//  Created by Mao on 15/2/1.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import "YumiNetAPIClient.h"
#import "YumiNetAPIData.h"
#import "UserProvider.h"
#import "JSONKit.h"

#define STATUS_CODE_SUCCESS 0

@implementation YumiNetAPIClient

+ (instancetype)shared{
    static YumiNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [YumiNetAPIClient sharedWithBaseURL:[YumiNetworkInfo baseURL]];
        _sharedClient.apiBaseParams = @{
                                     //     @"version":[NSString stringWithFormat:@"%d", [[YumiNetworkInfo shared] apiVersion]],
                                     //     @"imei":[[AppConfigEntity shared] imei],
                                     //     @"clientversion":[NSString stringWithFormat:@"%d", AppConfigEntity.currentAppNumberVersion],
                                     //     @"clienttype":[NSString stringWithFormat:@"%d", kDeviceClientIOS],
                                     };
    });
    
    return _sharedClient;
}
-(BOOL)shouldCacheWithUrl:(NSString *)url params:(id)parameters data:(NSString *)data{
    id json = [data objectFromJSONString];
    YumiNetAPIData *apidata = [YumiNetAPIData jsonToObj:json];
    if (apidata.status == STATUS_CODE_SUCCESS) {
        return YES;
    }
    return NO;
}
-(NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler{
    return [super dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
        if (!error) {
            YumiNetAPIData *data = [YumiNetAPIData jsonToObj:responseObject];
            if (data.status != STATUS_CODE_SUCCESS) {
                NSError *newError = [NSError errorWithDomain:@"" code:data.status userInfo:@{@"msg":data.msg}];
                if (completionHandler) {
                    completionHandler(response, responseObject, newError);
                }
                NSLog(@"%@",error);
                if (error.code == CONST_NEED_RELOGIN_CODE) {
                    [[UserProvider shared] logout];
                }
                return;
            }
        }
        if (completionHandler) {
            completionHandler(response, responseObject, error);
        }
    }];
}
@end
