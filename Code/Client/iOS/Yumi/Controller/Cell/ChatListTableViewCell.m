//
//  ChatListTableViewCell.m
//  Yumi
//
//  Created by Mao on 12/30/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "DateUtils.h"

@implementation ChatListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgHead.layer.cornerRadius = 3;
    self.imgHead.layer.masksToBounds = YES;
    self.badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(48, 2, 28, 20)];
    self.badgeView.badgeColor = RGBCOLOR(255, 0, 23);
    [self addSubview:self.badgeView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setChats:(Chats *)chats{
    _chats = chats;
    self.badgeView.hidden = chats.badge==0;
    self.badgeView.badgeString = [NSString stringWithFormat:@"%d", chats.badge];
    self.lblTitle.text = chats.title;
    self.lblContent.text = chats.words;
    [self.imgHead setImageWithURL:[NSURL URLWithString:[chats.pic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
    self.lblTime.text = [DateUtils timeConvertToShort:chats.time];
    [self setNeedsLayout];
}

@end
