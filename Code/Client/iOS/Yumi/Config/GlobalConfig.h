//
//  GlobalConfig.h
//  G2R
//
//  Created by Wei Mao on 7/15/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#ifndef G2R_GlobalConfig_h
#define G2R_GlobalConfig_h


#pragma mark - URL

#define ITUNES_COMMENTS_URL @"http://itunes.apple.com/cn/app/wan-da-dian-ying/id517644732?ls=1&mt=8"

#define SERVER_IS_PRODUCT 0
#define SERVER_HOST_PRODUCT @"https://xapi.g2r.wanhui.cn"
#define SERVER_HOST_TEST @"http://meboke.com"
#define SERVER_UCENTER_HOST_PRODUCT @"http://openapi.wanhui.cn"
#define SERVER_UCENTER_HOST_TEST @"http://openapi.wanhui.cn"
#define SERVER_IMAGE_HOST_PRODUCT @"http://meboke.com"
#define SERVER_IMAGE_HOST_TEST @"http://meboke.com"
#define URL_PREFIX_PRODUCT @"https://g2r.wanhui.cn/h5"
#define URL_PREFIX_TEST @"http://g2r.test.wanhui.cn/h5"
#define URL_PREFIX SERVER_IS_PRODUCT?URL_PREFIX_PRODUCT:URL_PREFIX_TEST

#define URL_REGISTER_CONTRACT [NSString stringWithFormat:@"%@/contract/platformservice",URL_PREFIX]
#define URL_RISK_CONTRACT [NSString stringWithFormat:@"%@/contract/riskform",URL_PREFIX]
#define URL_INVEST_CONTRACT(x,y) [NSString stringWithFormat:@"%@/contract/sanfangzhaiquanzhuanrang?pid=%d&money=%d",URL_PREFIX,x,y]
#define URL_TRANSFER_CONTRACT(x,y,z) [NSString stringWithFormat:@"%@/contract/zhuanrang?tcid=%d&money=%d&contract=%@",URL_PREFIX,x,y,z]
#define URL_VIEWCONTRACT(x) [NSString stringWithFormat:@"%@/contract/viewcontract?contract=%@",URL_PREFIX,x]
#define URL_INVEST_DETAIL(x) [NSString stringWithFormat:@"%@/invest/detail?pid=%d",URL_PREFIX,x]
#define URL_TRANSFER_DETAIL(x) [NSString stringWithFormat:@"%@/transfer/detail?tcid=%d",URL_PREFIX,x]

#define KEY_UMENG @"541253ebfd98c50987007622"

#define CONST_TIP_KEEP_SECOND 2
#define CONST_NEED_UPGRADE_CODE 12006  //需要升级APP的Code
#define CONST_NEED_RELOGIN_CODE 12001   //需要重新登录Code
#define CONST_DBNAME @"wandag2r.db"   //数据库名称
#define CONST_KPDefaultCacheTime (10*60) // 默认缓存时间10分钟
#define CONST_APP_UploadDeviceInfoTime 60*60*24 // 上传设备信息的间隔时间：1天
#define CONST_DefaultNetworkCacheSize 30*1024*1024 //网络数据缓存默认空间：30M
#define CONST_DefaultNetworkCacheTime 1*24*60*60 //网络数据默认缓存时间：1天
#define CONST_AutoCheckUpdateTime 60*60*24 // 自动检测更新的时间间隔（1天）

#pragma mark - Color
#define COLOR_Default_SingerIsMe [UIColor colorWithRed:43/255.0 green:117/255.0 blue:43/255.0 alpha:1.0]
#define COLOR_Default_SingerUnknown [UIColor grayColor]
#define COLOR_Default_Red                   RGBCOLOR(206,0,18)
#define COLOR_Default_DarkRed               RGBCOLOR(200,0,80)
#define COLOR_Default_Blue                  RGBCOLOR(65,111,246)
#define COLOR_Default_DarkBlue              RGBCOLOR(0,91,191)
#define COLOR_Default_Green                 RGBCOLOR(0,192,179)
#define COLOR_Default_LightGreen            RGBCOLOR(128,199,74)
#define COLOR_Default_DarkGray              RGBCOLOR(65,65,65)
#define COLOR_Default_LightGray             RGBCOLOR(120,120,120)
#define COLOR_Default_DarkBrown             RGBCOLOR(130,110,90)
#define COLOR_Default_LightBrown            RGBCOLOR(200,180,160)
#define COLOR_Default_Black                 RGBCOLOR(40,40,40)
#define COLOR_Default_BlackBg               RGBCOLOR(29,29,29)
#define COLOR_Default_White                 RGBCOLOR(255,255,255)
#define COLOR_Default_Background            RGBCOLOR(250,249,247)
#define COLOR_Default_Yellow                RGBCOLOR(198,140,48)
#define COLOR_Default_DarkYellow            RGBCOLOR(232,170,67)
#define COLOR_Default_DarkYellowText        RGBCOLOR(206,112,0)
#define COLOR_Default_SectionBg             RGBCOLOR(239,233,229)
#define COLOR_Default_SectionBorder         RGBCOLOR(222,211,201)
#define COLOR_Default_SectionText           RGBCOLOR(132,109,94)
#define COLOR_Default_Seperator             RGBCOLOR(235,235,235)
#define COLOR_Default_Black_Hex @"'#282828'"
#define COLOR_Default_Red_Hex @"'#F02864'"
#define COLOR_Default_Blue_Hex @"'#057AFB'"
#define COLOR_Default_DarkGray_Hex @"'#282828'"
#define COLOR_Default_LightGray_Hex @"'#969696'"
#define COLOR_Default_DarkBrown_Hex @"'#826E5A'"
#define COLOR_Default_LightBrown_Hex @"'#C8B4A0'"

#define TXT_LINE @"\n-----------------------------------\n"

#pragma mark - Route

#define TVGoToHomeView              @"GoToHomeView"
#define TVGoToLoginView             @"GoToLoginView"
#define TVGoToRegisterPreView       @"GoToRegisterPreView"
#define TVGoToRegisterView          @"GoToRegisterView"

#pragma mark - Notify

#define NOTIFY_RefreshLogin @"notify_refreshLogin"//更新登录状态
#define NOTIFY_RefreshUnreadChat @"notify_refreshUnreadChat"//更新未读聊天消息
#define NOTIFY_RefreshChatList @"notify_refreshChatList"//更新聊天消息
#define NOTIFY_RefreshUserProfile  @"notify_refreshUserProfile" //更新用户信息
#define NOTIFY_RefreshCards  @"notify_refreshCards" //更新用户卡信息

#pragma mark - Image

#define IMG_Default_Small @"img_default_small"
#define IMG_Head_Default_Small @"img_head_small"
#define IMG_Head_Default_Big @"img_head_big"

#define ICON_EMPTYVIEW_LOGO @"img_empty_default"


#define IMG_HOME_TAB_BAR_0 @"tab_home_bg_1"
#define IMG_HOME_TAB_BAR_1 @"tab_home_bg_2"
#define IMG_HOME_TAB_BAR_2 @"tab_home_bg_3"
#define IMG_HOME_TAB_BAR_3 @"tab_home_bg_4"
#define IMG_HOME_TAB_BAR_4 @"tab_home_bg_5"

#define IMG_NAV_TOP_BAR @"top_bar"
#define IMG_NAV_TOP_LOGIN_BAR @"top_login_bar"
#define IMG_NAV_BTN_CLOSE @""
#define IMG_NAV_BTN_LOGO @"top_bar_logo"

#define IMG_HOME_CELL_ICON1 @"icon_home_cell1"
#define IMG_HOME_CELL_ICON2 @"icon_home_cell2"
#define IMG_HOME_CELL_ICON3 @"icon_home_cell3"

#define IMG_HEAD_DEFAULT @"icon_head_default"


#pragma mark - Text

#define TXT_LOADING                 @"正在加载..."
#define TXT_SAVE_SECCESS            @"保存成功"
#define TXT_SAVE_FAILED             @"保存失败"
#define TXT_ERROR_NETWORK           @"网络错误"
#define TXT_Login_LoginSuccess      @"登录成功"
#define TXT_Login_CreateUser        @"创建中..."
#define TXT_Login_UpdateUser        @"更新中..."
#define TXT_Login_GetUserProfile    @"获取中..."
#define TXT_Login_USERLOGIN         @"用户登录中..."
#define TXT_Login_DeleteUserImage   @"删除图片中..."
#define TXT_Default_EmptyData       @"没有符合条件的记录"
#define TXT_REFRESH_SUCCESS         @"刷新成功"
#define TXT_REFRESH_FAILED          @"刷新失败"
#define TXT_ERROR_PARAMETER         @"参数错误"


#endif
