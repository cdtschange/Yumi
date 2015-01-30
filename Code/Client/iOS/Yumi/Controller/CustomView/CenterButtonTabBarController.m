//
//  CenterButtonTabBarView.m
//  WandaKTV
//
//  Created by Wei Mao on 5/24/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "CenterButtonTabBarController.h"


@interface CenterButtonTabBarController (){
    UIImageView *tabViewBG;
}
@end

@implementation CenterButtonTabBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
    tabViewBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_HOME_TAB_BAR_0]];
    tabViewBG.frame = CGRectMake(0, 0, self.tabBar.frame.size.width,
                                 self.tabBar.frame.size.height);
    tabViewBG.contentMode = UIViewContentModeScaleToFill;
    [self.tabBar addSubview:tabViewBG];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    int index = (int)[tabBar.items indexOfObject:item];
    switch (index) {
        case 0:
            tabViewBG.image = [UIImage imageNamed:IMG_HOME_TAB_BAR_0];
            break;
        case 1:
            tabViewBG.image = [UIImage imageNamed:IMG_HOME_TAB_BAR_1];
            break;
        case 2:
            tabViewBG.image = [UIImage imageNamed:IMG_HOME_TAB_BAR_2];
            break;
        case 3:
            tabViewBG.image = [UIImage imageNamed:IMG_HOME_TAB_BAR_3];
            break;
        case 4:
            tabViewBG.image = [UIImage imageNamed:IMG_HOME_TAB_BAR_4];
            break;
        default:
            break;
    }
}
@end
