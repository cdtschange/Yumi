//
//  UserProvider.h
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YumiNetworkProvider.h"

@interface UserProvider : NSObject
+ (UserProvider *)shared;

-(void)clearCookies;
-(void)logout;

-(void)userLoginForUserName:(NSString *)userName passwd:(NSString *)passwd
                statusBlock:(void (^)(NetworkProviderStatus status, NSError *error))statusBlock
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
-(void)userInfoWithStatusBlock:(void (^)(NetworkProviderStatus status, NSError *error))statusBlock
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
-(void)loadUnreadMessage;


+(BOOL)validMobile:(NSString *)mobile;
+(BOOL)validEmail:(NSString *)email;

@end
