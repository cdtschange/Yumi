//
//  UserProvider.h
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YumiNetAPIData.h"

@interface UserProvider : NSObject
+ (UserProvider *)shared;

-(void)clearCookies;
-(void)logout;

-(NSURLSessionTask *)userLoginForUserName:(NSString *)userName passwd:(NSString *)passwd
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
-(NSURLSessionTask *)userInfoWithSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
-(void)loadUnreadMessage;


+(BOOL)validMobile:(NSString *)mobile;
+(BOOL)validEmail:(NSString *)email;

@end
