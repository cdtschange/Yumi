//
//  FixChatViewController.h
//  Yumi
//
//  Created by Mao on 1/16/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "BaseViewController.h"
#import "RichTextEditor.h"

typedef void (^FixChatCompleteBlock)(BOOL fixed, UIImage* fixedImage);

@interface FixChatViewController : BaseViewController<RichTextEditorDataSource>

@property (copy, nonatomic) FixChatCompleteBlock block;
@property (copy, nonatomic) NSString *content;

@end
