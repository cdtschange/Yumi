//
//  NewWordsSettingViewController.m
//  Yumi
//
//  Created by Mao on 1/26/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "NewWordsSettingViewController.h"
#import "CQMFloatingController.h"

@interface NewWordsSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@end

@implementation NewWordsSettingViewController

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
    self.btnCancel.layer.cornerRadius = 3;
    self.btnCancel.layer.masksToBounds = YES;
    self.btnOK.layer.cornerRadius = 3;
    self.btnOK.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 3;
    self.view.layer.masksToBounds = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click_btn1:(id)sender {
    self.btn1.selected = YES;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    self.lbl1.textColor = COLOR_Default_Green;
    self.lbl2.textColor = [UIColor darkGrayColor];
    self.lbl3.textColor = [UIColor darkGrayColor];
}
- (IBAction)click_btn2:(id)sender {
    self.btn1.selected = NO;
    self.btn2.selected = YES;
    self.btn3.selected = NO;
    self.lbl1.textColor = [UIColor darkGrayColor];
    self.lbl2.textColor = COLOR_Default_Green;
    self.lbl3.textColor = [UIColor darkGrayColor];
}
- (IBAction)click_btn3:(id)sender {
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = YES;
    self.lbl1.textColor = [UIColor darkGrayColor];
    self.lbl2.textColor = [UIColor darkGrayColor];
    self.lbl3.textColor = COLOR_Default_Green;
}
- (IBAction)click_cancel:(id)sender {
    [[CQMFloatingController sharedFloatingController] dismissAnimated:YES];
}
- (IBAction)click_ok:(id)sender {
    [[CQMFloatingController sharedFloatingController] dismissAnimated:YES];
}

@end
