//
//  NetWorkManager.h
//  LiveBroadcast
//
//  Created by WCM on 16/12/16.
//  Copyright © 2016年 WCM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkManager : NSObject

+(instancetype)sharedManager;

//封装get请求
+(void)JSONDataWithHomeUrl:(NSString*)homeUrl success:(void(^)(id json))success fail:(void(^)())fail;

@end
