//
//  G2RNetworkProvider.h
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkProvider.h"
#import "YumiNetworkData.h"


typedef enum UserExistType {
    UserExistTypeMobile = 1,
    UserExistTypeNick,
}UserExistType;
typedef enum ChatType {
    ChatTypeText = 1,
    ChatTypeTextM,
    ChatTypeVoice,
    ChatTypeImage,
}ChatType;

@interface YumiNetworkProvider : NetworkProvider<NetworkProviderProtocal>

-(void)useCache:(BOOL)cache;
+(NSString *)errorToString:(NSError *)error;

#pragma mark - Interface

-(void)userCreateForUserName:(NSString *)userName mobile:(NSString *)mobile passwd:(NSString *)passwd;
-(void)userLoginForUserName:(NSString *)userName passwd:(NSString *)passwd;
-(void)userExistForValue:(NSString *)value type:(UserExistType)type;
-(void)userLogout;

-(void)chatsForStart:(int)start num:(int)num;
-(void)chatForCid:(NSString *)cid;
-(void)users;
-(void)userRequests;
-(void)nearUserForLon:(double)lon lat:(double)lat;
-(void)topicsForStart:(int)start num:(int)num;
-(void)myTopics;
-(void)topicForTid:(NSString *)tid;
-(void)topicRepliesForTid:(NSString *)tid sort:(NSString *)sort;
-(void)topicReplyCommentsForTrid:(NSString *)trid;
-(void)topicFollowersForTid:(NSString *)tid;
-(void)profileForTuid:(NSString *)tuid;
-(void)addUserForTuid:(NSString *)tuid reason:(NSString *)reason;
-(void)acceptUserForTuid:(NSString *)tuid;
-(void)delUserForTuid:(NSString *)tuid;
-(void)sendChatForTuid:(NSString *)tuid cid:(NSString *)cid words:(NSString *)words type:(ChatType)type;
-(void)replyTopicForTid:(NSString *)tid content:(NSString *)content;
-(void)operateTopicForTid:(NSString *)tid action:(NSString *)action;
-(void)commentReplyTopicForTrid:(NSString *)trid content:(NSString *)content;

-(void)unreadChatsForCid:(NSString *)cid time:(NSString *)time;

-(void)uploadPicForImage:(UIImage *)image;

-(void)translateForText:(NSString *)text;

@end
