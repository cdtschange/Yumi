//
//  NewFriendsViewController.m
//  Yumi
//
//  Created by Mao on 12/31/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "FriendTableViewCell.h"

static NSString *kFriendTableViewCellIdentify = @"NewFriendTableViewCell";

@interface NewFriendsViewController ()<NewFriendTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) YumiNetworkProvider *provider;
@property (strong, nonatomic) YumiNetworkProvider *acceptProvider;

@end

@implementation NewFriendsViewController

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
    self.title = @"新的朋友";
    
    __weak NewFriendsViewController *weakself = self;
    self.provider = [YumiNetworkProvider new];
    [self.provider setCompletionBlockWithSuccess:^(id responseObject) {
        UserRequestsData *data = responseObject;
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
    [self.provider userRequests];
    [self.provider requestData];
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    [self.provider userRequests];
    [self.provider useCache:!isRefresh];
    [self.provider requestData];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendTableViewCell" owner:self options:nil] objectAtIndex:1];
        cell.delegate = self;
    }
    User *user = self.dataArray[indexPath.row];
    cell.lblName.text = user.u_name;
    [cell.imgHead setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:user.pic]] placeholderImage:[UIImage imageNamed:IMG_HEAD_DEFAULT]];
    cell.lblInfo.text = user.reason;
    cell.btn.backgroundColor = user.state>0?COLOR_Default_Green:RGBCOLOR(210, 211, 214);
    cell.btn.enabled = user.state>0;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *user = self.dataArray[indexPath.row];
    [self routeToName:@"UserProfileViewController" params:@{@"uid":user.uid}];
}
-(void)cell_clickAddForCell:(NewFriendTableViewCell *)cell sender:(id)sender{
    __weak NewFriendsViewController *weakself = self;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.acceptProvider = [YumiNetworkProvider new];
    __weak User *user = self.dataArray[indexPath.row];
    [self.acceptProvider acceptUserForTuid:user.uid];
    [self.acceptProvider setCompletionBlockWithSuccess:^(id responseObject) {
        user.state = 0;
        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
        weakself.failureBlock(error);
    }];
    self.acceptProvider.statusBlock = self.statusBlock;
    [self.acceptProvider requestData];
}

@end
