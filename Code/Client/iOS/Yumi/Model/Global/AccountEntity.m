//
//  Account.m
//  WandaKTV
//
//  Created by Wei Mao on 4/18/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "AccountEntity.h"
#import "TMCache.h"

@implementation AccountEntity

+ (AccountEntity *)shared{
    static AccountEntity *shared_ = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shared_ = [[AccountEntity alloc] init];
    });
    return shared_;
}
-(void)clear{
    self.uid = @"";
    self.name = @"";
    self.mobile = @"";
    self.picsrc = @"";
    self.email = @"";
}
-(NSString *)uid{
    return [[TMCache sharedCache] objectForKey:@"User_Uid"];
}
-(void)setUid:(NSString *)uid{
    [[TMCache sharedCache] setObject:uid forKey:@"User_Uid"];
}
-(NSString *)name{
    return [[TMCache sharedCache] objectForKey:@"User_Name"];
}
-(void)setName:(NSString *)name{
    [[TMCache sharedCache] setObject:name forKey:@"User_Name"];
}
-(NSString *)mobile{
    return [[TMCache sharedCache] objectForKey:@"User_Mobile"];
}
-(void)setMobile:(NSString *)mobile{
    [[TMCache sharedCache] setObject:mobile forKey:@"User_Mobile"];
}
-(NSString *)picsrc{
    return [[TMCache sharedCache] objectForKey:@"User_Picsrc"];
}
-(void)setPicsrc:(NSString *)picsrc{
    [[TMCache sharedCache] setObject:picsrc forKey:@"User_Picsrc"];
}
-(NSString *)email{
    return [[TMCache sharedCache] objectForKey:@"User_Email"];
}
-(void)setEmail:(NSString *)email{
    [[TMCache sharedCache] setObject:email forKey:@"User_Email"];
}

-(NSString *)token{
    return [[TMCache sharedCache] objectForKey:@"User_Token"];
}
-(void)setToken:(NSString *)token{
    [[TMCache sharedCache] setObject:token forKey:@"User_Token"];
}

-(NSString *)cids{
    return [[TMCache sharedCache] objectForKey:@"User_Cids"];
}
-(void)setCids:(NSString *)cids{
    [[TMCache sharedCache] setObject:cids forKey:@"User_Cids"];
}

-(NSString *)cidtimes{
    return [[TMCache sharedCache] objectForKey:@"User_CidTimes"];
}
-(void)setCidtimes:(NSString *)cidtimes{
    [[TMCache sharedCache] setObject:cidtimes forKey:@"User_CidTimes"];
}
-(NSArray *)myNewWords{
    return [[TMCache sharedCache] objectForKey:@"User_MyNewWords"];
}
-(void)setMyNewWords:(NSArray *)myNewWords{
    [[TMCache sharedCache] setObject:myNewWords forKey:@"User_MyNewWords"];
}


-(BOOL)isLogin{
    if (!self.uid) {
        return NO;
    }
    if ([self.uid isKindOfClass:[NSNumber class]]) {
        return self.uid>0;
    }
    if ([self.uid isKindOfClass:[NSString class]]) {
        return self.uid.length>0;
    }
    return NO;
}
@end
