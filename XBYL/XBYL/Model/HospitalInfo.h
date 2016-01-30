//
//  HospitalInfo.h
//  XBYL
//
//  Created by 罗娇 on 15/8/26.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HospitalInfo : NSObject

@property(nonatomic,copy)NSString *hosNo;//医院编号
@property(nonatomic,copy)NSString *hosName;//医院名称
@property(nonatomic,copy)NSString *hosRight;//医院权限


@property (nonatomic, strong) NSArray *patients;//相关病人
@property (nonatomic, assign, getter = isOpened) BOOL opened;//是否展开

+(NSMutableArray *)getAllModelFromCore;//从数据库获取所有的保存的数据，可以显示的
+(BOOL)updateModelWithModel:(HospitalInfo *)info;//修改数据
+(BOOL)InsertModelWithModel:(HospitalInfo *)info;//添加数据
+(BOOL)deleteModelWithModel:(NSString *)hosNo;//删除数据
+(BOOL)existModelWithHosno:(NSString *)hosno;

+(NSMutableArray *)getHosWithMsg:(NSString *)msg;

+(void)clearModels;
@end
