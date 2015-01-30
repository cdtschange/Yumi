//
//  ShareUtils.m
//  WandaKTV
//
//  Created by Wei Mao on 7/19/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "ShareUtils.h"
#import "IconActionSheet.h"
#import "AppDelegate.h"

@interface ShareUtils()<UIActionSheetDelegate, UIAlertViewDelegate, IconActionSheetDelegate>
@end


@implementation ShareUtils

+ (ShareUtils *)shared{
    static ShareUtils *shared_ = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shared_ = [[ShareUtils alloc] init];
    });
    return shared_;
}

- (void)shareWithText:(NSString *)text{
    UIWindow *window = [AppDelegate appDelegate].window;
    IconActionSheet *_actionSheet = [[IconActionSheet alloc] initWithDelegate:self
                                                                        title:@"分享到"
                                                                    itemCount:[self numberOfItemsInActionSheet]];
    [_actionSheet showInView:window];
}
#pragma mark - IconActionSheetDelegate
-(int)numberOfItemsInActionSheet
{
    return 3;
}

-(IconActionSheetCell *)cellForActionAtIndex:(NSInteger)index
{
    IconActionSheetCell* cell = [[IconActionSheetCell alloc] init];
    cell.index = (int)index;
    NSString *title;
    NSString *icon;
    switch (index) {
        case 0:
            title = @"微信";
            icon = @"icon_share_wechat";
            break;
        case 1:
            title = @"朋友圈";
            icon = @"icon_share_wechat_circle";
            break;
        case 2:
            title = @"QQ好友";
            icon = @"icon_share_qq";
            break;
        default:
            break;
    }
    [[cell titleLabel] setText:title];
    [[cell iconView] setImage:[UIImage imageNamed:icon]];
    return cell;
}

-(void)didTapOnItemAtIndex:(NSInteger)index
{
   
}

@end
