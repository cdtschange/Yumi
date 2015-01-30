//
//  G2RNetworkData.m
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "YumiNetworkData.h"
#import <objc/runtime.h>

@implementation YumiNetworkDataBase

-(void)jsonToObj:(id)json{
    self.status = [json[@"status"] intValue];
    self.msg = json[@"msg"];
    if (self.msg.length == 0) {
        self.msg = json[@"message"];
    }
}

-(void)fillObject:(id)obj withJson:(id)json{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [json valueForKey:(NSString *)propertyName];
        if ([propertyName isEqualToString:@"descriptionstr"]) {
            propertyValue = [json valueForKey:(NSString *)@"description"];
        }

        const char * type = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            //it's a float
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            //it's an int
        } else if (strcmp(rawPropertyType, @encode(float)) == 0) {
            //it's some sort of float
        } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
            //it's some sort of double
        } else if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
            //it's some sort of bool
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            //it's some sort of object
        } else if ([propertyType isEqualToString:@"@\"NSString\""]) {
            //it's some sort of nsstring
        }else if ([propertyType isEqualToString:@"@\"UIImage\""]) {
            //it's some sort of nsstring
        }else{
            if ([propertyType hasPrefix:@"@\""] && [propertyType hasSuffix:@"\""]) {
                propertyType = [propertyType substringFromIndex:2];
                propertyType = [propertyType substringToIndex:propertyType.length-1];
                Class class = NSClassFromString(propertyType);
                id subObj = [class new];
                [self fillObject:subObj withJson:propertyValue];
                [obj setValue:subObj forKey:propertyName];
                continue;
            }
        }

        if (propertyValue){
            [obj setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
}

@end

@implementation UserCreateData

-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    self.uid = json[@"uid"];
    self.sessionid = json[@"sessionid"];
}

@end

@implementation UserLoginData

-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    self.uid = json[@"uid"];
}

@end

@implementation UserExistData

-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    self.isexist = [json[@"isexist"] intValue];
}

@end

@implementation UserInfoData

-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    User *b = [User new];
    [self fillObject:b withJson:json];
    self.user = b;
}

@end



@implementation ChatsData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        Chats *b = [Chats new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.chats = [NSArray arrayWithArray:arr];
}
@end
@implementation ChatData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        Chat *b = [Chat new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.chats = [NSArray arrayWithArray:arr];
}
@end
@implementation UsersData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        User *b = [User new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.users = [NSArray arrayWithArray:arr];
}
@end
@implementation UserRequestsData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        User *b = [User new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.users = [NSArray arrayWithArray:arr];
}
@end
@implementation NearUserData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        User *b = [User new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.users = [NSArray arrayWithArray:arr];
}
@end
@implementation TopicsData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        Topic *b = [Topic new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.topics = [NSArray arrayWithArray:arr];
}
@end
@implementation MyTopicsData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        Topic *b = [Topic new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.topics = [NSArray arrayWithArray:arr];
}
@end
@implementation TopicData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    self.title = data[@"title"];
    self.info = data[@"info"];
    self.time = [data[@"time"] intValue];
    self.pic = data[@"pic"];
    self.isfollowed = [data[@"isfollowed"] intValue];
    self.islike = [data[@"islike"] intValue];
}
@end
@implementation TopicRepliesData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        TopicReply *b = [TopicReply new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.topicReplies = [NSArray arrayWithArray:arr];
}
@end
@implementation TopicReplyCommentsData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        TopicReplyComment *b = [TopicReplyComment new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.topicReplyComments = [NSArray arrayWithArray:arr];
}
@end
@implementation TopicFollowersData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        User *b = [User new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.users = [NSArray arrayWithArray:arr];
}
@end
@implementation ProfileData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"user"];
    User *b = [User new];
    [self fillObject:b withJson:data];
    self.uid = json[@"uid"];
    self.u_name = json[@"u_name"];
    self.pic = json[@"pic"];
    self.birthday = [json[@"birthday"] intValue];
    self.sex = json[@"sex"];
    self.school = json[@"NSString"];
    self.department = json[@"department"];
    self.languages = json[@"languages"];
    self.l_level = json[@"l_level"];
    self.state = [json[@"state"] intValue];
}
@end

@implementation UnreadChatsData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    id data = json[@"data"];
    NSMutableArray *arr = [NSMutableArray new];
    for (id dataItem in data) {
        Chats *b = [Chats new];
        [self fillObject:b withJson:dataItem];
        [arr addObject:b];
    }
    self.chats = [NSArray arrayWithArray:arr];
}
@end

@implementation UploadPicData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    self.picname = json[@"picname"];
}
@end

@implementation TranslateData
-(void)jsonToObj:(id)json{
    [super jsonToObj:json];
    if(json[@"trans_result"]){
        NSArray *arr = json[@"trans_result"];
        if (arr.count>0) {
            self.result = arr[0][@"dst"];
        }
    }
}
@end
