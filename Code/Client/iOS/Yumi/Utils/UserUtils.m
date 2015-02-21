//
//  UserUtils.m
//  WandaKTV
//
//  Created by Wei Mao on 7/18/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "UserUtils.h"
#import "AccountEntity.h"

@interface UserUtils()


//@property (copy, nonatomic) WandaUtilsCompleteBlock blockBindBankCard;

@property (nonatomic, weak) UIViewController *viewController;
@end



@implementation UserUtils

+ (UserUtils *)shared{
    static UserUtils *shared_ = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shared_ = [[UserUtils alloc] init];
    });
    return shared_;
}

-(id)init{
    if (self = [super init]) {
    }
    return self;
}
//上传用户图片
//-(void)uploadUserImage:(UIImage *)image compelete:(WandaUtilsCompleteBlock)block{
//    self.blockUploadUserImage = block;
//    __weak UserUtils *weakself = self;
//     __weak UIView *view = [WandaUtils getDisplayView];
//    [MyActivityHUDHelper displayUploadProgressInView:view];
//    self.kpUploadPic = [[KPUploadPic alloc] initWithSucceeBlock:^(G2RProvider *kp) {
//        [MyActivityHUDHelper removeActivityLoading];
//        KPUploadPic *kpp = (KPUploadPic *)kp;
//        AccountEntity *account = [AccountEntity shared];
//        if (!account.headUrl||[account.headUrl isEqualToString:@""]) {
//            [weakself updateUser:account.nick gender:account.gender headUrl:kpp.picName compelete:nil];
//        }
//        if (weakself.blockUploadUserImage) {
//            weakself.blockUploadUserImage(YES,nil);
//            weakself.blockUploadUserImage = nil;
//        }
//    } failureBlock:^(G2RProvider *kp) {
//        [MyActivityHUDHelper removeActivityLoading];
//        [WandaUtils showInfoTip:kp.msg];
//        if (weakself.blockUploadUserImage) {
//            weakself.blockUploadUserImage(NO,kp.msg);
//            weakself.blockUploadUserImage = nil;
//        }
//    } statusBlock:^(G2RProvider *kp, ApiBlockStatus status) {
//        if (status == kApiBlockFailed) {
//            if (weakself.blockUploadUserImage) {
//                weakself.blockUploadUserImage(NO,kp.msg);
//                weakself.blockUploadUserImage = nil;
//            }
//        }
//    }];
//    self.kpUploadPic.processBlock = ^(G2RProvider *kp, float newProcess) {
//        [MyActivityHUDHelper uploadProgressInView:view setProgress:newProcess];
//    };
//    [self.kpUploadPic requestWithData:UIImagePNGRepresentation(image) notUserAvatar:NO];
//}
//删除用户图片
//-(void)deleteUserImage:(NSString *)name compelete:(WandaUtilsCompleteBlock)block{
//    self.blockDeleteUserImage = block;
//    __weak UserUtils *weakself = self;
//    self.kpDeletePic= [[KPDeletePic alloc] initWithSucceeBlock:^(G2RProvider *kp) {
//        AccountEntity *account = [AccountEntity shared];
//        NSMutableArray *arr = [NSMutableArray arrayWithArray:account.userPics];
//        [arr removeObject:name];
//        account.userPics = [NSArray arrayWithArray:arr];
//        if (weakself.blockDeleteUserImage) {
//            weakself.blockDeleteUserImage(YES,nil);
//            weakself.blockDeleteUserImage = nil;
//        }
//    } failureBlock:^(G2RProvider *kp) {
//        if (weakself.blockDeleteUserImage) {
//            weakself.blockDeleteUserImage(NO,kp.msg);
//            weakself.blockDeleteUserImage = nil;
//        }
//    } statusBlock:^(G2RProvider *kp, ApiBlockStatus status) {
//        [WandaUtils apiStatusChanged:status loadingMsg:TXT_Login_DeleteUserImage errorMsg:kp.msg];
//    }];
//    [self.kpDeletePic requestWithPicName:name];
//}

//-(void)validAuthCode:(NSString *)authCode compelete:(WandaUtilsCompleteBlock)block{
//    self.blockResetPasswd = block;
//    __weak UserUtils *weakself = self;
//    self.kpResetPasswd = [[KPResetPasswd alloc] initWithSucceeBlock:^(G2RProvider *kp) {
//        if (weakself.blockResetPasswd) {
//            weakself.blockResetPasswd(YES,nil);
//            weakself.blockResetPasswd = nil;
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RefreshLogin object:nil];
//    } failureBlock:^(G2RProvider *kp) {
//        if (weakself.blockResetPasswd) {
//            weakself.blockResetPasswd(NO,kp.msg);
//            weakself.blockResetPasswd = nil;
//        }
//    } statusBlock:^(G2RProvider *kp, ApiBlockStatus status) {
//        [WandaUtils apiStatusChanged:status loadingMsg:TXT_LOADING errorMsg:kp.msg];
//    }];
//    [self.kpResetPasswd requestWithMobile:mobile passwd:password authCode:authCode];
//}


@end
