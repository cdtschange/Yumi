//
//  ChatListViewController.m
//  Yumi
//
//  Created by Mao on 12/29/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListTableViewCell.h"
#import "DateUtils.h"
#import "UserProvider.h"

static NSString *kChatListTableViewCellIdentify = @"ChatListTableViewCell";
@interface ChatListViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) YumiNetworkProvider *provider;
@property(nonatomic, strong)    NetworkProvider  *unreadProvider;
@property (assign, nonatomic) int lasttime;

@end

@implementation ChatListViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [[UserProvider shared] loadUnreadMessage];
    if (![AccountEntity shared].isLogin) {
        [self routeToName:@"LoginViewController" params:nil pop:YES];
        return;
    }
}

-(WaterViewType)listType{
    return WaterRefreshTypeOnlyRefresh;
}
-(UIScrollView *)listView{
    return self.tableView;
}
-(void)initUIAndData{
    [super initUIAndData];
    
    __weak ChatListViewController *weakself = self;
    self.provider = [YumiNetworkProvider new];
    [self.provider setCompletionBlockWithSuccess:^(id responseObject) {
        ChatsData *data = responseObject;
        [weakself dataArrayChanged:data.chats];
        YumiNetworkProvider *provider = [YumiNetworkProvider new];
        NSString *cids = [AccountEntity shared].cids;
        NSString *times = [AccountEntity shared].cidtimes;
        cids = cids?cids:@"";
        times = times?times:@"";
        [provider unreadChatsForCid:cids time:times];
        weakself.unreadProvider = provider;
        provider.statusBlock = weakself.listStatusBlock;
        [provider requestWithSuccess:^(id responseObject) {
            UnreadChatsData *data = responseObject;
            [weakself updateBadge:data];
            [weakself.tableView reloadData];
        } failure:^(NSError *error) {
//            weakself.listFailureBlock(error);
            [weakself.tableView reloadData];
        }];

        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
        weakself.listFailureBlock(error);
    }];
    self.provider.statusBlock = self.listStatusBlock;
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [[UserProvider shared] userInfoWithStatusBlock:nil success:nil failure:nil];
    [self loadData];
}
-(void)loadData{
    [super loadData];
    if (![AccountEntity shared].isLogin) {
        return;
    }
    self.dataIndex = 0;
    [self.provider chatsForStart:self.dataIndex num:self.listLoadNumber];
    [self.provider requestData];
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    [self.provider chatsForStart:self.dataIndex num:self.listLoadNumber];
    [self.provider useCache:!isRefresh];
    [self.provider requestData];
}
-(void)initNavigationBar{
    [super initNavigationBar];
}
-(void)initNotification{
    [super initNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify_RefreshUnreadChat:) name:NOTIFY_RefreshUnreadChat object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify_RefreshChatList:) name:NOTIFY_RefreshChatList object:nil];
}
- (void)notify_RefreshUnreadChat:(NSNotification *)notify{
    UnreadChatsData *data = notify.object;
    [self updateBadge:data];
}
- (void)notify_RefreshChatList:(NSNotification *)notify{
    NSDictionary *data = notify.object;
    NSString *cid = data[@"cid"];
    NSString *text = data[@"text"];
    BOOL isChanged = NO;
    for (Chats *c in self.dataArray) {
        if ([c.cid isEqualToString:cid]) {
            isChanged=YES;
            c.words = text;
            break;
        }
    }
    if (isChanged) {
        [self.tableView reloadData];
    }
}

-(void)updateBadge:(UnreadChatsData *)data{
    self.lasttime = (int)[NSDate date].timeIntervalSince1970;
    BOOL isChanged = NO;
    for (Chats *uc in data.chats) {
        BOOL isIn = NO;
        for (Chats *c in self.dataArray) {
            if ([c.cid isEqualToString:uc.cid]) {
                isIn=YES;
                if (c.badge!=uc.badge) {
                    isChanged = YES;
                    c.badge = uc.badge;
                    c.words = uc.words;
                }
                break;
            }
        }
        if (!isIn) {
            isChanged = YES;
            if (!self.dataArray) {
                self.dataArray = [NSMutableArray new];
            }
            [self.dataArray insertObject:uc atIndex:0];
        }
    }
    if (isChanged) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatListTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kChatListTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
    }
    Chats *chats = self.dataArray[indexPath.row];
    cell.badgeView.hidden = chats.badge==0;
    cell.badgeView.badgeString = [NSString stringWithFormat:@"%d", chats.badge];
    cell.lblTitle.text = chats.title;
    cell.lblContent.text = chats.words;
    [cell.imgHead setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:chats.pic]] placeholderImage:[UIImage imageNamed:IMG_HEAD_DEFAULT]];
    cell.lblTime.text = [DateUtils timeConvertToShort:chats.time];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Chats *chats = self.dataArray[indexPath.row];
    if (chats.badge>0) {
        chats.badge = 0;
        NSString *cids = [AccountEntity shared].cids;
        NSString *times = [AccountEntity shared].cidtimes;
        NSMutableArray *cidsarr = [NSMutableArray arrayWithArray: [cids split:@","]];
        NSMutableArray *timesarr = [NSMutableArray arrayWithArray: [times split:@","]];
        BOOL isIn=NO;
        for (int i=0; i<cidsarr.count; i++) {
            NSString *cid = cidsarr[i];
            if ([chats.cid isEqualToString:cid]) {
                timesarr[i] = [NSString stringWithFormat:@"%d", self.lasttime];
                isIn = YES;
                break;
            }
        }
        if (!isIn) {
            [cidsarr addObject:chats.cid];
            [timesarr addObject:[NSString stringWithFormat:@"%d", self.lasttime]];
        }
        cids = [cidsarr componentsJoinedByString:@","];
        times = [timesarr componentsJoinedByString:@","];
        [AccountEntity shared].cids = cids;
        [AccountEntity shared].cidtimes = times;
    }
    
    [self routeToName:@"ChatViewController" params:@{@"cid":chats.cid,@"name":chats.title,@"tpic":chats.pic}];
}


@end
