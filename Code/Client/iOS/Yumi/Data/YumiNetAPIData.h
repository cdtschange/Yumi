//
//  YumiNetAPIData.h
//  Yumi
//
//  Created by Mao on 15/2/1.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "NetAPIData.h"

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

@interface YumiNetAPIData : NetAPIData

@property(nonatomic, assign)        int         status;
@property(nonatomic, copy)          NSString*   msg;

+ (NSString *)errorToString:(NSError *)error;
@end


@interface UserExistAPIData : YumiNetAPIData
@property(nonatomic, assign)        NSInteger           isexist;
+ (instancetype)initWithValue:(NSString *)value type:(UserExistType)type;
@end
@interface UserLoginAPIData : YumiNetAPIData
@property(nonatomic, copy)          NSString*           uid;
+ (instancetype)initWithUserName:(NSString *)userName passwd:(NSString *)passwd;
@end
@interface UserProfileAPIData : YumiNetAPIData
@property(nonatomic, copy)          NSString            *uid;
@property(nonatomic, copy)          NSString            *u_name;
@property(nonatomic, copy)          NSString            *pic;
@property(nonatomic, copy)          NSString            *account;
@property(nonatomic, assign)        int                 birthday;
@property(nonatomic, copy)          NSString*           sex;
@property(nonatomic, copy)          NSString*           school;
@property(nonatomic, copy)          NSString*           department;
@property(nonatomic, copy)          NSString*           languages;
@property(nonatomic, copy)          NSString*           l_level;
@property(nonatomic, assign)        int                 state;
+ (instancetype)initWithTuid:(NSString *)tuid;
@end
@interface NearUserAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            users;
+ (instancetype)initWithLon:(double)lon lat:(double)lat;
@end
@interface AddUserAPIData : YumiNetAPIData
+ (instancetype)initWithTuid:(NSString *)tuid reason:(NSString *)reason;
@end
@interface DelUserAPIData : YumiNetAPIData
+ (instancetype)initWithTuid:(NSString *)tuid;
@end
@interface AcceptUserAPIData : YumiNetAPIData
+ (instancetype)initWithTuid:(NSString *)tuid;
@end
@interface UsersAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            users;
+ (instancetype)init;
@end
@interface UserRequestsAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            users;
+ (instancetype)init;
@end
@interface TopicsAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            topics;
+ (instancetype)initWithStart:(int)start num:(int)num;
@end
@interface MyTopicsAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            topics;
+ (instancetype)init;
@end
@interface TopicAPIData : YumiNetAPIData
@property(nonatomic, copy)          NSString*       tid;
@property(nonatomic, copy)          NSString*       title;
@property(nonatomic, copy)          NSString*       info;
@property(nonatomic, copy)          NSString*       images;
@property(nonatomic, copy)          NSString*       pic;
@property(nonatomic, assign)        int             time;
@property(nonatomic, assign)        int             isfollowed;
@property(nonatomic, assign)        int             islike;
+ (instancetype)initWithTid:(NSString *)tid;
@end
@interface TopicRepliesAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            topicReplies;
+ (instancetype)initWithTid:(NSString *)tid sort:(NSString *)sort;
@end
@interface TopicFollowersAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            users;
+ (instancetype)initWithTid:(NSString *)tid;
@end
@interface TopicReplyCommentsAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            topicReplyComments;
+ (instancetype)initWithTrid:(NSString *)trid;
@end
@interface ReplyTopicAPIData : YumiNetAPIData
+ (instancetype)initWithTid:(NSString *)tid content:(NSString *)content;
@end
@interface OperateTopicAPIData : YumiNetAPIData
+ (instancetype)initWithTid:(NSString *)tid action:(NSString *)action;
@end
@interface CommentReplyTopicAPIData : YumiNetAPIData
+ (instancetype)initWithTrid:(NSString *)trid content:(NSString *)content;
@end
@interface ChatsAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            chats;
+ (instancetype)initWithStart:(int)start num:(int)num;
@end
@interface ChatAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            chats;
+ (instancetype)initWithCid:(NSString *)cid;
@end
@interface UnreadChatsAPIData : YumiNetAPIData
@property(nonatomic, strong)        NSArray*            chats;
+ (instancetype)initWithCid:(NSString *)cid time:(NSString *)time;
@end
@interface SendChatAPIData : YumiNetAPIData
+ (instancetype)initWithTuid:(NSString *)tuid cid:(NSString *)cid words:(NSString *)words type:(ChatType)type;
@end
@interface TranslateAPIData : YumiNetAPIData
@property(nonatomic, copy)          NSString*           result;
+ (instancetype)initWithText:(NSString *)text;
@end


