//
//  RegisterViewController.m
//  G2R
//
//  Created by Wei Mao on 7/18/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "RegisterAuthCodeViewController.h"
#import "MHTextField.h"
#import "UserProvider.h"
#import "UIDevice+Kit.h"

#define kMaxRemainSecond            60

@interface RegisterAuthCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet MHTextField *txtAuthCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSendCode;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) IBOutlet UILabel *lblSendCode;
@property (weak, nonatomic) IBOutlet UIView *viewAuthCode;

@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) int stopTime;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (nonatomic, strong) G2RNetworkProvider *provider;

@end

@implementation RegisterAuthCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)dealloc{
    [self stopTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUIAndData{
    [super initUIAndData];
//    self.provider = [G2RNetworkProvider new];
    [self loadData];
    
    self.title = @"注册账号";
    self.lblTip.text = [NSString stringWithFormat:@"已向%@发送验证短信，请输入其中6位数字",self.mobile];
    self.lblSendCode.text = @"获取验证码";
    self.viewAuthCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewAuthCode.layer.borderWidth = 0.5;
    self.viewAuthCode.layer.cornerRadius = 3;
    self.viewAuthCode.layer.masksToBounds = YES;
    self.btnOK.layer.cornerRadius = 3;
    self.btnOK.layer.masksToBounds = YES;
    self.btnSendCode.layer.cornerRadius = 3;
    self.btnSendCode.layer.masksToBounds = YES;
    [self click_SendCode:nil];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    if (self.previousViewControllerInNavigation == nil) {
        [self.navigationItem setHidesBackButton:YES animated:YES];
        self.canDragBack = NO;
        return;
    }
    [self setBackLeftButtonOnNavBar];
}
-(void)loadData{
    [super loadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click_sendCodeProblem:(id)sender {
}
- (IBAction)click_SendCode:(id)sender {
    [self setCountDownState];
//    __weak RegisterAuthCodeViewController *weakself = self;
//    self.provider = [G2RNetworkProvider new];
//    int type = AuthCodeTypeRegister;
//    if (self.loginpwd.length>0) {
//        type = AuthCodeTypeFillInfo;
//    }
//    [self.provider userAuthCodeForMobile:self.mobile type:type];
//    [self.provider requestWithSuccess:^(id responseObject) {
//    } failure:^(NSError *error) {
//        [weakself stopTimer];
//        weakself.btnSendCode.enabled = YES;
//        weakself.lblSendCode.text = @"获取验证码";
//        [weakself showInfoTip:[G2RNetworkProvider errorToString:error]];
//    }];
}
- (IBAction)click_ok:(id)sender {
    [self.txtAuthCode resignFirstResponder];
//    __weak RegisterAuthCodeViewController *weakself = self;
//    self.provider = [G2RNetworkProvider new];
//    [self.provider userCreateForUserName:self.txtName.text mobile:self.mobile passwd:loginpassword paymentPassword:self.txtPayPassword.text authCode:self.txtAuthCode.text passwordLevel:[UserProvider caculatePasswordLevelByPwd:self.txtPassword.text]];
//    self.provider.statusBlock = self.statusBlock;
//    [self.provider requestWithSuccess:^(id responseObject) {
//        [weakself showInfoTip:@"注册成功" complete:^{
//            [AccountEntity shared].checkmobile = 1;
//            [weakself routeToName:@"AuthViewController" params:@{@"username":weakself.mobile,@"passwd":loginpassword}];
//        }];
//    } failure:self.failureBlock];
    [self routeToName:@"RegisterViewController" params:@{@"mobile":self.mobile}];
}


- (void)stopTimer
{
    if (self.countDownTimer != nil) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}
- (void)showCurrentRemainSecond
{
    int nowSince = [[NSDate date] timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"%d秒后重发",self.stopTime - nowSince];
    self.lblSendCode.text = str;
}
- (void)setCountDownState
{
    self.stopTime = [[NSDate date] timeIntervalSince1970];
    self.stopTime += kMaxRemainSecond;
    self.btnSendCode.enabled = NO;
    [self showCurrentRemainSecond];
    [self stopTimer];
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
}
- (void)countDownAction
{
    if ([[NSDate date] timeIntervalSince1970] > self.stopTime) {
        [self stopTimer];
        self.btnSendCode.enabled = YES;
        self.lblSendCode.text = @"获取验证码";
    } else {
        [self showCurrentRemainSecond];
    }
}

@end
