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

-(void)reloadDataWithCache:(BOOL)cache{
    __weak TopicDetailViewController *weakself = self;
    if ([self.sort isEqualToString: @"follower"]) {
        TopicFollowersAPIData *data = [TopicFollowersAPIData initWithTid:self.tid];
        data.cachePolicy = cache? NSURLRequestReturnCacheDataElseLoad:NSURLRequestUseProtocolCachePolicy;
        NSURLSessionTask *task = [data requestWithSuccess:^(id responseObject) {
            TopicFollowersAPIData *data = responseObject;
            [weakself dataArrayChanged:data.users];
            [weakself.tableView reloadData];
        } failure:self.listFailureBlock];
        [self setListNetworkStateOfTask:task];
    }else{
        TopicRepliesAPIData *data = [TopicRepliesAPIData initWithTid:self.tid sort:self.sort];
        data.cachePolicy = cache? NSURLRequestReturnCacheDataElseLoad:NSURLRequestUseProtocolCachePolicy;
        NSURLSessionTask *task = [data requestWithSuccess:^(id responseObject) {
            TopicRepliesAPIData *data = responseObject;
            [weakself dataArrayChanged:data.topicReplies];
            [weakself.tableView reloadData];
        } failure:self.listFailureBlock];
        [self setListNetworkStateOfTask:task];
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
    self.title = @"话题详情";
    self.sort = @"time";
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self.viewHeader setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.viewCursor setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    self.btnFollow.layer.cornerRadius = 3;
    self.btnFollow.layer.masksToBounds = YES;
    self.btnFollow.layer.borderColor = COLOR_Default_Green.CGColor;
    self.btnFollow.layer.borderWidth = 1;
    self.btnPublish.layer.cornerRadius = 3;
    self.btnPublish.layer.masksToBounds = YES;
    [self loadData];
}
-(void)loadData{
    [super loadData];
    
    __weak TopicDetailViewController *weakself = self;
    NSURLSessionTask *task = [[TopicAPIData initWithTid:self.tid] requestWithSuccess:^(id responseObject) {
        TopicAPIData *data = responseObject;
        weakself.lblTitle.text = data.title;
        weakself.lblContent.text = data.info;
        CGRect rectToFit = [weakself.lblContent.text boundingRectWithSize:CGSizeMake(weakself.lblContent.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
        double height = rectToFit.size.height;
        weakself.viewHeader.height = 237 - 17 + height;
        weakself.tableView.tableHeaderView = weakself.viewHeader;
        weakself.viewCursor.top = weakself.viewHeader.height-2;
        double cw = weakself.viewCursor.width;
        double vw = weakself.view.width;
        weakself.viewCursor.left = (vw/3-cw)/2;
        
        [weakself.tableView reloadData];
        [weakself.imgIcon setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallWithUrl:data.pic]]];
        weakself.imgIcon.isRounded = YES;
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
    } failure:self.failureBlock];
    [weakself setNetworkStateOfTask:task];
    
    self.dataIndex = 0;
    [self reloadDataWithCache:YES];
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    [self reloadDataWithCache:!isRefresh];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
}

- (IBAction)click_follow:(id)sender {
    __weak TopicDetailViewController *weakself = self;
    NSURLSessionTask *task = [[OperateTopicAPIData initWithTid:self.tid action:self.btnFollow.selected?@"unfollow":@"follow"] requestWithSuccess:^(id responseObject) {
        weakself.btnFollow.selected = !weakself.btnFollow.selected;
        if (weakself.btnFollow.selected) {
            weakself.btnFollow.backgroundColor = COLOR_Default_Green;
        }else{
            weakself.btnFollow.backgroundColor = [UIColor whiteColor];
        }
    } failure:self.failureBlock];
    [self setNetworkStateOfTask:task];
}
- (IBAction)click_reply:(id)sender {
    __weak TopicDetailViewController *weakself = self;
    CommentViewController *vc = [UIViewController instanceByName:@"CommentViewController"];
    vc.block = ^(BOOL select, NSString *content) {
        if (select&&content.length>0) {
            NSURLSessionTask *task = [[ReplyTopicAPIData initWithTid:self.tid content:content] requestWithSuccess:^(id responseObject) {
                [weakself reloadDataWithCache:NO];
            } failure:self.failureBlock];
            [self setNetworkStateOfTask:task];
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
    [self reloadDataWithCache:YES];
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
    [self reloadDataWithCache:YES];
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
    [self reloadDataWithCache:YES];
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
        [cell.imgHead setImageWithURL:[NSURL URLWithString:[user.pic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
        return cell;
    }else{
        TopicReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTopicReplyTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kTopicReplyTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
        }
        TopicReply *tp = self.dataArray[indexPath.row];
        cell.reply = tp;
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
    CGRect rectToFit = [tp.text boundingRectWithSize:CGSizeMake(self.view.width-109, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    double height = rectToFit.size.height;
    return 92-17+height;
}


@end
