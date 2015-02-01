//
//  TopicReplyTableViewCell.m
//  Yumi
//
//  Created by Mao on 1/6/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "TopicReplyTableViewCell.h"
#import "DateUtils.h"

@implementation TopicReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setReply:(TopicReply *)reply{
    _reply = reply;
    self.lblName.text = reply.u_name;
    [self.imgHead setImageWithURL:[NSURL URLWithString:[reply.pic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
    self.lblContent.text = reply.text;
    self.lblTime.text = [NSString stringWithFormat:@"%@发布", [DateUtils timeConvertToShort:reply.time]];
    self.lblPosition.text = reply.position;
    [self setNeedsLayout];
}
-(void)setReplyComment:(TopicReplyComment *)replyComment{
    _replyComment = replyComment;
    self.lblName.text = replyComment.u_name;
    [self.imgHead setImageWithURL:[NSURL URLWithString:[replyComment.pic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
    self.lblContent.text = replyComment.text;
    self.lblTime.text = [NSString stringWithFormat:@"%@发布", [DateUtils timeConvertToShort:replyComment.time]];
    [self setNeedsLayout];
}

@end
