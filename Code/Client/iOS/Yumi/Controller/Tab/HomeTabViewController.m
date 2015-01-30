//
//  HomeTabViewController.m
//  G2R
//
//  Created by Wei Mao on 7/15/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "HomeTabViewController.h"
#import "NearUserViewController.h"
#import "ChatListViewController.h"
#import "FriendsViewController.h"
#import "FindViewController.h"
#import "MyViewController.h"
#import "MLNavigationController.h"

#define CONST_HOME_KTVTitleViewMaxWidth 150 //标题最大宽度

@interface HomeTabViewController (){
    UITabBarItem *lastItem;
}

@property (strong, nonatomic) NearUserViewController *nearVC;
@property (strong, nonatomic) ChatListViewController *chatVC;
@property (strong, nonatomic) FriendsViewController *friendVC;
@property (strong, nonatomic) FindViewController *findVC;
@property (strong, nonatomic) MyNavigationHelper *myVC;
@property (strong, nonatomic) UIView *titleView;

@end

@implementation HomeTabViewController

#pragma mark - Base

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.viewControllers = nil;
}

#pragma mark - Overwrite Base
-(NSString *)segueName{
    return TVGoToHomeView;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUIAndData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyNavigationHelper setNavigationBarBgImage:self.navigationController.navigationBar];
}
-(void)initUIAndData{
    [self initNavigationBar];
    if (IOS_7) {
        self.tabBar.translucent = NO;
    }
    //    [self addCenterButtonWithSEL:@selector(click_centerButton:)];
    self.nearVC = [UIViewController instanceByName:@"NearUserViewController"];
    self.chatVC = [UIViewController instanceByName:@"ChatListViewController"];
    self.friendVC = [UIViewController instanceByName:@"FriendsViewController"];
    self.findVC = [UIViewController instanceByName:@"FindViewController"];
    self.myVC = [UIViewController instanceByName:@"MyViewController"];
    self.viewControllers = @[self.nearVC,
                             self.chatVC,
                             self.friendVC,
                             self.findVC,
                             self.myVC];
    
    for (UITabBarItem *item in self.tabBar.items) {
        item.title = @"";
    }
//    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(320/2 -  CONST_HOME_KTVTitleViewMaxWidth/2, 0, CONST_HOME_KTVTitleViewMaxWidth, 44)];
//    self.btnKtvChoose = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *buttonImage = [[UIImage imageNamed:IMG_KTV_TITLE_ARROW] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 10, 24, 15)];
//    self.btnKtvChoose.frame = CGRectMake(0, 0, CONST_HOME_KTVTitleViewMaxWidth, 36);
//    [self.btnKtvChoose setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [self.btnKtvChoose addTarget:self action:@selector(routeToChooseKTV) forControlEvents:UIControlEventTouchUpInside];
//    [self.titleView addSubview:self.btnKtvChoose];
//    self.lblKtvTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CONST_HOME_KTVTitleViewMaxWidth-15, 44)];
//    self.lblKtvTitle.textColor = COLOR_Default_Black;
//    self.lblKtvTitle.backgroundColor = [UIColor clearColor];
//    self.lblKtvTitle.font = [UIFont boldSystemFontOfSize:21.0];
//    //    self.lblKtvTitle.shadowOffset = CGSizeMake(0, 1);
//    //    self.lblKtvTitle.shadowColor = [UIColor colorWithRed:100.0/255.0 green:0.0 blue:0.0 alpha:0.7];
//    self.lblKtvTitle.textAlignment = NSTextAlignmentCenter;
//    [self.titleView addSubview:self.lblKtvTitle];
//    self.navigationItem.titleView = self.titleView;
}
-(void)initNavigationBar{
//    self.navigationItem.leftBarButtonItem = [MyNavigationHelper createNavItemWithType:NavItemTypeLogo target:nil action:nil];
    //    self.navigationItem.rightBarButtonItem = [MyNavigationHelper createNavItemWithType:NavItemTypeName target:nil action:nil];
    self.title = @"附近的人";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    ((MLNavigationController *)self.navigationController).canDragBack = NO;
}
#pragma mark - Notification

#pragma mark - Overwrite Intro

#pragma mark - Action

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [super tabBar:tabBar didSelectItem:item];
    int index = (int)[tabBar.items indexOfObject:item];
    if (lastItem == item) {
        return;
    }
    lastItem = item;
    if (index==0) {
        self.title = @"附近的人";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }else if(index==1){
        self.title = @"聊天";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }else if(index==2){
        self.title = @"语友";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [MyNavigationHelper createNavItemWithType:NavItemTypeAddFriend target:self.friendVC action:@selector(click_addFriends:)];
    }else if(index==3){
        self.title = @"发现";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }else if(index==4){
        self.title = @"我的";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [MyNavigationHelper createNavItemWithType:NavItemTypeSetting target:self.myVC action:@selector(click_settings:)];
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

@end

