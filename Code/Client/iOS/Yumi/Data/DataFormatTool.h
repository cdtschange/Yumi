//
//  DataFormatTool.h
//  G2R
//
//  Created by Wei Mao on 8/29/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFormatTool : NSObject

+(NSString *)timeToDateYYYYMDSlash:(int)time;
+(NSString *)timeToDateYYYYMDHMLine:(int)time;
+(NSString *)timeToDateYYYYMDHMSLine:(int)time;
@end
