//
//  UserProfileViewController.m
//  Yumi
//
//  Created by Mao on 15/1/18.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AddUserViewController.h"
#import "ProfileTableViewCell.h"

static NSString *kProfileTableViewCellIdentify = @"ProfileTableViewCell";
static NSString *kProfileTableViewCell2Identify = @"ProfileTableViewCell2";
static NSString *kProfileHeadTableViewCellIdentify = @"ProfileHeadTableViewCell";

@interface UserProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (assign, nonatomic) BOOL isAdd;
@property (copy, nonatomic) NSString *uname;
@property (copy, nonatomic) NSString *upic;

@end

@implementation UserProfileViewController

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
    self.title = @"个人资料";
    self.btnAdd.layer.cornerRadius = 3;
    self.btnAdd.layer.masksToBounds = YES;
    self.btnChat.hidden = YES;
    [self.viewFooter setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self loadData];
}
-(void)loadData{
    [super loadData];
    [self.viewFooter removeFromSuperview];
    self.viewFooter.top = 0;
    if ([self.uid isEqualToString: [AccountEntity shared].uid]) {
        UIView * view = [[UIView alloc] init];
        self.tableView.tableFooterView = view;
    }else{
        self.tableView.tableFooterView = self.viewFooter;
    }
    
    __weak UserProfileViewController *weakself = self;
    NSURLSessionTask *task = [[UserProfileAPIData initWithTuid:self.uid] requestWithSuccess:^(id responseObject) {
        UserProfileAPIData *data = responseObject;
        weakself.uname = data.u_name;
        weakself.upic = data.pic;
        if (data.state==0) {
            weakself.btnChat.hidden = NO;
            weakself.isAdd = NO;
            weakself.btnAdd.selected = YES;
            weakself.btnAdd.backgroundColor = RGBCOLOR(250, 101, 105);
        }else{
            [weakself.btnChat setTranslatesAutoresizingMaskIntoConstraints:YES];
            weakself.btnChat.height = 0;
            weakself.isAdd = YES;
            weakself.btnAdd.selected = NO;
            weakself.btnAdd.backgroundColor = COLOR_Default_Green;
        }
        NSArray *arr = @[@{@"title":@"地区",@"value":data.department},
                         @{@"title":@"语言",@"value":data.languages}];
        [weakself dataArrayChanged:arr];
        [weakself.tableView reloadData];
    } failure:self.failureBlock];
    [self setNetworkStateOfTask:task];
}

-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
}
- (IBAction)click_add:(id)sender {
    if (self.isAdd) {
        AddUserViewController *vc = [UIViewController instanceByName:@"AddUserViewController"];
        vc.uid = self.uid;
        __weak UserProfileViewController *weakself = self;
        vc.block = ^(BOOL added, NSString* reason){
            if (added) {
                NSURLSessionTask *task = [[AddUserAPIData initWithTuid:weakself.uid reason:reason] requestWithSuccess:^(id responseObject) {
                    [weakself showInfoTip:@"发送好友邀请成功"];
                } failure:self.failureBlock];
                [weakself setNetworkStateOfTask:task];
            }
        };
        UINavigationController *nav = [[[self.navigationController class] alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        __weak UserProfileViewController *weakself = self;
        NSURLSessionTask *task = [[DelUserAPIData initWithTuid:weakself.uid] requestWithSuccess:^(id responseObject) {
            weakself.isAdd = YES;
            weakself.btnAdd.selected = NO;
            weakself.btnAdd.backgroundColor = COLOR_Default_Green;
            [weakself.btnChat setTranslatesAutoresizingMaskIntoConstraints:YES];
            weakself.btnChat.height = 0;
        } failure:self.failureBlock];
        [weakself setNetworkStateOfTask:task];
    }
}
- (IBAction)click_chat:(id)sender {
    [self routeToName:@"ChatViewController" params:@{@"tuid":self.uid,@"name":self.uname}];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==1){
        return [self.dataArray count];
    }else if(section<4){
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ProfileHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileHeadTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewCell" owner:self options:nil] objectAtIndex:2];
        }
        if ([self.uid isEqualToString:[AccountEntity shared].uid]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.lblName.text = self.uname;
        cell.lblInfo.text = [NSString stringWithFormat:@"语密号：14897261"];
        cell.imgHead.isRounded = YES;
        [cell.imgHead setImageWithURL:[NSURL URLWithString:[self.upic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
        return cell;
    }else if (indexPath.section==1) {
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSDictionary *data = self.dataArray[indexPath.row];
        cell.lblTitle.text = data[@"title"];
        cell.lblValue.text = data[@"value"];
        return cell;
    }else if (indexPath.section==2) {
        ProfileTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:kProfileTableViewCell2Identify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewCell" owner:self options:nil] objectAtIndex:1];
        }
        return cell;
    }else if (indexPath.section==3) {
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.lblTitle.text = @"个人主页";
        cell.lblValue.text = @"";
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([self.uid isEqualToString:[AccountEntity shared].uid]) {
            [self routeToName:@"ProfileViewController" params:nil];
        }
    }else if (indexPath.section == 3){
        [self routeToName:@"CircleFriendsViewController" params:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 84;
    }
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 16;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    view.backgroundColor = RGBCOLOR(250,250,250);
    return view;
}
@end
