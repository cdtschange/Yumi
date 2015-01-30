//
//  MyNavigationHelper.m
//  WandaKTV
//
//  Created by Wei Mao on 1/4/13.
//  Copyright (c) 2013 WandaKtvInc.. All rights reserved.
//

#import "MyNavigationHelper.h"

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

@implementation UIImage (Color)



//给UIImage添加的类别

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{

    @autoreleasepool {

        CGRect rect = CGRectMake(0, 0, size.width, size.height);

        UIGraphicsBeginImageContext(rect.size);

        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetFillColorWithColor(context,

                                       color.CGColor);

        CGContextFillRect(context, rect);

        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
        
        
        
        return img;
        
    }
    
}

@end

@implementation MyNavigationHelper
+(void)setNavigationTitleStyle{
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor clearColor];
//    if (IOS_7) {
//        NSDictionary *titleAttributes = @{NSForegroundColorAttributeName: COLOR_Default_White,
//                                          NSShadowAttributeName: shadow,
//                                          NSFontAttributeName: [UIFont boldSystemFontOfSize:30.0]};
//        [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
//    }else{
//        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                     COLOR_Default_White, UITextAttributeTextColor,
//                                     [UIColor clearColor], UITextAttributeTextShadowColor,
//                                     nil]];
//    }
//    
    //  去除iOS 6.0以后自带的黑线，下面这个方法就能去除所有的NavigationBar的黑线。
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
    {
        [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
    }
}
+ (UIImage*) createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+(void)setNavigationBarBgImage:(UINavigationBar *)bar{
    [self setNavigationBarAttrubutes:bar];
    [bar setBackgroundImage:[self createImageWithColor:COLOR_Default_Green] forBarMetrics:UIBarMetricsDefault];
    //    [bar setBackgroundImage:[UIImage imageNamed:IMG_NAV_TOP_BAR] forBarMetrics:UIBarMetricsDefault];
}
+(void)setNavigationBarBgImage:(UINavigationBar *)bar withImage:(UIImage *)image{
    [self setNavigationBarAttrubutes:bar];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
+(void)setNavigationBarAttrubutes:(UINavigationBar *)bar{
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                 COLOR_Default_White, UITextAttributeTextColor,
                                 [UIFont boldSystemFontOfSize:20.0],NSFontAttributeName,
                                 [UIColor clearColor], UITextAttributeTextShadowColor,
                                 nil]];
}
+(UIBarButtonItem *)createNavItemWithType:(MyNavItemType)type target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *imageStr = @"";
    CGRect frame = CGRectMake(0, 0, 44, 44);
    switch (type) {
        case NavItemTypeBack:
            imageStr = @"top_bar_back";
            break;
        case NavItemTypeClose:
            imageStr = IMG_NAV_BTN_CLOSE;
            break;
        case NavItemTypeSetting:
            imageStr = @"top_bar_setting";
            frame = CGRectMake(0, 0, 44, 44);
            break;
        case NavItemTypeAddFriend:
            imageStr = @"top_bar_friend_add";
            frame = CGRectMake(0, 0, 44, 44);
            break;
        case NavItemTypeProfile:
            imageStr = @"top_bar_profile";
            frame = CGRectMake(0, 0, 44, 44);
            break;
        default:
            break;
    }
    [button setFrame:frame];
    button.tag = type;
    button.showsTouchWhenHighlighted = YES;
    [button setTitleColor:RGBCOLOR(229, 229, 229) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    if (type == NavItemTypeSkip) {
        [button setTitle:@"跳过" forState:UIControlStateNormal];
    }else if (type == NavItemTypeCancel) {
        [button setTitle:@"取消" forState:UIControlStateNormal];
    }else if (type == NavItemTypeSend) {
        [button setTitle:@"发送" forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    }
    if (target) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return buttonItem;
}




@end
