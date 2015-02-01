//
//  FriendTableViewCell.h
//  Yumi
//
//  Created by Mao on 12/31/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewFriendTableViewCell;

@protocol NewFriendTableViewCellDelegate <NSObject>

-(void)cell_clickAddForCell:(NewFriendTableViewCell *)cell sender:(id)sender;

@end

@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end

@interface NewFriendTableViewCell : UITableViewCell
@property (nonatomic,assign) id <NewFriendTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic, strong) User *user;

@end


@interface NearUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel2;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblPurpose;

@property (nonatomic, strong) User *user;

@end
