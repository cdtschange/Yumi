//
//  Account.h
//  WandaKTV
//
//  Created by Wei Mao on 4/18/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountEntity : NSObject

+ (AccountEntity *)shared;

-(void)clear;

@property(nonatomic, copy)      NSString        *uid;
@property(nonatomic, copy)      NSString        *name;
@property(nonatomic, copy)      NSString        *username;
@property(nonatomic, copy)      NSString        *mobile;
@property(nonatomic, copy)      NSString        *picsrc;
@property(nonatomic, copy)      NSString        *email;
@property(nonatomic, copy)      NSString        *token;

@property(nonatomic, copy)      NSString        *cids;
@property(nonatomic, copy)      NSString        *cidtimes;


@property(nonatomic, strong)      NSArray        *myNewWords;

-(BOOL)isLogin;

@end
