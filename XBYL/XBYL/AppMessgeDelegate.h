//
//  AppMessgeDelegate.h
//  XBYL
//
//  Created by PC_201310113421 on 16/1/19.
//  Copyright (c) 2016年 罗娇. All rights reserved.
//

@protocol AppMessgeDelegate <NSObject>

@optional
-(void)logingMessage:(NSString *)mes;
-(void)patientMessage:(NSString*)cmd andMsg:(NSString*)msg;
-(void)hosMessage:(NSString *)mes;
-(void)networkMessage:(NSString *)mes;
//-(void)refashMainvc;//刷新主界面
@end