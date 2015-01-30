//
//  WandaUtils+UIViewController.h
//  WandaKTV
//
//  Created by Wei Mao on 10/17/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//


@interface UIViewController (Yumi)

//打开一个内嵌浏览器网页
- (void)routeToUrl:(NSString *)url;
//将导航栏左边设置为返回按钮
- (void)setBackLeftButtonOnNavBar;
//添加引导页
+ (void)addGuideViewController;

//根据Segue初始化第一个页面
+ (void)initWithFirstViewController:(NSString *)name;

@end
