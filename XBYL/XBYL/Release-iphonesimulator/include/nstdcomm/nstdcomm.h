//
//  nstdcomm.h
//  nstdcomm
//
//  Created by NEWSTD on 15/8/4.
//  Copyright (c) 2015年 NEWSTD. All rights reserved.
//
#ifndef _STANDRD_NSTDMM2_H_
#define _STANDRD_NSTDMM2_H_
#import <Foundation/Foundation.h>
@class nstdcomm;

typedef void (^callbackCmd)(NSString* cmd);

@interface nstdcomm : NSObject{
@public
    
}

@property (nonatomic,copy) callbackCmd LoginACK;
@property (nonatomic,copy) callbackCmd HoslistACK;

+(int)stdcommConnect:(NSString *)ip andPort:(int)port andWebPort:(int) webport andTermPort:(int)tport andLoginType:(int) type;

+(int)stdcommLogin:(NSString*)user andPwd:(NSString*)pwd;

+(int)stdcommRefreshHosList;

+(int)stdcommRefreshPatList;

+(int)stdcommStart;

+(int)stdcommClose;

+(int)stdcommEnd;

//////////////////////////////////////////////////////////////////
//修改及新增项
//新增波形数据接收回调
+(void)stdRegMessageBox:(NSObject*)obj andSelect:(SEL)select andSelectDat:(SEL)selectdat andTermId:(int)termid;

//切换单终端波型模式和多终端文本参数模式（终端ID为0时为多终端文本模式，指定具体终端号时会返回该终端波形数据，具它终端文本数据会占停）
+(void)stdSetTremId:(unsigned int)termid;

//读取指定终端血压
+(int)stdcommGetPatBPM:(NSString *)patid andTermid:(int)termid ;



@end
#endif
