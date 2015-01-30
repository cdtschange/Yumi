//
//  NearUserViewController.m
//  Yumi
//
//  Created by Mao on 1/13/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "NearUserViewController.h"
#import "FriendTableViewCell.h"
#import "UILabel+SuffixView.h"

static NSString *kNearUserTableViewCellIdentify = @"NearUserTableViewCell";

@interface NearUserViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) YumiNetworkProvider *provider;
@property (strong, nonatomic) NSArray *purposeArray;
@property (assign, nonatomic) BOOL isloaded;

@end

@implementation NearUserViewController

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
    if (![AccountEntity shared].isLogin) {
        [self routeToName:@"LoginViewController" params:nil pop:YES];
        return;
    }else{
        if (!self.isloaded) {
            [self loadData];
        }
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
    self.title = @"附近的人";
    
    self.purposeArray = @[@"想找个人练口语",@"想找个有缘人",@"想提升外语水平",@"想和同学一起学习"];
    
    __weak NearUserViewController *weakself = self;
    self.provider = [YumiNetworkProvider new];
    [self.provider setCompletionBlockWithSuccess:^(id responseObject) {
        NearUserData *data = responseObject;
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
    if (![AccountEntity shared].isLogin) {
        self.isloaded = NO;
        return;
    }
    self.isloaded= YES;
    self.dataIndex = 0;
    [self.provider nearUserForLon:0 lat:0];
    [self.provider requestData];
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    [self.provider nearUserForLon:0 lat:0];
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
    NearUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNearUserTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendTableViewCell" owner:self options:nil] objectAtIndex:2];
    }
    User *user = self.dataArray[indexPath.row];
    cell.lblName.text = user.u_name;
    [cell.imgHead setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:user.pic]] placeholderImage:[UIImage imageNamed:IMG_HEAD_DEFAULT]];
    cell.lblPosition.text = user.school;
    BOOL isFemale = [user.sex isEqualToString:@"0"];
    cell.imgGender.image = [UIImage imageNamed:isFemale?@"icon_female":@"icon_male"];
    [cell.lblName setTranslatesAutoresizingMaskIntoConstraints:YES];
    [cell.lblName sizeToFit];
    cell.lblName.height = 21;
//    cell.lblName.suffixView = cell.imgGender;
    int i = arc4random() % 2;
    cell.lblLevel2.hidden = i>0;
    i = arc4random() % 4;
    cell.lblPurpose.text = self.purposeArray[i];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *user = self.dataArray[indexPath.row];
        [self routeToName:@"UserProfileViewController" params:@{@"uid":user.uid}];
}


@end
