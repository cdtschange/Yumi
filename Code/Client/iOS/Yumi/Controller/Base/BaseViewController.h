//
//  BaseViewController.h
//  G2R
//
//  Created by Wei Mao on 7/15/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseKitViewController.h"
#import "EmptyDefaultView.h"
#import "MyNavigationHelper.h"
#import "AccountEntity.h"
#import "NavRootViewController.h"


@interface BaseViewController : BaseKitViewController
//空页面时的控件
@property(strong,nonatomic) EmptyDefaultView *emptyView;
//无数据文字提示
- (NSString *)emptyTitle;


@end
