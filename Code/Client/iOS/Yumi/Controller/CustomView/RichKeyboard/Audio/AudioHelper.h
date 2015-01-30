//
//  AudioHelper.h
//  Yumi
//
//  Created by Mao on 15/1/25.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioHelper : NSObject
@property (nonatomic, copy)     NSString    *path;

+ (AudioHelper *)shared;

-(BOOL)recordWithName:(NSString *)name;
-(void)cancelRecord;
-(void)stopRecord;
-(void)playWithName:(NSString *)name;
-(void)stopPlay;

@end
