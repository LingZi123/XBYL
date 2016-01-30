//
//  PersonSettingModel.h
//  XBYL
//
//  Created by 罗娇 on 16/1/29.
//  Copyright (c) 2016年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonSettingModel : NSManagedObject

@property (nonatomic, retain) NSString * huxidownvalue;
@property (nonatomic, retain) NSString * huxiupvalue;
@property (nonatomic, retain) NSString * mailvdownvalue;
@property (nonatomic, retain) NSString * mailvupvalue;
@property (nonatomic, retain) NSString * patientNo;
@property (nonatomic, retain) NSString * shousuoyadownvalue;
@property (nonatomic, retain) NSString * shousuoyaupvalue;
@property (nonatomic, retain) NSString * shuzhangyadownvalue;
@property (nonatomic, retain) NSString * shuzhangyaupvalue;
@property (nonatomic, retain) NSString * xinlvdownvalue;
@property (nonatomic, retain) NSString * xinlvupvalue;
@property (nonatomic, retain) NSString * xueyangdownvalue;
@property (nonatomic, retain) NSString * xueyangupvalue;

@end
