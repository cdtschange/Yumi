//
//  ChatViewController.h
//  Yumi
//
//  Created by Mao on 12/31/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "BaseListViewController.h"
#import "MessageDisplayViewController.h"

@interface ChatViewController : MessageDisplayViewController

@property (copy, nonatomic) NSString *cid;
@property (copy, nonatomic) NSString *tuid;
@property (copy, nonatomic) NSString *tpic;
@property (copy, nonatomic) NSString *name;
@end
