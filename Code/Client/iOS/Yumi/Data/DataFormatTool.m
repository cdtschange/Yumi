//
//  DataFormatTool.m
//  G2R
//
//  Created by Wei Mao on 8/29/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "DataFormatTool.h"

@implementation DataFormatTool

+(NSString *)timeToDateYYYYMDSlash:(int)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [date stringWithFormat:@"yyyy/M/d"];
}
+(NSString *)timeToDateYYYYMDHMLine:(int)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [date stringWithFormat:@"yyyy-M-d HH:mm"];
}
+(NSString *)timeToDateYYYYMDHMSLine:(int)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [date stringWithFormat:@"yyyy-M-d HH:mm:ss"];
}
@end
