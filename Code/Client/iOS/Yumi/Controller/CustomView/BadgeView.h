//
//  UIBadgeView.h
//  UIBadgeView
//  
//  Copyright (C) 2011 by Omer Duzyol
//  Modify by JunHan on 2013/11/14

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface BadgeView : UIView {
}         

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, copy) NSString *badgeString;
@property (nonatomic, assign) UITableViewCell *parent;
@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, strong) UIColor *badgeColor;
@property (nonatomic, strong) UIColor *badgeColorHighlighted;

- (void)drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context
			  withRadius:(CGFloat) radius;
- (NSInteger) getNumber;

@end
