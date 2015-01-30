//
//  FindTableViewCell.m
//  Yumi
//
//  Created by Mao on 1/6/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "FindTableViewCell.h"

@implementation FindTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(200, 16, 21, 21)];
    self.badgeView.badgeColor = RGBCOLOR(255, 0, 23);
    [self addSubview:self.badgeView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
