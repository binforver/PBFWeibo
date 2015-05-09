//
//  IWStatusTool.m
//  ItcastWeibo
//
//  Created by apple on 14-5-20.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWStatusTool.h"
#import "IWHttpTool.h"
#import "MJExtension.h"

@implementation IWStatusTool
+ (void)homeStatusesWithParam:(IWHomeStatusesParam *)param success:(void (^)(IWHomeStatusesResult *))success failure:(void (^)(NSError *))failure
{
    [IWHttpTool getWithURL:@"https://api.weibo.com/2/statuses/home_timeline.json" params:param.keyValues success:^(id json) {
        if (success) {
            IWHomeStatusesResult *result = [IWHomeStatusesResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)sendStatusWithParam:(IWSendStatusParam *)param success:(void (^)(IWSendStatusResult *))success failure:(void (^)(NSError *))failure
{
    [IWHttpTool postWithURL:@"https://api.weibo.com/2/statuses/update.json" params:param.keyValues success:^(id json) {
        if (success) {
            IWSendStatusResult *result = [IWSendStatusResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
