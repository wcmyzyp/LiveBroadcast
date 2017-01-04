//
//  HotModel.h
//  LiveBroadcast
//
//  Created by WCM on 16/12/16.
//  Copyright © 2016年 WCM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreatorModel.h"

@interface HotModel : NSObject

@property (nonatomic, strong) CreatorModel *creator;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *online_users;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *stream_addr;
@property (nonatomic, strong) NSString *portrait;

@end
