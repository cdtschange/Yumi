//
//  UserProvider.m
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "UserProvider.h"
#import "AccountEntity.h"
#import "GlobalConfig.h"

@interface UserProvider()

@end

@implementation UserProvider

+ (UserProvider *)shared{
    static UserProvider *shared_ = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shared_ = [[UserProvider alloc] init];
    });
    return shared_;
}
// 清除cookie
-(void)clearCookies
{
    [[YumiNetworkInfo shared] clearCookies];
}

//注销登录
-(void)logout{
    [[AccountEntity shared] clear];
    [self clearCookies];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RefreshLogin object:nil];
}


-(NSURLSessionDataTask *)userLoginForUserName:(NSString *)userName passwd:(NSString *)passwd
                    success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    __weak UserProvider *weakself = self;
    return [[UserLoginAPIData initWithUserName:userName passwd:passwd] requestWithSuccess:^(id responseObject) {
        UserLoginAPIData *data = responseObject;
        [AccountEntity shared].uid = data.uid;
        if (success) {
            success(responseObject);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RefreshLogin object:nil];
        [weakself userInfoWithSuccess:nil failure:nil];
    } failure:failure];
}

-(NSURLSessionDataTask *)userInfoWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    return [[UserProfileAPIData initWithTuid:[AccountEntity shared].uid] requestWithSuccess:^(id responseObject) {
        UserProfileAPIData *data = responseObject;
        [AccountEntity shared].uid = data.uid;
        [AccountEntity shared].name = data.u_name;
        [AccountEntity shared].mobile = data.account;
        [AccountEntity shared].picsrc = data.pic;
        if (success) {
            success(responseObject);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RefreshLogin object:nil];
    } failure:failure];
}

-(void)loadUnreadMessage{
    NSString *cids = [AccountEntity shared].cids;
    NSString *times = [AccountEntity shared].cidtimes;
    if (!cids||!times) {
        return;
    }
    [[UnreadChatsAPIData initWithCid:cids time:times] requestWithSuccess:^(id responseObject) {
        UnreadChatsAPIData *data = responseObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RefreshUnreadChat object:data];
    } failure:nil];
}

+(BOOL)validMobile:(NSString *)mobile{
    if (mobile.length!=11||![mobile hasPrefix:@"1"]) {
        return NO;
    }
    return YES;
}
+(BOOL)validEmail:(NSString *)email{
    //邮箱验证正则式
    //    NSString *expression = [NSString stringWithString:@"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"];
    NSString *expression = [NSString stringWithFormat:@"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"];
    NSError *error = NULL;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    if (match){
        return YES;
    }else{
        return NO;
    }
}
@end
