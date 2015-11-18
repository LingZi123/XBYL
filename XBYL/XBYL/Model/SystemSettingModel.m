//
//  SystemSettingModel.m
//  XBYL
//
//  Created by 罗娇 on 15/8/22.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "SystemSettingModel.h"

@implementation SystemSettingModel
+(SystemSettingModel *)getModelWithDic:(NSDictionary *)dic
{
    if (dic) {
        SystemSettingModel *model=[[SystemSettingModel alloc]init];
        model.ip=[dic objectForKey:@"ip"];
        model.port=[[dic objectForKey:@"port"] intValue];
        model.webPort=[[dic objectForKey:@"webport"]intValue];
        return model;
    }
    else{
        return nil;
    }
}
+(NSDictionary *)getDicWithModel:(SystemSettingModel *)model{
    if (model) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setObject:model.ip forKey:@"ip"];
        [dic setObject:[NSNumber numberWithInt:model.port] forKey:@"port"];
        [dic setObject:[NSNumber numberWithInt:model.webPort] forKey:@"webport"];
        return dic;
    }
    else{
        return nil;
    }
}
@end
