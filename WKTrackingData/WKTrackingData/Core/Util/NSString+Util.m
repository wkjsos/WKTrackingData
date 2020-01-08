//
//  NSString+Util.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/3.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "NSString+Util.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Util)

- (NSString *)wk_md5Uppercase{

    const char *original_str = [self UTF8String];
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    #pragma clang diagnostic pop
    
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [outPutStr appendFormat:@"%02X", digist[i]];
    }
    
    return [outPutStr uppercaseString];
}

+ (NSString *)wk_dateFormartyyyy_Month_DD_HH_mm_ss_S {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)wk_currentTimestamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;  // 精确到毫秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    return timeString;
}

@end
