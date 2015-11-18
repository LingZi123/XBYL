//
//  SystemSettingModel.h
//  XBYL
//
//  Created by 罗娇 on 15/8/22.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSettingModel : NSObject
@property(nonatomic,copy)NSString *ip;
@property(nonatomic,assign)int port;
@property(nonatomic,assign)int webPort;

+(SystemSettingModel *)getModelWithDic:(NSDictionary *)dic;
+(NSDictionary *)getDicWithModel:(SystemSettingModel *)model;
@end
