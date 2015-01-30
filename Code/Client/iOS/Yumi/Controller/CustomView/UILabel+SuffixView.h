//
//  UILabel+SuffixView.h
//  Demo
//
//  Created by Tozy on 13-7-19.
//  Copyright (c) 2013年 TozyZuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SuffixView)

@property (nonatomic, strong) UIView *suffixView;
@property (nonatomic, assign) CGFloat maxLabelWidth;             // 默认为0;
@property (nonatomic, assign) CGFloat suffixSpace;          // // suffixView与Label的间距，默认为2;

- (void)sizeToIcon;

@end
