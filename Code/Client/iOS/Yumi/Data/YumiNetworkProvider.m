//
//  G2RNetworkProvider.m
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "YumiNetworkProvider.h"
#import "CacheProvider.h"
#import "JSONKit.h"
#import "AppConfigEntity.h"
#import "YumiNetworkInfo.h"
#import "UserProvider.h"
#import "GlobalConfig.h"

#define STATUS_CODE_SUCCESS 0
#define DEFAULT_CACHE_TIME                  24*60*60 //默认缓存时间1天

@interface YumiNetworkProvider()

@property(nonatomic, strong)    NSDictionary                *params;
@property(nonatomic, copy)      NSString                    *path;
@property(nonatomic, assign)    ExAFNetworkHttpMethod       method;
@property(nonatomic, strong)    YumiNetworkDataBase         *dataHandler;
@property(nonatomic, copy)      void (^successBlock)(id responseObject);
@property(nonatomic, copy)      void (^failureBlock)(NSError *error);
@property(nonatomic, assign)    BOOL                        cache;
@property(nonatomic, assign)    int                         cacheTime;

@end

@implementation YumiNetworkProvider

-(id)init{
    if (self = [super init]) {
        self.baseURL = [YumiNetworkInfo baseURL];
        self.baseParams = @{
//     @"version":[NSString stringWithFormat:@"%d", [[YumiNetworkInfo shared] apiVersion]],
//     @"imei":[[AppConfigEntity shared] imei],
//     @"clientversion":[NSString stringWithFormat:@"%d", AppConfigEntity.currentAppNumberVersion],
//     @"clienttype":[NSString stringWithFormat:@"%d", kDeviceClientIOS],
                            };
        [[CacheProvider shared] clear];
    }
    return self;
}

-(void)requestWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    if (self.cache) {
        NSString *key = [self getFullURLWithPath:self.path params:self.params method:self.method];
        CacheProvider *cp = [CacheProvider shared];
        if ([cp hasKey:key]) {
            NSString *value = [cp cacheByKey:key];
            id obj = [value objectFromJSONString];
            if (success) {
                if (self.dataHandler) {
                    YumiNetworkDataBase *data = [YumiNetworkDataBase new];
                    data = [[self.dataHandler class] new];
                    [data jsonToObj:obj];
                    success(data);
                }else{
                    success(obj);
                }
            }
            if (self.statusBlock) {
                self.statusBlock(NetworkProviderStatusEnd,nil);
            }
            return;
        }
    }
    __weak YumiNetworkProvider *weakself = self;
    [self requestJSONWithPath:self.path params:self.params method:self.method success:^(id responseObject) {
        YumiNetworkDataBase *data = [YumiNetworkDataBase new];
        [data jsonToObj:responseObject];
        if (data.status == STATUS_CODE_SUCCESS) {
            if (success) {
                if (self.cache) {
                    NSString *key = [weakself getFullURLWithPath:weakself.path params:weakself.params method:weakself.method];
                    CacheProvider *cp = [CacheProvider shared];
                    NSString *jsonStr = [responseObject JSONString];
                    [cp setCacheByKey:key value:jsonStr valideTime:weakself.cacheTime];
                }
                if (weakself.dataHandler) {
                    data = [[weakself.dataHandler class] new];
                    [data jsonToObj:responseObject];
                    success(data);
                }else{
                    success(responseObject);
                }
            }
        }else{
            NSError *error = [NSError errorWithDomain:@"" code:data.status userInfo:@{@"msg":data.msg}];
            if (failure) {
                failure(error);
            }
            NSLog(@"%@",error);
            if (error.code == CONST_NEED_RELOGIN_CODE) {
                [[UserProvider shared] logout];
            }
        }
        weakself.dataHandler = nil;
        weakself.cache = NO;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        weakself.dataHandler = nil;
        weakself.cache = NO;
    }];
}
-(void)setCompletionBlockWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    self.successBlock = success;
    self.failureBlock = failure;
}
-(void)requestData{
    [self requestWithSuccess:self.successBlock failure:self.failureBlock];
}
-(void)useCache:(BOOL)cache{
    self.cache = cache;
}
+(NSString *)errorToString:(NSError *)error{
    if ([error.userInfo[@"msg"] length]>0) {
        return error.userInfo[@"msg"];
    }
    return error.description;
}


#pragma mark - Interface
-(void)userCreateForUserName:(NSString *)userName mobile:(NSString *)mobile passwd:(NSString *)passwd{
    self.params = @{
                    @"username":userName,
                    @"mobile":mobile,
                    @"passwd":passwd
                    };
    self.path = @"/user/create";
    self.method = ExAFNetworkHttpMethodPost;
    self.dataHandler = [UserCreateData new];
}
-(void)userLoginForUserName:(NSString *)userName passwd:(NSString *)passwd{
    self.params = @{
                    @"account":userName,
                    @"password":passwd
                    };
    self.path = @"/login.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [UserLoginData new];
}
-(void)userLogout{
    self.params = @{
                    };
    self.path = @"/user/logout";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [YumiNetworkDataBase new];
}
-(void)userExistForValue:(NSString *)value type:(UserExistType)type{
    self.params = @{
                    @"value":value,
                    @"type":[NSString stringWithFormat:@"%d",type]
                    };
    self.path = @"/user/exist";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [UserExistData new];
}

-(void)profileForTuid:(NSString *)tuid{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tuid":tuid,
                    };
    self.path = @"/profile.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [ProfileData new];
}



-(void)chatsForStart:(int)start num:(int)num;{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"start":[NSString stringWithFormat:@"%d",start],
                    @"num":[NSString stringWithFormat:@"%d",num],
                    };
    self.path = @"/chats.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.cache = YES;
    self.dataHandler = [ChatsData new];
}
-(void)chatForCid:(NSString *)cid{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"cid":cid,
                    };
    self.path = @"/chat.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [ChatData new];
}
-(void)users{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    };
    self.path = @"/user.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.cache = YES;
    self.dataHandler = [UsersData new];
}
-(void)userRequests{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    };
    self.path = @"/userrequests.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [UserRequestsData new];
}
-(void)nearUserForLon:(double)lon lat:(double)lat{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"lon":[NSString stringWithFormat:@"%f",lon],
                    @"lat":[NSString stringWithFormat:@"%f",lat],
                    };
    self.path = @"/nearuser.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [NearUserData new];
}
-(void)topicsForStart:(int)start num:(int)num{
    self.params = @{
                    @"start":[NSString stringWithFormat:@"%d",start],
                    @"num":[NSString stringWithFormat:@"%d",num],
                    };
    self.path = @"/topics.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [TopicsData new];
}
-(void)myTopics{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    };
    self.path = @"/mytopics.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [MyTopicsData new];
}
-(void)topicForTid:(NSString *)tid{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tid":tid,
                    };
    self.path = @"/topic.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [TopicData new];
}
-(void)topicRepliesForTid:(NSString *)tid sort:(NSString *)sort{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tid":tid,
                    @"sort":sort,
                    };
    self.path = @"/topicreplies.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [TopicRepliesData new];
}
-(void)topicReplyCommentsForTrid:(NSString *)trid{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"trid":trid,
                    };
    self.path = @"/topicreplycomments.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [TopicReplyCommentsData new];
}
-(void)topicFollowersForTid:(NSString *)tid{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tid":tid,
                    };
    self.path = @"/topicfollowers.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [TopicFollowersData new];
}
-(void)addUserForTuid:(NSString *)tuid reason:(NSString *)reason{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tuid":tuid,
                    @"reason":reason,
                    };
    self.path = @"/adduser.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [YumiNetworkDataBase new];
}
-(void)acceptUserForTuid:(NSString *)tuid{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tuid":tuid,
                    };
    self.path = @"/acceptuser.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [YumiNetworkDataBase new];
}
-(void)delUserForTuid:(NSString *)tuid{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tuid":tuid,
                    };
    self.path = @"/deluser.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [YumiNetworkDataBase new];
}
-(void)sendChatForTuid:(NSString *)tuid cid:(NSString *)cid words:(NSString *)words type:(ChatType)type{
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
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tuid":tuid,
                    @"cid":cid,
                    @"type":t,
                    @"words":words,
                    };
    self.path = @"/sendchat.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [YumiNetworkDataBase new];
}

-(void)replyTopicForTid:(NSString *)tid content:(NSString *)content{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tid":tid,
                    @"content":content,
                    };
    self.path = @"/replytopic.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [YumiNetworkDataBase new];
}
-(void)operateTopicForTid:(NSString *)tid action:(NSString *)action{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"tid":tid,
                    @"action":action,
                    };
    self.path = @"/operatetopic.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [YumiNetworkDataBase new];
}
-(void)commentReplyTopicForTrid:(NSString *)trid content:(NSString *)content{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"trid":trid,
                    @"content":content,
                    };
    self.path = @"/commentreplytopic.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [YumiNetworkDataBase new];
}

-(void)unreadChatsForCid:(NSString *)cid time:(NSString *)time{
    self.params = @{
                    @"uid":[AccountEntity shared].uid,
                    @"cid":cid,
                    @"time":time,
                    };
    self.path = @"/unreadchats.php";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [UnreadChatsData new];
}

-(void)uploadPicForImage:(UIImage *)image{
    NSData *data = UIImagePNGRepresentation(image);
    self.params = @{
                    @"file":data
                    };
    self.path = @"/uploaded.php";
    self.method = ExAFNetworkHttpMethodPost;
    self.dataHandler = [UploadPicData new];
}


-(void)translateForText:(NSString *)text{
    self.params = @{
                    @"q":text,
                    @"client_id":@"8AOshIg850ljhSNz3NIFtH9n",
                    @"from":@"auto",
                    @"to":@"auto"
                    };
    self.baseURL = @"http://openapi.baidu.com";
    self.path = @"/public/2.0/bmt/translate";
    self.method = ExAFNetworkHttpMethodGet;
    self.dataHandler = [TranslateData new];
}

@end
