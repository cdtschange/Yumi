//
//  ChatListTableViewCell.h
//  Yumi
//
//  Created by Mao on 12/30/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@property (nonatomic, strong) Chats *chats;

@end
