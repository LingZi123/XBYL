//
//  PatientStatus.h
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientStatus : NSObject
@property(nonatomic,copy)NSString *patientNo;//病人编号
@property(nonatomic,assign)NSInteger status;//在线状态 0离线，1在线 2删除
+(PatientStatus *)getModelWithString:(NSString *)str;
@end
