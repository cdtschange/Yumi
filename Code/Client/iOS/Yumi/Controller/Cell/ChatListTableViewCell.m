//
//  ChatListTableViewCell.m
//  Yumi
//
//  Created by Mao on 12/30/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "DateUtils.h"
#import "UIView+MGBadgeView.h"

@implementation ChatListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgHead.layer.cornerRadius = 3;
    self.imgHead.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setChats:(Chats *)chats{
    _chats = chats;
    self.imgHead.badgeView.badgeValue = [NSString stringWithFormat:@"%d", chats.badge];
    self.lblTitle.text = chats.title;
    self.lblContent.text = chats.words;
    [self.imgHead setImageWithURL:[NSURL URLWithString:[chats.pic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
    self.lblTime.text = [DateUtils timeConvertToShort:chats.time];
    [self setNeedsLayout];
}

@end
