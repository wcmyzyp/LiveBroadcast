//
//  NetWorkManager.m
//  LiveBroadcast
//
//  Created by WCM on 16/12/16.
//  Copyright © 2016年 WCM. All rights reserved.
//

#import "NetWorkManager.h"
#import <AFNetworking.h>

@implementation NetWorkManager

+(instancetype)sharedManager{
  static NetWorkManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[NetWorkManager alloc] init];
  });
  return manager;
}

+(void)JSONDataWithHomeUrl:(NSString*)homeUrl success:(void(^)(id json))success fail:(void(^)())fail{
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFHTTPRequestSerializer serializer];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain",@"text/json", @"text/javascript", nil];
  [manager GET:homeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    if (success) {
      success(responseObject);
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"error ===== %@",error.description);
    if (fail) {
      fail();
    }
  }];
  
}

@end
