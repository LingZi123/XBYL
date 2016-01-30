//
//  LoginUserInfo.h
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>

//登录的用户信息
@interface LoginUserInfo : NSObject<NSCoding>

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *pwd;
@property(nonatomic,assign)BOOL isLoginOut;
@property(nonatomic,assign)BOOL isRemeberPwd;

//+(LoginUserInfo *)getModelWithDic:(NSDictionary *)dic;
//+(NSDictionary *)getDicWithModel:(LoginUserInfo *)model;
@end
