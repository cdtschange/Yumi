//
//  ChatViewController.m
//  Yumi
//
//  Created by Mao on 12/31/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "FixChatViewController.h"
#import "AudioHelper.h"
#import "Speecher.h"

static NSString *kChatTableViewCellIdentify = @"ChatTableViewCell";
static NSString *kChatRightTableViewCellIdentify = @"ChatRightTableViewCell";
@interface ChatViewController ()<ChatCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (assign, nonatomic) BOOL cando;
@property (assign, nonatomic) BOOL hasLoaded;
@property (assign, nonatomic) int fakecnt;
@property (copy, nonatomic) NSString *selectedContent;
@property (strong, nonatomic) ZBMessage *tempVoiceMessage;

@end

@implementation ChatViewController

-(void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadDataWithCache:(BOOL)cache{
    __weak ChatViewController *weakself = self;
    ChatAPIData *data = [ChatAPIData initWithCid:self.cid];
    data.cachePolicy = cache? NSURLRequestReturnCacheDataElseLoad:NSURLRequestUseProtocolCachePolicy;
    NSURLSessionTask *task = [data requestWithSuccess:^(id responseObject) {
        ChatAPIData *data = responseObject;
        if (weakself==nil) {
            return;
        }
        [weakself performSelector:@selector(loadData) withObject:nil afterDelay:5];
        if (weakself.dataArray.count==data.chats.count+weakself.fakecnt) {
            return;
        }
        NSString *cids = [AccountEntity shared].cids;
        NSString *times = [AccountEntity shared].cidtimes;
        NSMutableArray *cidsarr = [NSMutableArray arrayWithArray: [cids split:@","]];
        NSMutableArray *timesarr = [NSMutableArray arrayWithArray: [times split:@","]];
        BOOL isIn=NO;
        int lasttime = (int)[NSDate date].timeIntervalSince1970;
        for (int i=0; i<cidsarr.count; i++) {
            NSString *cid = cidsarr[i];
            if ([weakself.cid isEqualToString:cid]) {
                timesarr[i] = [NSString stringWithFormat:@"%d", lasttime];
                isIn = YES;
                break;
            }
        }
        if (!isIn) {
            [cidsarr addObject:weakself.cid];
            [timesarr addObject:[NSString stringWithFormat:@"%d", lasttime]];
        }
        cids = [cidsarr componentsJoinedByString:@","];
        times = [timesarr componentsJoinedByString:@","];
        [AccountEntity shared].cids = cids;
        [AccountEntity shared].cidtimes = times;
        
        [weakself dataArrayChanged:data.chats];
        if (data.chats&&data.chats.count>0) {
            Chat *c = data.chats[data.chats.count-1];
            NSDictionary *dict = @{@"cid":weakself.cid,@"text":c.words};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RefreshChatList object:dict];
        }
        [weakself.tableView reloadData];
        weakself.cando = YES;
        if (weakself.dataArray.count > 0)
            [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakself.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } failure:^(NSError *error) {
        if (weakself==nil) {
            return;
        }
        [weakself performSelector:@selector(loadData) withObject:nil afterDelay:5];
        if (weakself.dataArray.count==0) {
            weakself.listFailureBlock(error);
        }
    }];
    if (self.dataArray.count==0) {
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
    self.tableView.height=self.view.height - 45;
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self loadData];
}
- (void) hideKeyboard {
    [self messageViewAnimationWithMessageRect:CGRectZero
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:0.25
                                     andState:ZBMessageViewStateShowNone];
}
-(void)loadData{
    [super loadData];
    self.hasLoaded = YES;
    self.title = self.name;
    self.dataIndex = 0;
    if (self.cid&&self.cid.length>0) {
        if (self.tpic&&self.tpic.length>0) {
            [self.imgBg setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageBigURLWithHead:self.tpic]] placeholderImage:[UIImage imageNamed:@"view_chat_bg_default"]];
        }
        [self reloadDataWithCache:NO];
    }
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    if (self.cid&&self.cid.length>0) {
        [self reloadDataWithCache:NO];
    }
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
    self.navigationItem.rightBarButtonItem=[MyNavigationHelper createNavItemWithType:NavItemTypeProfile target:self action:@selector(click_profile:)];
}
- (void)click_profile:(id)sender{
    [self showInfoTip:@"群聊功能暂未开放，敬请期待"];
//    [self routeToName:@"UserProfileViewController" params:@{@"uid":self.tuid}];
}

- (void)sendMessage:(ZBMessage *)message{
    NSString *text = message.text;
    
    Chat *obj = [Chat new];
    if (message.messageType == ZBBubbleMessageText) {
        obj.type = @"text";
        obj.words = text;
        if (text.length==0) {
            return;
        }
    }else if (message.messageType == ZBBubbleMessageFixedText) {
        obj.type = @"text-m";
        obj.words = text;
        obj.photoImage = message.photo;
    }else if (message.messageType == ZBBubbleMessageTranslateText) {
        obj.type = @"text-t";
        obj.words = text;
        obj.translate = message.detail;
    }else if (message.messageType == ZBBubbleMessageVoice) {
        obj.type = @"voice";
        obj.words = message.voicePath;
        text = @"语音";
    }
    obj.uid = [AccountEntity shared].uid;
    obj.pic = [AccountEntity shared].picsrc;
    obj.u_name = [AccountEntity shared].name;
    obj.time = (int)[NSDate date].timeIntervalSince1970;
    [self.dataArray addObject:obj];
    self.dataIndex++;
    [self.tableView reloadData];
    if (self.dataArray.count > 0)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    if (!self.cid) {
        self.cid=@"";
    }
    NSDictionary *dict = @{@"cid":self.cid,@"text":text};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RefreshChatList object:dict];
    
    if (message.messageType == ZBBubbleMessageFixedText) {
        self.fakecnt++;
        return;
//        __weak ChatViewController *weakself = self;
//        self.uploadPicProvider = [YumiNetworkProvider new];
//        [self.uploadPicProvider uploadPicForImage:message.photo];
//        [self.uploadPicProvider setCompletionBlockWithSuccess:^(id responseObject) {
//            weakself.sendchatProvider = [YumiNetworkProvider new];
//            weakself.sendchatProvider.statusBlock = nil;
//            [weakself.sendchatProvider setCompletionBlockWithSuccess:^(id responseObject) {
//            } failure:^(NSError *error) {
//                weakself.failureBlock(error);
//            }];
//            [weakself.sendchatProvider sendChatForTuid:weakself.tuid cid:weakself.cid words:text type:ChatTypeText];
//            [weakself.sendchatProvider requestData];
//        } failure:^(NSError *error) {
//            weakself.failureBlock(error);
//        }];
//        self.uploadPicProvider.statusBlock = self.statusBlock;
//        [self.uploadPicProvider requestData];
    }else if (message.messageType == ZBBubbleMessageVoice){
        self.fakecnt++;
        return;
    }else if (message.messageType == ZBBubbleMessageTranslateText){
        self.fakecnt++;
        return;
    }else{
        [[SendChatAPIData initWithTuid:self.tuid cid:self.cid words:text type:ChatTypeText] requestWithSuccess:^(id responseObject) {
        } failure:self.failureBlock];
    }
    
}
-(void)updateKeyboardHeight:(double)height{
    if (self.tableView.height==self.view.height - height) {
        return;
    }
    self.tableView.height=self.view.height - height;
    if (self.dataArray.count > 0 && self.cando)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Chat *chat = self.dataArray[indexPath.row];
    ChatBaseTableViewCell *cell;
    if ([chat.uid isEqualToString:[AccountEntity shared].uid]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kChatRightTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kChatTableViewCellIdentify owner:self options:nil] objectAtIndex:1];
            cell.delegate = self;
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:kChatTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kChatTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
            cell.delegate = self;
        }
    }
    cell.chat = chat;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForCellWithIndexPath:indexPath];
}
- (CGFloat)heightForCellWithIndexPath:(NSIndexPath *)indexPath {
    Chat *chat = self.dataArray[indexPath.row];
    return [ChatBaseTableViewCell heightForCellWithChat:chat width:self.view.width];
}

-(void)chatCellLongPress:(ChatBaseTableViewCell *)cell content:(NSString *)content{
    [self hideKeyboard];
    if (content.length==0) {
        return;
    }
    self.selectedContent = content;
    UIMenuItem *it1 = [[UIMenuItem alloc] initWithTitle:@"翻译" action:@selector(handleTranslateCell:)];
    UIMenuItem *it2 = [[UIMenuItem alloc] initWithTitle:@"朗读" action:@selector(handleReadCell:)];
    UIMenuItem *it3 = [[UIMenuItem alloc] initWithTitle:@"生词本" action:@selector(handleBookCell:)];
    UIMenuItem *it4 = [[UIMenuItem alloc] initWithTitle:@"纠错" action:@selector(handleFixCell:)];
    UIMenuItem *it5 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:it1, it2, it3, it4, it5, nil]];
    CGRect frame = cell.frame;
    frame.origin.y+=cell.imgBgWord.frame.origin.y;
    frame.origin.x+=cell.imgBgWord.frame.origin.x;
    frame.size.width = cell.imgBgWord.frame.size.width;
    frame.size.height = cell.imgBgWord.frame.size.height;
    [menu setTargetRect:frame inView:self.tableView];
    [menu setMenuVisible:YES animated:YES];
    
}
-(void)chatCellTapPress:(ChatBaseTableViewCell *)cell content:(NSString *)content{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Chat *chat = self.dataArray[indexPath.row];
    if ([chat.type isEqualToString:@"voice"]) {
        NSString *path = chat.words;
        [[AudioHelper shared] playWithName:path];
    }

}
-(void)handleTranslateCell:(id)sender{
    if (self.selectedContent&&self.selectedContent.length>0) {
        __weak ChatViewController *weakself = self;
        NSURLSessionTask *task = [[TranslateAPIData initWithText:self.selectedContent] requestWithSuccess:^(id responseObject) {
            TranslateAPIData *data = responseObject;
            if (data.result&&data.result.length>0) {
                ZBMessage *msg = [ZBMessage new];
                msg.text = weakself.selectedContent;
                msg.detail = data.result;
                msg.messageType = ZBBubbleMessageTranslateText;
                [weakself sendMessage:msg];
            }else{
                [weakself showInfoTip:@"翻译失败"];
            }
        } failure:self.failureBlock];
        [self setNetworkStateOfTask:task];
    }
}
-(void)handleReadCell:(id)sender{
    [[Speecher shared] speakWithText:self.selectedContent];
}
-(void)handleBookCell:(id)sender{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[AccountEntity shared].myNewWords];
    [arr addObject:self.selectedContent];
    [AccountEntity shared].myNewWords = arr;
    [self showInfoTip:@"已添加到生词本"];
}
-(void)handleFixCell:(id)sender{
    FixChatViewController *vc = [UIViewController instanceByName:@"FixChatViewController"];
    vc.content = self.selectedContent;
    __weak ChatViewController *weakself = self;
    vc.block = ^(BOOL fixed, UIImage* fixedImage){
        [weakself hideKeyboard];
        if (fixed) {
            ZBMessage *msg = [ZBMessage new];
            msg.text = weakself.selectedContent;
            msg.photo = fixedImage;
            msg.messageType = ZBBubbleMessageFixedText;
            [weakself sendMessage:msg];
        }
    };
    UINavigationController *nav = [[[self.navigationController class] alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)handleCopyCell:(id)sender{
    [self showInfoTip:@"复制成功"];
}


#pragma mark - ZBMessageVoiceViewDelegate
- (void)didStartRecordingVoiceAction{
    NSString *name = [NSString stringWithFormat:@"%d", (int)[NSDate date].timeIntervalSince1970];
    [[AudioHelper shared] recordWithName:name];
    self.tempVoiceMessage = [ZBMessage new];
    self.tempVoiceMessage.voicePath = name;
    self.tempVoiceMessage.messageType = ZBBubbleMessageVoice;
    [self showLoadingWithText:@"请说话"];
    
}
-(void)didCancelRecordingVoiceAction{
    [self hideLoading];
    self.tempVoiceMessage = nil;
    [[AudioHelper shared] cancelRecord];
}
-(void)didFinishRecoingVoiceAction{
    [self hideLoading];
    [[AudioHelper shared] stopRecord];
    [self sendMessage:self.tempVoiceMessage];
    self.tempVoiceMessage = nil;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hideToolBar];
}

#pragma end
@end
