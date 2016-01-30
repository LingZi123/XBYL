//
//  LoginUserInfo.m
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "LoginUserInfo.h"

@implementation LoginUserInfo
+(LoginUserInfo *)getModelWithDic:(NSDictionary *)dic{
    if (dic) {
        LoginUserInfo *model=[[LoginUserInfo alloc]init];
        model.userName=[dic objectForKey:@"userName"];
        model.pwd=[dic objectForKey:@"pwd"];
        model.isLoginOut=[[dic objectForKey:@"isLoginOut"]boolValue];
        model.isRemeberPwd=[[dic objectForKey:@"isRemeberPwd"]boolValue];
        return model;
    }
    else{
        return nil;
    }
}

+(NSDictionary *)getDicWithModel:(LoginUserInfo *)model{
    if (model) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setObject:model.userName forKey:@"userName"];
        [dic setObject:model.pwd forKey:@"pwd"];
        [dic setObject:[NSNumber numberWithBool:model.isLoginOut] forKey:@"isLoginOut"];
        [dic setObject:[NSNumber numberWithBool:model.isRemeberPwd] forKey:@"isRemeberPwd"];
        return dic;
    }
    else{
        return nil;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.pwd forKey:@"pwd"];
    [aCoder encodeBool:self.isLoginOut forKey:@"isLoginOut"];
    [aCoder encodeBool:self.isRemeberPwd forKey:@"isRemeberPwd"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.userName=[aDecoder decodeObjectForKey:@"userName"];
        self.pwd=[aDecoder decodeObjectForKey:@"pwd"];
        self.isLoginOut=[aDecoder decodeBoolForKey:@"isLoginOut"];
        self.isRemeberPwd=[aDecoder decodeBoolForKey:@"isRemeberPwd"];
    }
    return self;

}
@end
