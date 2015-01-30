//
//  EmptyDefaultView.m
//  WandaKTV
//
//  Created by Wei Mao on 4/17/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "EmptyDefaultView.h"
#import "GlobalConfig.h"

@implementation EmptyDefaultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imgvLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
        self.imgvLogo.image = [UIImage imageNamed:ICON_EMPTYVIEW_LOGO];
        self.imgvLogo.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imgvLogo];
        self.lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 20)];
        self.lblDescription.center = CGPointMake(160, 130);
        self.lblDescription.textAlignment = NSTextAlignmentCenter;
        self.lblDescription.textColor = COLOR_Default_LightGray;
        self.lblDescription.font = [UIFont systemFontOfSize:15];
        self.lblDescription.backgroundColor = [UIColor clearColor];
        self.lblDescription.numberOfLines = 2;
        [self addSubview:self.lblDescription];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}
-(void)dealloc{
    self.imgvLogo = nil;
    self.lblDescription = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
