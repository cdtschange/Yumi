//
//  MyViewController.m
//  Yumi
//
//  Created by Mao on 12/29/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "MyViewController.h"
#import "MyTableViewCell.h"

static NSString *kMyTableViewCellIdentify = @"MyTableViewCell";

@interface MyViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (strong, nonatomic) NSArray *source;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(WaterViewType)listType{
    return WaterRefreshTypeNone;
}
-(UIScrollView *)listView{
    return self.tableView;
}
-(void)initUIAndData{
    [super initUIAndData];
    self.source = @[
  @{@"title":@"个人资料",@"image":@"icon_my_profile",@"url":@"UserProfileViewController"},
  @{@"title":@"邀请好友",@"image":@"icon_my_invite"},
  @{@"title":@"生词本",@"image":@"icon_my_dictionary",@"url":@"NewWordsViewController"},
  @{@"title":@"测评中心",@"image":@"icon_my_exam"},
  @{@"title":@"我的语言",@"image":@"icon_my_language"},
  @{@"title":@"消息中心",@"image":@"icon_my_message"}];
    [self dataArrayChanged:self.source];
    [self.tableView reloadData];
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.tableHeaderView = self.viewHeader;
    [self loadData];
}
-(void)loadData{
    [super loadData];
    [self.imgHead setImageWithURL:[NSURL URLWithString:[[AccountEntity shared].picsrc imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
    self.imgHead.isRounded = YES;
    self.lblName.text = [AccountEntity shared].name;
    self.lblInfo.text = [NSString stringWithFormat:@"语伴号：14897261"];
    self.dataIndex = 0;
    [self.tableView reloadData];
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    [self.tableView reloadData];
}
-(void)initNavigationBar{
    [super initNavigationBar];
}
-(void)click_settings:(id)sender{
    [self routeToName:@"SettingsViewController" params:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return 3;
    }
    if (section==2) {
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kMyTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
    }
    NSDictionary *obj;
    if (indexPath.section==0) {
        obj = self.dataArray[indexPath.row];
    }else if (indexPath.section==1) {
        obj = self.dataArray[indexPath.row+2];
    }else if (indexPath.section==2) {
        obj = self.dataArray[indexPath.row+5];
    }
    cell.lblTitle.text = obj[@"title"];
    cell.imgPic.image = [UIImage imageNamed:obj[@"image"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *obj;
    if (indexPath.section==0) {
        obj = self.dataArray[indexPath.row];
    }else if (indexPath.section==1) {
        obj = self.dataArray[indexPath.row+2];
    }else if (indexPath.section==2) {
        obj = self.dataArray[indexPath.row+5];
    }
    if ([obj objectForKey:@"url"]) {
        [self routeToName:obj[@"url"] params:@{@"uid":[AccountEntity shared].uid}];
    }else{
        [self showInfoTip:@"此功能暂未开放，敬请期待"];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 16)];
    view.backgroundColor = RGBCOLOR(250,250,250);
    return view;
}

@end
