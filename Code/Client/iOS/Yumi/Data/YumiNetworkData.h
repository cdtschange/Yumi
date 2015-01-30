//
//  G2RNetworkData.h
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YumiData.h"

@interface YumiNetworkDataBase : NSObject

@property(nonatomic, assign)        int         status;
@property(nonatomic, copy)          NSString*   msg;

-(void)jsonToObj:(id)json;

@end



@interface UserCreateData : YumiNetworkDataBase

@property(nonatomic, copy)          NSString*   uid;
@property(nonatomic, copy)          NSString*   sessionid;

@end

@interface UserLoginData : YumiNetworkDataBase

@property(nonatomic, copy)          NSString*   uid;

@end

@interface UserExistData : YumiNetworkDataBase

@property(nonatomic, assign)        int         isexist;

@end

@interface UserInfoData : YumiNetworkDataBase

@property(nonatomic, strong)        User*       user;

@end



@interface ChatsData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       chats;
@end
@interface ChatData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       chats;
@end
@interface UsersData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       users;
@end
@interface UserRequestsData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       users;
@end
@interface NearUserData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       users;
@end
@interface TopicsData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       topics;
@end
@interface MyTopicsData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       topics;
@end
@interface TopicData : YumiNetworkDataBase
@property(nonatomic, copy)          NSString*       tid;
@property(nonatomic, copy)          NSString*       title;
@property(nonatomic, copy)          NSString*       info;
@property(nonatomic, copy)          NSString*       images;
@property(nonatomic, copy)          NSString*       pic;
@property(nonatomic, assign)        int             time;
@property(nonatomic, assign)        int             isfollowed;
@property(nonatomic, assign)        int             islike;
@end
@interface TopicRepliesData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       topicReplies;
@end
@interface TopicReplyCommentsData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       topicReplyComments;
@end
@interface TopicFollowersData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       users;
@end
@interface ProfileData : YumiNetworkDataBase
@property(nonatomic, copy)          NSString        *uid;
@property(nonatomic, copy)          NSString        *u_name;
@property(nonatomic, copy)          NSString        *pic;
@property(nonatomic, copy)          NSString        *account;
@property(nonatomic, assign)        int             birthday;
@property(nonatomic, copy)          NSString*       sex;
@property(nonatomic, copy)          NSString*       school;
@property(nonatomic, copy)          NSString*       department;
@property(nonatomic, copy)          NSString*       languages;
@property(nonatomic, copy)          NSString*       l_level;
@property(nonatomic, assign)        int             state;
@end
@interface UnreadChatsData : YumiNetworkDataBase
@property(nonatomic, strong)        NSArray*       chats;
@end
@interface UploadPicData : YumiNetworkDataBase
@property(nonatomic, copy)        NSString*       picname;
@end

@interface TranslateData : YumiNetworkDataBase
@property(nonatomic, copy)        NSString*       result;
@end
