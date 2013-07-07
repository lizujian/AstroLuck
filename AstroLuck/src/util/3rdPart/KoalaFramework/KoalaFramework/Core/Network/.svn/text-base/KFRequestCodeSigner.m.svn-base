//
//  KFRequestCodeSigner.m
//  KoalaFramework
//
//  Created by JHorn.Han on 11/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFRequestCodeSigner.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KFRequestCodeSigner);

@implementation KFRequestCodeSigner

SYNTHESIZE_SINGLETON_FOR_CLASS(KFRequestCodeSigner)

- (NSMutableDictionary*) queryStringDictionary:(NSString*)urlstring {
    NSArray *elements = [urlstring componentsSeparatedByString:@"&"];
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity:[elements count]];
    for(NSString *e in elements) {
        NSArray *pair = [e componentsSeparatedByString:@"="];
        [retval setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }
    return retval;
}

- (id)MD5:(NSString*)as
{
    const char *cStr = [as UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


-(NSString*)productToken {
    return @"GeI0rZaPNm1VIGuJeJXF";
}




-(id)requestCodeSignForParamerter:(NSString*)urlpara
                        withToken:(NSString*)prodctToken
                         postData:(NSDictionary*)postdata {
    
    
    
//    NSDictionary* dict = [self queryStringDictionary:urlpara];
//    urlpara = nil;
//    postdata = dict;
    if(urlpara) {
    
        NSMutableString* strparm = [[NSMutableString alloc] initWithString:urlpara];
        NSArray* arrs = [strparm componentsSeparatedByString:@"&"];
        NSMutableArray* arrnew = [[NSMutableArray alloc] initWithArray:arrs];
        [arrnew sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString* o1 = obj1;
            NSString* o2 = obj2;
            return [o1 compare:o2];
        }];
        [strparm release];
        
        NSMutableString* resultString = [[NSMutableString alloc] initWithCapacity:10];
        [arrnew enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [resultString appendString:obj];
        }];
        
        if(prodctToken){
            [resultString appendString:prodctToken];
        }
        [arrnew release];
        
        return [self MD5:[resultString autorelease]];
        
        
    }else if(postdata) {
        
        if(postdata.count == 0) {
            return nil;
        }
//        NSMutableDictionary* mukey = [[NSMutableDictionary alloc] initWithDictionary:postdata];
        
        NSMutableArray* arrnew = [[NSMutableArray alloc] initWithArray:[postdata allKeys]];
        [arrnew sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString* o1 = obj1;
            NSString* o2 = obj2;
            return [o1 compare:o2];
        }];
        
        
        NSMutableString* resultString = [[NSMutableString alloc] initWithCapacity:10];
        [arrnew enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString* akey = [NSString stringWithFormat:@"%@=%@",obj,[postdata objectForKey:obj]];
            [resultString appendString:akey];
        }];
        
        [arrnew release];
        
        if(prodctToken){
            [resultString appendString:prodctToken];
        }
        
        return [self MD5:[resultString autorelease]];
    }
    
    
    return nil;
}
@end
