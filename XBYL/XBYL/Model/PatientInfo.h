//
//  PatientInfo.h
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MulDataModel.h"
#import "XueyaModel.h"
#import "PatientStatus.h"
#import "PatientInfoModel.h"
#import "PersonSettingInfo.h"

@interface PatientInfo : NSObject
@property(nonatomic,copy)NSString *patientNo;//病人编号
@property(nonatomic,copy)NSString *terminNo;//终端编号
@property(nonatomic,copy)NSString *phoneNo;//手机号码
@property(nonatomic,copy)NSString *hosNo;//医院编号
@property(nonatomic,copy)NSString *patientName;//病人姓名
@property(nonatomic,copy)NSString *doctorName;//医生姓名
@property(nonatomic,copy)NSString *patientSex;//病人性别
@property(nonatomic,copy)NSString *patientAge;//病人年龄
@property(nonatomic,copy)NSString *IDCard;//IDCARD
@property(nonatomic,copy)NSString *address;//地址
@property(nonatomic,copy)NSString *youbianNo;//邮编号码
@property(nonatomic,copy)NSString *job;//job
@property(nonatomic,copy)NSString *telNo;//电话号
@property(nonatomic,copy)NSString *jianhuLel;//监护等级
@property(nonatomic,copy)NSString *chubuZZ;//初步症状
@property(nonatomic,copy)NSString *zhuyuanNo;//住院号
@property(nonatomic,copy)NSString *bingchuangNo;//病床号
@property(nonatomic,copy)NSString *keshi;//科室
@property(nonatomic,copy)NSString *isImportPatient;//是否是重要病员
@property(nonatomic,copy)NSDate *addDate;//增加日期
@property(nonatomic,copy)NSString *patientTall;//身高
@property(nonatomic,copy)NSString *patientWeight;//体重
@property(nonatomic,retain)XueyaModel *xueya;
@property(nonatomic,copy)NSString *menzhenNo;//门诊号
@property(nonatomic,copy)NSString *subTermType;//终端子类型
@property(nonatomic,copy)NSString *baseXueyaCheckDate;//基础血压测量时间
@property(nonatomic,retain)PatientStatus *status;
@property(nonatomic,assign)BOOL isShown;//是否显示

@property(nonatomic,assign)BOOL isRefash;//是否需要刷新

@property(nonatomic,retain)PersonSettingInfo *personSetting;//个人设置


@property(nonatomic,retain)MulDataModel *mulData;//多参数


//2137391508220002|2416419283|1064828640772|213739|曹益花||女|49|||||||普通|||34|||2015-08-22 11:13:41|0.0|0|0|0||91|2015-08-22 

+(PatientInfo *)getModelWithString:(NSString *)str;

+(NSMutableArray *)getAllModel;//获取所有数据
+(NSMutableArray *)getAllModelWithIshow:(BOOL)isShow;//从数据库获取所有的保存的数据，可以显示的
+(NSMutableArray *)getAllModelWithHosno:(NSString *)hosNo;//从数据库获取所有的保存的数据，可以显示的
+(BOOL)updateModelWithModel:(PatientInfo *)info;//修改数据
+(BOOL)InsertModelWithModel:(PatientInfo *)info;//添加数据
+(BOOL)deleteModelWithPatientNo:(NSString *)patientNo;//删除数据
+(PatientInfo *)getModelWithDBModel:(PatientInfoModel *)item;
+(void)clearModels;

@end
