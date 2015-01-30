//
//  RegisterViewController.m
//  Yumi
//
//  Created by Mao on 12/29/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "RegisterViewController.h"
#import "MHTextField.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet MHTextField *txtPassword;
@property (weak, nonatomic) IBOutlet MHTextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (nonatomic, strong) G2RNetworkProvider *provider;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUIAndData{
    [super initUIAndData];
//    self.provider = [G2RNetworkProvider new];
    [self loadData];
    
    self.title = @"注册账号";
    self.lblMobile.text = [NSString stringWithFormat:@"%@",self.mobile];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
}
-(void)loadData{
    [super loadData];
}
- (IBAction)click_ok:(id)sender {
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    if (![self.txtPassword.text equals:self.txtConfirmPassword.text]) {
        [self showInfoTip:@"两次输入的登录密码不一致"];
        return;
    }
//    __weak RegisterViewController *weakself = self;
//    self.provider = [G2RNetworkProvider new];
//    [self.provider userCreateForUserName:self.txtName.text mobile:self.mobile passwd:loginpassword paymentPassword:self.txtPayPassword.text authCode:self.txtAuthCode.text passwordLevel:[UserProvider caculatePasswordLevelByPwd:self.txtPassword.text]];
//    self.provider.statusBlock = self.statusBlock;
//    [self.provider requestWithSuccess:^(id responseObject) {
//        [weakself showInfoTip:@"注册成功" complete:^{
//            [AccountEntity shared].checkmobile = 1;
//            [weakself routeToName:@"AuthViewController" params:@{@"username":weakself.mobile,@"passwd":loginpassword}];
//        }];
//    } failure:self.failureBlock];
    [self routeToName:@"ProfileViewController" params:@{@"isFirst":@(YES)}];
}


@end
