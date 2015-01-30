//
//  G2RData.h
//  G2R
//
//  Created by Wei Mao on 8/28/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum UserState {
    UserStateAdded,
    UserStateNone,
}UserState;

@interface User : NSObject

@property(nonatomic, copy)      NSString        *uid;
@property(nonatomic, copy)      NSString        *u_name;
@property(nonatomic, copy)      NSString        *pic;
@property(nonatomic, copy)      NSString        *account;
@property(nonatomic, assign)    int             birthday;
@property(nonatomic, copy)      NSString*       sex;
@property(nonatomic, copy)      NSString*       school;
@property(nonatomic, copy)      NSString*       department;
@property(nonatomic, copy)      NSString*       languages;
@property(nonatomic, copy)      NSString*       l_level;
@property(nonatomic, strong)    NSString*       reason;
@property(nonatomic, assign)    int             state;

@end

@interface Topic : NSObject

@property(nonatomic, copy)      NSString        *tid;
@property(nonatomic, copy)      NSString        *title;
@property(nonatomic, copy)      NSString        *images;
@property(nonatomic, assign)    int             visits;
@property(nonatomic, assign)    int             comments;

@end

@interface TopicReply : NSObject

@property(nonatomic, copy)      NSString        *trid;
@property(nonatomic, copy)      NSString        *uid;
@property(nonatomic, copy)      NSString        *u_name;
@property(nonatomic, copy)      NSString        *pic;
@property(nonatomic, copy)      NSString        *text;
@property(nonatomic, copy)      NSString        *position;
@property(nonatomic, assign)    int             time;

@end

@interface TopicReplyComment : NSObject

@property(nonatomic, copy)      NSString        *trcid;
@property(nonatomic, copy)      NSString        *uid;
@property(nonatomic, copy)      NSString        *u_name;
@property(nonatomic, copy)      NSString        *pic;
@property(nonatomic, copy)      NSString        *text;
@property(nonatomic, copy)      NSString        *position;
@property(nonatomic, assign)    int             time;

@end


@interface Chats : NSObject

@property(nonatomic, copy)      NSString        *cid;
@property(nonatomic, copy)      NSString        *title;
@property(nonatomic, copy)      NSString        *pic;
@property(nonatomic, copy)      NSString        *words;
@property(nonatomic, assign)    int             time;
@property(nonatomic, copy)      NSString        *type;
@property(nonatomic, assign)    int             badge;

@end
@interface Chat : NSObject

@property(nonatomic, assign)    int             time;
@property(nonatomic, copy)      NSString        *words;
@property(nonatomic, copy)      NSString        *type;
@property(nonatomic, copy)      NSString        *uid;
@property(nonatomic, copy)      NSString        *u_name;
@property(nonatomic, copy)      NSString        *pic;
@property(nonatomic, copy)      NSString        *photo;
@property(nonatomic, strong)    UIImage         *photoImage;
@property(nonatomic, copy)      NSString        *translate;
@end