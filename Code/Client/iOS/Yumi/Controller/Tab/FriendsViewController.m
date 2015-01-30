//
//  FriendsViewController.m
//  Yumi
//
//  Created by Mao on 12/29/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendTableViewCell.h"

static NSString *kFriendTableViewCellIdentify = @"FriendTableViewCell";

@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) YumiNetworkProvider *provider;
@property (strong, nonatomic) NSArray *guideArray;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(WaterViewType)listType{
    return WaterRefreshTypeOnlyRefresh;
}
-(UIScrollView *)listView{
    return self.tableView;
}
-(void)initUIAndData{
    [super initUIAndData];
    User *u1 = [User new];
    u1.u_name = @"新的朋友";
    u1.pic = @"icon_friend_new";
    User *u2 = [User new];
    u2.u_name = @"我的群聊";
    u2.pic = @"icon_friend_group";
    User *u3 = [User new];
    u3.u_name = @"标签";
    u3.pic = @"icon_friend_tag";
    self.guideArray = [NSMutableArray arrayWithArray:@[u1,u2,u3]];
    __weak FriendsViewController *weakself = self;
    self.provider = [YumiNetworkProvider new];
    [self.provider setCompletionBlockWithSuccess:^(id responseObject) {
        UsersData *data = responseObject;
        [weakself dataArrayChanged:data.users];
        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
        weakself.listFailureBlock(error);
    }];
    self.provider.statusBlock = self.listStatusBlock;
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self loadData];
}
-(void)loadData{
    [super loadData];
    self.dataIndex = 0;
    [self.provider users];
    [self.provider requestData];
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    [self.provider users];
    [self.provider useCache:!isRefresh];
    [self.provider requestData];
}
-(void)initNavigationBar{
    [super initNavigationBar];
}
-(void)click_addFriends:(id)sender{
    [self showInfoTip:@"此功能暂未开放，敬请期待"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.guideArray.count;
    }
    return [self.dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kFriendTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
    }
    User *user;
    if (indexPath.section==0) {
        user = self.guideArray[indexPath.row];
        [cell.imgHead setImage:[UIImage imageNamed:user.pic]];
    }else{
        user = self.dataArray[indexPath.row];
        [cell.imgHead setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:user.pic]] placeholderImage:[UIImage imageNamed:IMG_HEAD_DEFAULT]];
    }
    cell.lblName.text = user.u_name;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            [self routeToName:@"NewFriendsViewController" params:nil];
            return;
        }else if(indexPath.row == 1){
            [self showInfoTip:@"此功能暂未开放，敬请期待"];
            return;
        }else if(indexPath.row == 2){
            [self showInfoTip:@"此功能暂未开放，敬请期待"];
            return;
        }
    }else{
        User *user = self.dataArray[indexPath.row];
        [self routeToName:@"ChatViewController" params:@{@"tuid":user.uid,@"name":user.u_name}];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    view.backgroundColor = RGBCOLOR(250,250,250);
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 9, 320, 1)];
//    line1.backgroundColor = RGBCOLOR(228,229,230);
//    line2.backgroundColor = RGBCOLOR(228,229,230);
//    [view addSubview:line1];
//    [view addSubview:line2];
    return view;
}
@end
