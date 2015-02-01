//
//  YumiNetAPIData.m
//  Yumi
//
//  Created by Mao on 15/2/1.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import "YumiNetAPIData.h"
#import "YumiNetAPIClient.h"

@implementation YumiNetAPIData
+ (id)jsonToObj:(id)json{
    YumiNetAPIData *data = [[self class] new];
    if (json[@"status"]) {
        data.status = [json[@"status"] intValue];
    }
    if (json[@"msg"]) {
        data.msg = json[@"msg"];
    }
    return data;
}

+ (NSString *)errorToString:(NSError *)error{
    if ([error.userInfo[@"msg"] length]>0) {
        return error.userInfo[@"msg"];
    }
    return error.description;
}
@end

@implementation UserExistAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    [obj setIsexist:[json[@"isexist"] integerValue]];
    return obj;
}
+ (instancetype)initWithValue:(NSString *)value type:(UserExistType)type{
    NSDictionary *query = @{
                            @"value":value,
                            @"type":[NSString stringWithFormat:@"%d",type]
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"userexist.php"];
}
@end
@implementation UserLoginAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    [obj setUid:json[@"uid"]];
    return obj;
}
+ (instancetype)initWithUserName:(NSString *)userName passwd:(NSString *)passwd{
    NSDictionary *query = @{
                            @"account":userName,
                            @"password":passwd
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"login.php"];
}
@end
@implementation UserProfileAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    [self fillJson:json inObject:obj];
    return obj;
}
+ (instancetype)initWithTuid:(NSString *)tuid{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tuid":tuid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"profile.php"];
}
@end
@implementation NearUserAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        User *b = [User new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setUsers:arr];
    return obj;
}
+ (instancetype)initWithLon:(double)lon lat:(double)lat{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"lon":[NSString stringWithFormat:@"%f",lon],
                            @"lat":[NSString stringWithFormat:@"%f",lat],
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"nearuser.php"];
}
@end
@implementation AddUserAPIData
+ (instancetype)initWithTuid:(NSString *)tuid reason:(NSString *)reason{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tuid":tuid,
                            @"reason":reason,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"adduser.php"];
}
@end
@implementation DelUserAPIData
+ (instancetype)initWithTuid:(NSString *)tuid{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tuid":tuid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"deluser.php"];
}
@end
@implementation AcceptUserAPIData
+ (instancetype)initWithTuid:(NSString *)tuid{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tuid":tuid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"acceptuser.php"];
}
@end
@implementation UsersAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        User *b = [User new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setUsers:arr];
    return obj;
}
+ (instancetype)init{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"user.php"];
}
@end
@implementation UserRequestsAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        User *b = [User new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setUsers:arr];
    return obj;
}
+ (instancetype)init{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"userrequests.php"];
}
@end
@implementation TopicsAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        Topic *b = [Topic new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setTopics:arr];
    return obj;
}
+ (instancetype)initWithStart:(int)start num:(int)num{
    NSDictionary *query = @{
                            @"start":[NSString stringWithFormat:@"%d",start],
                            @"num":[NSString stringWithFormat:@"%d",num],
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"topics.php"];
}
@end
@implementation MyTopicsAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        Topic *b = [Topic new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setTopics:arr];
    return obj;
}
+ (instancetype)init{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"mytopics.php"];
}
@end
@implementation TopicAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    [self fillJson:data inObject:obj];
    return obj;
}
+ (instancetype)initWithTid:(NSString *)tid{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tid":tid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"topic.php"];
}
@end
@implementation TopicRepliesAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        TopicReply *b = [TopicReply new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setTopicReplies:arr];
    return obj;
}
+ (instancetype)initWithTid:(NSString *)tid sort:(NSString *)sort{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tid":tid,
                            @"sort":sort,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"topicreplies.php"];
}
@end
@implementation TopicFollowersAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        User *b = [User new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setUsers:arr];
    return obj;
}
+ (instancetype)initWithTid:(NSString *)tid{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tid":tid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"topicfollowers.php"];
}
@end
@implementation TopicReplyCommentsAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        TopicReplyComment *b = [TopicReplyComment new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setTopicReplyComments:arr];
    return obj;
}
+ (instancetype)initWithTrid:(NSString *)trid{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"trid":trid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"topicreplycomments.php"];
}
@end
@implementation ReplyTopicAPIData
+ (instancetype)initWithTid:(NSString *)tid content:(NSString *)content{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tid":tid,
                            @"content":content,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"replytopic.php"];
}
@end
@implementation OperateTopicAPIData
+ (instancetype)initWithTid:(NSString *)tid action:(NSString *)action{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tid":tid,
                            @"action":action,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"operatetopic.php"];
}
@end
@implementation CommentReplyTopicAPIData
+ (instancetype)initWithTrid:(NSString *)trid content:(NSString *)content{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"trid":trid,
                            @"content":content,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"commentreplytopic.php"];
}
@end
@implementation ChatsAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        Chats *b = [Chats new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setChats:arr];
    return obj;
}
+ (instancetype)initWithStart:(int)start num:(int)num{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"start":[NSString stringWithFormat:@"%d",start],
                            @"num":[NSString stringWithFormat:@"%d",num],
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"chats.php"];
}
@end
@implementation ChatAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        Chat *b = [Chat new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setChats:arr];
    return obj;
}
+ (instancetype)initWithCid:(NSString *)cid{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"cid":cid,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"chat.php"];
}
@end
@implementation UnreadChatsAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in data) {
        Chats *b = [Chats new];
        [self fillJson:item inObject:b];
        [arr addObject:b];
    }
    [obj setChats:arr];
    return obj;
}
+ (instancetype)initWithCid:(NSString *)cid time:(NSString *)time{
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"cid":cid,
                            @"time":time,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"unreadchats.php"];
}
@end
@implementation SendChatAPIData
+ (instancetype)initWithTuid:(NSString *)tuid cid:(NSString *)cid words:(NSString *)words type:(ChatType)type{
    NSString *t = @"text";
    switch (type) {
        case ChatTypeText:
            t=@"text";
            break;
        case ChatTypeTextM:
            t=@"text-m";
            break;
        case ChatTypeVoice:
            t=@"voice";
            break;
        case ChatTypeImage:
            t=@"image";
            break;
        default:
            break;
    }
    cid = cid?cid:@"";
    tuid = tuid?tuid:@"";
    NSDictionary *query = @{
                            @"uid":[AccountEntity shared].uid,
                            @"tuid":tuid,
                            @"cid":cid,
                            @"type":t,
                            @"words":words,
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"sendchat.php"];
}
@end
@implementation TranslateAPIData
+ (id)jsonToObj:(id)json{
    id obj = [super jsonToObj:json];
    if(json[@"trans_result"]){
        NSArray *arr = json[@"trans_result"];
        if (arr.count>0) {
            [obj setResult:arr[0][@"dst"]];
        }
    }
    return obj;
}
+ (instancetype)initWithText:(NSString *)text{
    NSDictionary *query = @{
                            @"q":text,
                            @"client_id":@"8AOshIg850ljhSNz3NIFtH9n",
                            @"from":@"auto",
                            @"to":@"auto"
                            };
    return [self initWithClient:[YumiNetAPIClient shared] query:query mehod:@"GET" url:@"http://openapi.baidu.com/public/2.0/bmt/translate"];
}
@end

