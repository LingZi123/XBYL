//
//  XueyaModel.h
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XueyaModel : NSObject
@property(nonatomic,copy)NSString *patientNo;//病人编号
@property(nonatomic,copy)NSString *shousuoya;//收缩压
@property(nonatomic,copy)NSString *DBP;//舒张压
@property(nonatomic,copy)NSString *mailv;//脉率
@property(nonatomic,copy)NSString *addTime;//采集时间

@property(nonatomic,copy)NSString *statusStr;//血压终端状态
@property(nonatomic,copy)NSString *resultStr;//测量结果

+(XueyaModel *)getModelWithString:(NSString *)str;

+(XueyaModel *)getModelWithStringByTest:(NSString *)str;//远程测量
@end
