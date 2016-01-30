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
        model.port=[dic objectForKey:@"port"];
        model.webPort=[dic objectForKey:@"webport"];
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
        [dic setObject:model.port forKey:@"port"];
        [dic setObject:model.webPort forKey:@"webport"];
        return dic;
    }
    else{
        return nil;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.ip forKey:@"ip"];
    [aCoder encodeObject:self.port forKey:@"port"];
    [aCoder encodeObject:self.webPort forKey:@"webPort"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.ip=[aDecoder decodeObjectForKey:@"ip"];
        self.port=[aDecoder decodeObjectForKey:@"port"];
        self.webPort=[aDecoder decodeObjectForKey:@"webPort"];
    }
    return self;
}
@end
