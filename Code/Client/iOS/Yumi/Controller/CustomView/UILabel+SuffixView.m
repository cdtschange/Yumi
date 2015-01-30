//
//  UILabel+SuffixView.m
//  Demo
//
//  Created by Tozy on 13-7-19.
//  Copyright (c) 2013年 TozyZuo. All rights reserved.
//

#import "UILabel+SuffixView.h"
#import <objc/runtime.h>

static const void *SuffixViewKey = "SuffixViewKey";
static const void *MaxLabelWidthKey = "MaxLabelWidthKey";
static const void *SuffixSpaceKey = "SuffixSpaceKey";

@implementation UILabel (SuffixView)
@dynamic suffixView;
@dynamic maxLabelWidth;
@dynamic suffixSpace;

- (UIView *)suffixView
{
    return objc_getAssociatedObject(self, SuffixViewKey);
}

- (void)setSuffixView:(UIView *)suffixView
{
    objc_setAssociatedObject(self, SuffixViewKey, suffixView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sizeToIcon];
}

- (CGFloat)maxLabelWidth
{
    return [objc_getAssociatedObject(self, MaxLabelWidthKey) floatValue];
}
- (void)setMaxLabelWidth:(CGFloat)maxLabelWidth
{
    objc_setAssociatedObject(self, MaxLabelWidthKey, @(maxLabelWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sizeToIcon];
}


- (CGFloat)suffixSpace
{
    return [objc_getAssociatedObject(self, SuffixSpaceKey) floatValue];
}
-(void)setSuffixSpace:(CGFloat)suffixSpace{
    objc_setAssociatedObject(self, SuffixSpaceKey, @(suffixSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sizeToIcon];
}

- (void)sizeToIcon
{
    if (self.maxLabelWidth==0) {
        self.maxLabelWidth = 320;
    }
    // 限制最大宽度
    [self sizeToFit];
    CGRect frame;
    if (self.frame.size.width > self.maxLabelWidth) {
        frame = self.frame;
        frame.size.width = self.maxLabelWidth;
        self.frame = frame;
    }

    // 修正suffixView的位置
    if (self.suffixView) {
        frame = self.suffixView.frame;
        frame.origin.x = self.frame.size.width + self.suffixSpace;
        self.suffixView.frame = frame;
        self.suffixView.center = CGPointMake(self.suffixView.center.x, self.frame.size.height * .5);
        [self addSubview:self.suffixView];
        self.clipsToBounds = NO;
        self.numberOfLines = 1;
    }
}

@end
