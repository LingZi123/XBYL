//
//  SystemSettingModel.h
//  XBYL
//
//  Created by 罗娇 on 15/8/22.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSettingModel : NSObject<NSCoding>
@property(nonatomic,copy)NSString *ip;
@property(nonatomic,copy)NSString  *port;
@property(nonatomic,copy)NSString *webPort;

//+(SystemSettingModel *)getModelWithDic:(NSDictionary *)dic;
//+(NSDictionary *)getDicWithModel:(SystemSettingModel *)model;
@end
