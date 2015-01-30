//
//  WandaUtils+UIViewController.m
//  WandaKTV
//
//  Created by Wei Mao on 10/17/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "UIViewController+Yumi.h"
#import "YumiWebViewController.h"
#import "NavRootViewController.h"
#import "MyNavigationHelper.h"
#import "AppDelegate.h"
#import "AppConfigEntity.h"

@implementation UIViewController (Yumi)


//打开一个内嵌浏览器网页
- (void)routeToUrl:(NSString *)url{
    YumiWebViewController *vc = [[YumiWebViewController alloc] init];
    [vc openURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:vc animated:YES];
}


//将导航栏左边设置为返回按钮
- (void)setBackLeftButtonOnNavBar{
    self.navigationItem.leftBarButtonItem = [MyNavigationHelper createNavItemWithType:NavItemTypeBack target:self action:@selector(routeBack)];
}

//初始化默认导航栏
- (void)initNavigationBar{
    self.navigationController.navigationBar.translucent = NO;
    [MyNavigationHelper setNavigationBarBgImage:self.navigationController.navigationBar];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName: COLOR_Default_Black,
        NSShadowAttributeName: shadow,
        NSFontAttributeName: [UIFont boldSystemFontOfSize:20.0]};
    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                 COLOR_Default_Black, UITextAttributeTextColor,
//                                 [UIColor clearColor], UITextAttributeTextShadowColor,
//                                 nil]];
    self.navigationItem.useMarginLayout = YES;
}
//添加引导页
+(void)addGuideViewController{
    if (![AppConfigEntity shared].introGuideFlag) {
        [UIViewController initWithFirstViewController:@"GuideViewController"];
    }
}


+ (void)initWithFirstViewController:(NSString *)name{
    //清空所有页面，重新初始化segue对应的view
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!name) {
        return;
    }
    if (!window) {
        window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [window makeKeyAndVisible];
    }
    UIViewController *vc = [UIViewController instanceByName:name];
    NavRootViewController *nav = [[NavRootViewController alloc] initWithRootViewController:vc];
    window.rootViewController = nav;
    [AppDelegate appDelegate].window = window;
}

@end
