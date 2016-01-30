//
//  PatientInfoModel.h
//  XBYL
//
//  Created by 罗娇 on 16/1/29.
//  Copyright (c) 2016年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PatientInfoModel : NSManagedObject

@property (nonatomic, retain) NSDate * addDate;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * baseXueyaCheckDate;
@property (nonatomic, retain) NSString * bingchuangNo;
@property (nonatomic, retain) NSString * chubuZZ;
@property (nonatomic, retain) NSString * doctorName;
@property (nonatomic, retain) NSString * hosNo;
@property (nonatomic, retain) NSString * idCard;
@property (nonatomic, retain) NSString * isImportPatient;
@property (nonatomic, retain) NSNumber * isShow;
@property (nonatomic, retain) NSString * jianhuLel;
@property (nonatomic, retain) NSString * job;
@property (nonatomic, retain) NSString * keshi;
@property (nonatomic, retain) NSString * menzhenNo;
@property (nonatomic, retain) NSString * patientAge;
@property (nonatomic, retain) NSString * patientName;
@property (nonatomic, retain) NSString * patientNo;
@property (nonatomic, retain) NSString * patientSex;
@property (nonatomic, retain) NSString * patientTall;
@property (nonatomic, retain) NSString * patientWeight;
@property (nonatomic, retain) NSString * phoneNo;
@property (nonatomic, retain) NSString * subTermType;
@property (nonatomic, retain) NSString * telNo;
@property (nonatomic, retain) NSString * terminNo;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) NSString * youbianNo;
@property (nonatomic, retain) NSString * zhuyuanNo;

@end
