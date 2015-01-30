//
//  TopicReplyViewController.h
//  Yumi
//
//  Created by Mao on 1/6/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "BaseListViewController.h"

@interface TopicReplyViewController : BaseListViewController
@property(nonatomic, copy) NSString *trid;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *uname;
@property(nonatomic, copy) NSString *upic;
@property(nonatomic, strong) NSNumber *time;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *position;
@property(nonatomic, strong) NSNumber *isFriend;

@end
