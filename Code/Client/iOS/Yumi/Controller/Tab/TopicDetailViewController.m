//
//  TopicDetailViewController.m
//  Yumi
//
//  Created by Mao on 1/6/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "TopicReplyTableViewCell.h"
#import "FriendTableViewCell.h"
#import "CommentViewController.h"
#import "CQMFloatingController.h"
#import "DateUtils.h"
#import "ShareUtils.h"

static NSString *kTopicReplyTableViewCellIdentify = @"TopicReplyTableViewCell";
static NSString *kFriendTableViewCellIdentify = @"FriendTableViewCell";

@interface TopicDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnTabNew;
@property (weak, nonatomic) IBOutlet UIButton *btnTabHot;
@property (weak, nonatomic) IBOutlet UIButton *btnTabFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnPublish;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewCursor;
@property (strong, nonatomic) YumiNetworkProvider *replyProvider;
@property (strong, nonatomic) YumiNetworkProvider *followerProvider;
@property (strong, nonatomic) YumiNetworkProvider *provider;
@property (strong, nonatomic) YumiNetworkProvider *followProvider;
@property (strong, nonatomic) YumiNetworkProvider *commentProvider;
@property (copy, nonatomic) NSString *sort;

@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)click_follow:(id)sender {
    __weak TopicDetailViewController *weakself = self;
    self.followProvider = [YumiNetworkProvider new];
    [self.followProvider operateTopicForTid:self.tid action:self.btnFollow.selected?@"unfollow":@"follow"];
    self.followProvider.statusBlock = self.statusBlock;
    [self.followProvider requestWithSuccess:^(id responseObject) {
        weakself.btnFollow.selected = !weakself.btnFollow.selected;
        if (weakself.btnFollow.selected) {
            weakself.btnFollow.backgroundColor = COLOR_Default_Green;
        }else{
            weakself.btnFollow.backgroundColor = [UIColor whiteColor];
        }
    } failure:^(NSError *error) {
        weakself.failureBlock(error);
    }];
}
- (IBAction)click_reply:(id)sender {
    __weak TopicDetailViewController *weakself = self;
    CommentViewController *vc = [UIViewController instanceByName:@"CommentViewController"];
    vc.block = ^(BOOL select, NSString *content) {
        if (select&&content.length>0) {
            weakself.commentProvider = [YumiNetworkProvider new];
            [weakself.commentProvider replyTopicForTid:weakself.tid content:content];
            weakself.commentProvider.statusBlock = weakself.statusBlock;
            [weakself.commentProvider requestWithSuccess:^(id responseObject) {
                [weakself loadData];
            } failure:^(NSError *error) {
                weakself.failureBlock(error);
            }];
        }
    };
    UINavigationController *nav = [[[self.navigationController class] alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)click_TabNew:(id)sender {
    double cw = self.viewCursor.width;
    double vw = self.view.width;
    __weak TopicDetailViewController *weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakself.viewCursor.left = (vw/3-cw)/2;
    }];
    self.btnTabFollow.selected = NO;
    self.btnTabHot.selected = NO;
    self.btnTabNew.selected = NO;
    [(UIButton *)sender setSelected:YES];
    self.sort = @"time";
    [self loadData];
}
- (IBAction)click_TabHot:(id)sender {
    double cw = self.viewCursor.width;
    double vw = self.view.width;
    __weak TopicDetailViewController *weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakself.viewCursor.left = (vw/3-cw)/2 + vw/3;
    }];
    self.btnTabFollow.selected = NO;
    self.btnTabHot.selected = NO;
    self.btnTabNew.selected = NO;
    [(UIButton *)sender setSelected:YES];
    self.sort = @"hot";
    [self loadData];
}
- (IBAction)click_TabFollow:(id)sender {
    double cw = self.viewCursor.width;
    double vw = self.view.width;
    __weak TopicDetailViewController *weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakself.viewCursor.left = (vw/3-cw)/2 + vw/3*2;
    }];
    self.btnTabFollow.selected = NO;
    self.btnTabHot.selected = NO;
    self.btnTabNew.selected = NO;
    [(UIButton *)sender setSelected:YES];
    self.sort = @"follower";
    [self loadData];
}
- (IBAction)click_share:(id)sender {
    [[ShareUtils shared] shareWithText:@""];
}
- (IBAction)click_like:(id)sender {
    self.btnLike.selected = !self.btnLike.selected;
    int cnt = [[self.btnLike titleForState:UIControlStateNormal] intValue];
    if (self.btnLike.selected) {
        cnt++;
    }else{
        cnt--;
    }
    [self.btnLike setTitle:[NSString stringWithFormat:@"%d",cnt] forState:UIControlStateNormal];
}


-(WaterViewType)listType{
    return WaterRefreshTypeOnlyRefresh;
}
-(UIScrollView *)listView{
    return self.tableView;
}
-(void)initUIAndData{
    [super initUIAndData];
    self.title = @"话题详情";
    self.sort = @"time";
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self.viewHeader removeFromSuperview];
    [self.viewHeader setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.lblContent setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.viewCursor setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    self.btnFollow.layer.cornerRadius = 3;
    self.btnFollow.layer.masksToBounds = YES;
    self.btnFollow.layer.borderColor = COLOR_Default_Green.CGColor;
    self.btnFollow.layer.borderWidth = 1;
    self.btnPublish.layer.cornerRadius = 3;
    self.btnPublish.layer.masksToBounds = YES;
    [super loadData];
    
    __weak TopicDetailViewController *weakself = self;
    self.provider = [YumiNetworkProvider new];
    [self.provider topicForTid:self.tid];
    self.provider.statusBlock = self.statusBlock;
    [self.provider requestWithSuccess:^(id responseObject) {
        TopicData *data = responseObject;
        weakself.lblTitle.text = data.title;
        weakself.lblContent.text = data.info;
        weakself.lblContent.width = self.view.width - 125;
        [weakself.lblContent sizeToFit];
        double height = weakself.lblContent.height;
        height = fmax(height, 41);
        if (height>41) {
            weakself.viewHeader.height = 247 + height-31;
        }
        weakself.tableView.tableHeaderView = weakself.viewHeader;
        weakself.viewCursor.top = weakself.viewHeader.height-2;
        double cw = weakself.viewCursor.width;
        double vw = weakself.view.width;
        weakself.viewCursor.left = (vw/3-cw)/2;
        
        [weakself.tableView reloadData];
        [weakself.imgIcon setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:data.pic]]];
        weakself.imgIcon.isRounded = YES;
//        weakself.imgIcon.layer.borderColor = [UIColor whiteColor].CGColor;
//        weakself.imgIcon.layer.borderWidth = 2;
        if (data.isfollowed) {
            weakself.btnFollow.selected = YES;
            weakself.btnFollow.backgroundColor = COLOR_Default_Green;
        }else{
            weakself.btnFollow.selected = NO;
            weakself.btnFollow.backgroundColor = [UIColor whiteColor];
        }
        weakself.btnLike.selected = data.islike>0;
        if (data.islike>0) {
            [self.btnLike setTitle:@"1" forState:UIControlStateNormal];
        }
        [weakself loadData];
    } failure:^(NSError *error) {
        weakself.failureBlock(error);
    }];
}
-(void)loadData{
    [super loadData];
    
    __weak TopicDetailViewController *weakself = self;
    self.dataIndex = 0;
    if ([self.sort isEqualToString: @"follower"]) {
        self.followerProvider = [YumiNetworkProvider new];
        self.followerProvider.statusBlock = self.listStatusBlock;
        [self.followerProvider topicFollowersForTid:self.tid];
        [self.followerProvider requestWithSuccess:^(id responseObject) {
            TopicFollowersData *data = responseObject;
            [weakself dataArrayChanged:data.users];
            [weakself.tableView reloadData];
        } failure:^(NSError *error) {
            weakself.failureBlock(error);
        }];
        [self.followerProvider requestData];
    }else{
        self.replyProvider = [YumiNetworkProvider new];
        self.replyProvider.statusBlock = self.listStatusBlock;
        [self.replyProvider topicRepliesForTid:self.tid sort:self.sort];
        [self.replyProvider setCompletionBlockWithSuccess:^(id responseObject) {
            TopicRepliesData *data = responseObject;
            [weakself dataArrayChanged:data.topicReplies];
            [weakself.tableView reloadData];
        } failure:^(NSError *error) {
            weakself.listFailureBlock(error);
        }];
        [self.replyProvider requestData];
    }
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    __weak TopicDetailViewController *weakself = self;
    if ([self.sort isEqualToString: @"follower"]) {
        self.followerProvider = [YumiNetworkProvider new];
        self.followerProvider.statusBlock = self.listStatusBlock;
        [self.followerProvider topicFollowersForTid:self.tid];
        self.followerProvider.statusBlock = self.statusBlock;
        [self.followerProvider requestWithSuccess:^(id responseObject) {
            TopicFollowersData *data = responseObject;
            [weakself dataArrayChanged:data.users];
            [weakself.tableView reloadData];
        } failure:^(NSError *error) {
            weakself.failureBlock(error);
        }];
        [self.followerProvider requestData];
    }else{
        self.replyProvider = [YumiNetworkProvider new];
        self.replyProvider.statusBlock = self.listStatusBlock;
        [self.replyProvider topicRepliesForTid:self.tid sort:self.sort];
        [self.replyProvider setCompletionBlockWithSuccess:^(id responseObject) {
            TopicRepliesData *data = responseObject;
            [weakself dataArrayChanged:data.topicReplies];
            [weakself.tableView reloadData];
        } failure:^(NSError *error) {
            weakself.listFailureBlock(error);
        }];
        [self.replyProvider requestData];
    }
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
    if ([self.sort isEqualToString: @"follower"]) {
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kFriendTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
        }
        User *user = self.dataArray[indexPath.row];
        cell.lblName.text = user.u_name;
        [cell.imgHead setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:user.pic]]];
        return cell;
    }else{
        TopicReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTopicReplyTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kTopicReplyTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
        }
        TopicReply *tp = self.dataArray[indexPath.row];
        cell.lblName.text = tp.u_name;
        [cell.imgHead setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:tp.pic]] placeholderImage:[UIImage imageNamed:IMG_HEAD_DEFAULT]];
        
        [cell.lblContent setTranslatesAutoresizingMaskIntoConstraints:YES];
        
        cell.lblContent.width = self.view.width - 101;
        cell.lblContent.height = 21;
        [cell.lblContent setLineBreakMode:NSLineBreakByCharWrapping];
        cell.lblContent.numberOfLines = 0;
        cell.lblContent.text = tp.text;
        [cell.lblContent sizeToFit];
        
        cell.lblTime.text = [NSString stringWithFormat:@"%@发布", [DateUtils timeConvertToShort:tp.time]];
        cell.lblPosition.text = tp.position;
//        cell.lblPosition.top = cell.lblContent.top+cell.lblContent.height+5;
//        cell.imgPosition.top = cell.lblPosition.top;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.sort isEqualToString: @"follower"]) {
        User *user = self.dataArray[indexPath.row];
        [self routeToName:@"UserProfileViewController" params:@{@"uid":user.uid}];
    }else{
        TopicReply *tp = self.dataArray[indexPath.row];
        [self routeToName:@"TopicReplyViewController" params:@{@"uid":tp.uid,@"trid":tp.trid,@"uname":tp.u_name,@"upic":tp.pic,@"time":@(tp.time),@"content":tp.text,@"position":tp.position}];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForCellWithIndexPath:indexPath];
}
- (CGFloat)heightForCellWithIndexPath:(NSIndexPath *)indexPath {
    if ([self.sort isEqualToString: @"follower"]) {
        return 60;
    }
    TopicReply *tp = self.dataArray[indexPath.row];
    double height = 95;
    NSString *content = tp.text;
    static UILabel* rtLableInstance = nil;
    if (!rtLableInstance) {
        TopicReplyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTopicReplyTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kTopicReplyTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
        }
        UILabel *contentLabel = cell.lblContent;
        contentLabel.font = [UIFont systemFontOfSize:14.0];
        [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [contentLabel setTextAlignment:NSTextAlignmentLeft];
        [contentLabel setNumberOfLines:0];
        rtLableInstance = contentLabel;
    }
    rtLableInstance.width = self.view.width - 101;
    [rtLableInstance setText:content];
    [rtLableInstance sizeToFit];
    CGFloat sizeFitHeight = rtLableInstance.height;
    sizeFitHeight = fmaxf(21, sizeFitHeight);
    if (sizeFitHeight>21) {
        height+=sizeFitHeight-21;
    }
    return height;
}


@end
