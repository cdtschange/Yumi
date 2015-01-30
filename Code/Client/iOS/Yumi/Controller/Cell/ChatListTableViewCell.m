//
//  ChatListTableViewCell.m
//  Yumi
//
//  Created by Mao on 12/30/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "ChatListTableViewCell.h"

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

@end
