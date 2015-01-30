//
//  UserProvider.m
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "UserProvider.h"
#import "AccountEntity.h"
#import "YumiNetworkInfo.h"
#import "YumiNetworkProvider.h"
#import "GlobalConfig.h"

@interface UserProvider()

@property(nonatomic, strong)    NetworkProvider  *networkProvider;
@property(nonatomic, strong)    NetworkProvider  *unreadProvider;

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


-(void)userLoginForUserName:(NSString *)userName passwd:(NSString *)passwd
                     statusBlock:(void (^)(NetworkProviderStatus status, NSError *error))statusBlock
                    success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    YumiNetworkProvider *provider = [YumiNetworkProvider new];
    [provider userLoginForUserName:userName passwd:passwd];
    self.networkProvider = provider;
    self.networkProvider.statusBlock = statusBlock;
    [provider requestWithSuccess:^(id responseObject) {
        UserLoginData *data = responseObject;
        [AccountEntity shared].uid = data.uid;
//        [AccountEntity shared].name = data.user.u_name;
//        [AccountEntity shared].mobile = data.user.mobile;
//        [AccountEntity shared].picsrc = data.user.pic;
//        [AccountEntity shared].token = data.user.token;
        if (success) {
            success(responseObject);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RefreshLogin object:nil];
        [self userInfoWithStatusBlock:nil success:nil failure:nil];
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)userInfoWithStatusBlock:(void (^)(NetworkProviderStatus, NSError *))statusBlock success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    YumiNetworkProvider *provider = [YumiNetworkProvider new];
    [provider profileForTuid:[AccountEntity shared].uid];
    self.networkProvider = provider;
    self.networkProvider.statusBlock = statusBlock;
    [provider requestWithSuccess:^(id responseObject) {
        ProfileData *data = responseObject;
        [AccountEntity shared].uid = data.uid;
        [AccountEntity shared].name = data.u_name;
        [AccountEntity shared].mobile = data.account;
        [AccountEntity shared].picsrc = data.pic;
        if (success) {
            success(responseObject);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RefreshLogin object:nil];
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)loadUnreadMessage{
    YumiNetworkProvider *provider = [YumiNetworkProvider new];
    NSString *cids = [AccountEntity shared].cids;
    NSString *times = [AccountEntity shared].cidtimes;
    if (!cids||!times) {
        return;
    }
    [provider unreadChatsForCid:cids time:times];
    self.unreadProvider = provider;
    provider.statusBlock = nil;
    [provider requestWithSuccess:^(id responseObject) {
        UnreadChatsData *data = responseObject;
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
