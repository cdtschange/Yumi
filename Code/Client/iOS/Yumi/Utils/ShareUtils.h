//
//  ShareUtils.h
//  WandaKTV
//
//  Created by Wei Mao on 7/19/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    kShareNone = 0,
    kShareSina = 1,
    kShareWeChat = 2,
    kShareWeChatToFriend = 3,
    kShareQQFriend = 4,
} ShareType;

@interface ShareUtils : NSObject

+ (ShareUtils *)shared;
//分享
- (void)shareWithText:(NSString *)text;
@end
