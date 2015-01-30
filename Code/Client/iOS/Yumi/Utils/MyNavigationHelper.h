//
//  MyNavigationHelper.h
//  WandaKTV
//
//  Created by Wei Mao on 1/4/13.
//  Copyright (c) 2013 WandaKtvInc.. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NavItemTypeNone,
    NavItemTypeClose,
    NavItemTypeBack,
    NavItemTypeAddFriend,
    NavItemTypeSetting,
    NavItemTypeCancel,
    NavItemTypeSkip,
    NavItemTypeProfile,
    NavItemTypeSend,

}MyNavItemType;

@interface MyNavigationHelper : NSObject
+ (void)setNavigationTitleStyle;
+ (void)setNavigationBarBgImage:(UINavigationBar *)bar;
+ (void)setNavigationBarBgImage:(UINavigationBar *)bar withImage:(UIImage *)image;
+ (UIBarButtonItem *)createNavItemWithType:(MyNavItemType)type target:(id)target action:(SEL)action;
@end
