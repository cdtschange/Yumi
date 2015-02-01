//
//  Topic2TableViewCell.m
//  Yumi
//
//  Created by Mao on 15/1/18.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import "TopicTableViewCell.h"

@implementation TopicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTopic:(Topic *)topic{
    _topic = topic;
    self.lblTitle.text = topic.title;
    [self.imgPic setImageWithURL:[NSURL URLWithString:[topic.images imageSmall]]];
    NSString *visitstr = [NSString stringWithFormat:@"%d人浏览",topic.visits];
    NSString *commentstr = [NSString stringWithFormat:@"%d人跟帖",topic.comments];
    [self.lblVisitCnt setText:visitstr afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
        NSRange strRange = [visitstr rangeOfString:@"人"];
        strRange.length = strRange.location;
        strRange.location = 0;
        if (strRange.location != NSNotFound) {
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RGBCOLOR(0, 149, 134).CGColor range:strRange];
        }
        return mutableAttributedString;
    }];
    [self.lblCommentCnt setText:commentstr afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
        NSRange strRange = [commentstr rangeOfString:@"人"];
        strRange.length = strRange.location;
        strRange.location = 0;
        if (strRange.location != NSNotFound) {
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RGBCOLOR(0, 149, 134).CGColor range:strRange];
        }
        return mutableAttributedString;
    }];
    [self setNeedsLayout];
}
@end
