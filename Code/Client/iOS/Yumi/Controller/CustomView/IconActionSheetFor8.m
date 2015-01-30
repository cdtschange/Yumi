//
//  AWActionSheet.m
//  AWIconSheet
//
//  Created by Narcissus on 10/26/12.
//  Copyright (c) 2012 Narcissus. All rights reserved.
//

#import "IconActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#define itemPerRow 4
#define topPadding 50
#define cellWidth 74
#define cellHeight 96

@interface IconActionSheetFor8()<UIScrollViewDelegate>
@property (nonatomic, strong)UIView* contentView;
@property (nonatomic, strong)NSMutableArray* items;
@property (nonatomic, assign)id<IconActionSheetDelegate> delegate;
@end
@implementation IconActionSheetFor8
@synthesize contentView;
@synthesize items;
-(void)dealloc
{
    self.delegate= nil;
}


-(id)initWithDelegate:(id<IconActionSheetDelegate>)delegate title:(NSString *)title itemCount:(int)count
{
    int colCount = ceil(1.0*count/itemPerRow);
    NSString* titleBlank = [NSString stringWithFormat:@"%@\n\n\n\n\n\n\n",title];
    if (title.length == 0) {
        titleBlank = [NSString stringWithFormat:@"\n\n\n\n\n\n"];
    }
    else {
    }
    for (int i = 1 ; i<colCount; i++) {
        titleBlank = [NSString stringWithFormat:@"%@%@",titleBlank,@"\n\n\n\n\n\n"];
    }
    self = [super initWithTitle:titleBlank
                       delegate:delegate
              cancelButtonTitle:@"取消"
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
   
    if (self) {
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, cellHeight*colCount+topPadding)];
        if (title.length == 0) {
            self.contentView.bounds = CGRectMake(-(320-cellWidth*itemPerRow)/2, -topPadding + 30, cellWidth*itemPerRow, self.contentView.frame.size.height-topPadding);
        }
        else {
            self.contentView.bounds = CGRectMake(-(320-cellWidth*itemPerRow)/2, -topPadding, cellWidth*itemPerRow, self.contentView.frame.size.height-topPadding);
        }
        [contentView setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:contentView];
        self.items = [[NSMutableArray alloc] initWithCapacity:count];
        
    }
    return self;
}

-(void)showInView:(UIView *)view
{
    [super showInView:view];
    [self reloadData];
}

- (void)reloadData
{
    for (IconActionSheetCell* cell in items) {
        [cell removeFromSuperview];
        [items removeObject:cell];
    }
    int count = [self.delegate numberOfItemsInActionSheet];
    if (count <= 0) {
        return;
    }
    int rowCount = itemPerRow;
    int colCount = ceil(1.0*count/itemPerRow);
    [contentView setFrame:CGRectMake(0, 0, 320, cellHeight*colCount+topPadding)];
    
    
    for (int i = 0; i< count; i++) {
        IconActionSheetCell* cell = [self.delegate cellForActionAtIndex:i];
        int index  = i;
        
        int row = index/rowCount;
        int column = index%rowCount;
        float x = column*cellWidth;
        float y = row*cellHeight;
        [cell setFrame:CGRectMake(x, y, cellWidth, cellHeight)];
        [self.contentView addSubview:cell];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForItem:)];
        [cell addGestureRecognizer:tap];
        [items addObject:cell];
    }
    
}

- (void)actionForItem:(UITapGestureRecognizer*)recongizer
{
    IconActionSheetCell* cell = (IconActionSheetCell*)[recongizer view];
    [self.delegate didTapOnItemAtIndex:cell.index];
    [self dismissWithClickedButtonIndex:0 animated:YES];
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

#pragma mark - AWActionSheetCell
@interface IconActionSheetCellFor8 ()
@end
@implementation IconActionSheetCellFor8
@synthesize iconView;
@synthesize titleLabel;

- (void)dealloc
{
}

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0, 60, 60)];
        [iconView setBackgroundColor:[UIColor clearColor]];
        [[iconView layer] setCornerRadius:8.0f];
        [[iconView layer] setMasksToBounds:YES];
        
        [self addSubview:iconView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, cellWidth, 20)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            [titleLabel setTextColor:[UIColor darkGrayColor]];
        }else{
            [titleLabel setTextColor:[UIColor whiteColor]];
        }
        [titleLabel setText:@""];
        [self addSubview:titleLabel];
    }
    return self;
}

@end


