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

+(void)stdRegMessageBox:(NSObject*)obj andSelect:(SEL)select;

@end
#endif
