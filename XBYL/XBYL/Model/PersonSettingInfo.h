//
//  PersonSettingInfo.h
//  XBYL
//
//  Created by 罗娇 on 15/8/27.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonSettingInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString * shuzhangyaupvalue;
@property (nonatomic, copy) NSString * huxidownvalue;
@property (nonatomic, copy) NSString * xueyangdownvalue;
@property (nonatomic, copy) NSString * xueyangupvalue;
@property (nonatomic, copy) NSString * shousuoyadownvalue;
@property (nonatomic, copy) NSString * shuzhangyadownvalue;
@property (nonatomic, copy) NSString * shousuoyaupvalue;
@property (nonatomic, copy) NSString * huxiupvalue;
@property (nonatomic, copy) NSString * xinlvdownvalue;
@property (nonatomic, copy) NSString * xinlvupvalue;
@property (nonatomic, copy) NSString * mailvdownvalue;
@property (nonatomic, copy) NSString * mailvupvalue;
@property (nonatomic, copy) NSString * patientNo;

+(PersonSettingInfo *)getModelWithPatientNo:(NSString *)patientNo;//从数据库获取所有的保存的数据，可以显示的
+(BOOL)updateModelWithModel:(PersonSettingInfo *)info;//修改数据
+(BOOL)InsertModelWithModel:(PersonSettingInfo *)info;//添加数据
+(BOOL)deleteModelWithPatientNo:(NSString *)patientNo;//删除数据
+(BOOL)updateAllModelWithDic:(PersonSettingInfo *)dic;//获取所有数据都修改
+(void)clearModels;
@end
