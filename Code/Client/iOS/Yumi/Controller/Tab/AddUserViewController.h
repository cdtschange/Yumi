//
//  AddUserViewController.h
//  Yumi
//
//  Created by Mao on 15/1/18.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^AddUserCompleteBlock)(BOOL added, NSString* reason);

@interface AddUserViewController : BaseViewController

@property (copy, nonatomic) AddUserCompleteBlock block;
@property(copy, nonatomic) NSString *uid;
@end
