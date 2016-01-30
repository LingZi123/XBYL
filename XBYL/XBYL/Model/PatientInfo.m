//
//  PatientInfo.m
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "PatientInfo.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "PatientInfoModel.h"
#import "PersonSettingInfo.h"

@implementation PatientInfo
+(PatientInfo *)getModelWithString:(NSString *)str{
    if (str) {
        PatientInfo *model=[[PatientInfo alloc]init];
        NSArray *arr = [str componentsSeparatedByString:NSLocalizedString(@"|", nil)];
        if (arr) {
              model.patientNo=arr[0];
              model.terminNo=arr[1];
              model.phoneNo=arr[2];
              model.hosNo=arr[3];
                model.patientName=arr[4];
            model.doctorName=arr[5];

                model.patientSex=arr[6];

            
                model.patientAge=arr[7];

                model.IDCard=arr[8];

                model.address=arr[9];

                model.youbianNo=arr[10];

            model.job=arr[11];

                model.telNo=arr[12];

                model.jianhuLel=arr[14];

                model.chubuZZ=arr[15];

                model.zhuyuanNo=arr[16];

                model.bingchuangNo=arr[17];

                model.keshi=arr[18];

            model.isImportPatient=arr[19];
            model.addDate=arr[20];
            model.patientTall=arr[21];
            model.patientWeight=arr[22];
            if (model.xueya==nil) {
                model.xueya=[[XueyaModel alloc]init];
                model.xueya.shousuoya=arr[23];
                model.xueya.DBP=arr[24];
            }
            model.menzhenNo=arr[25];
            model.subTermType=arr[26];
            model.baseXueyaCheckDate=arr[27];
            if (model.mulData==nil) {
                model.mulData=[[MulDataModel alloc]init];
            }
            if (model.status==nil) {
                model.status=[[PatientStatus alloc]init];
                //默认在线
                model.status.status=1;
                model.status.patientNo=model.patientNo;
            }
            model.isShown=YES;
            model.isRefash=NO;
        }
    
        return model;
    }
    else{
        return nil;
    }
}

//从数据库获取所有的保存的数据，可以显示的
+(NSMutableArray *)getAllModelWithIshow:(BOOL)isShow{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PatientInfoModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"isShow==%@",[NSNumber numberWithBool:isShow]];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (error!=nil) {
        return nil;
    }
    else{
        if (tempArray&&tempArray.count>0) {
            NSMutableArray *modelArray=[[NSMutableArray alloc]init];
            for (PatientInfoModel *item in tempArray) {
                PatientInfo *model=[self getModelWithDBModel:item];
                model.personSetting=[PersonSettingInfo getModelWithPatientNo:model.patientNo];
                [modelArray addObject:model];
            }
            return modelArray;
        }
        else{
            return nil;
        }
    }

}
//修改数据
+(BOOL)updateModelWithModel:(PatientInfo *)info{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PatientInfoModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"patientNo==%@",info.patientNo];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (tempArray==nil||tempArray.count<=0) {
        //不存在不用修改
        return YES;
    }
    else{
    
        for (PatientInfoModel *item in tempArray) {
            BOOL ischange=NO;
            if (![item.hosNo isEqualToString:info.hosNo]) {
                item.hosNo=info.hosNo;
                ischange=YES;
            }
            if (![item.bingchuangNo isEqualToString:info.bingchuangNo]) {
                item.bingchuangNo=info.bingchuangNo;
                ischange=YES;
            }
            if ([item.isShow boolValue]!=info.isShown) {
                item.isShow=[NSNumber numberWithBool:info.isShown];
                ischange=YES;
            }
            if (![item.jianhuLel isEqualToString:info.jianhuLel]) {
                item.jianhuLel=info.jianhuLel;
                ischange=YES;
            }
            if (![item.terminNo isEqualToString:info.terminNo]) {
                item.terminNo=info.terminNo;
                ischange=YES;
            }
            if (![item.patientName isEqualToString:info.patientName]) {
                item.patientName=info.patientName;
                ischange=YES;
            }
            if (![item.patientAge isEqualToString:info.patientAge]) {
                item.patientAge=info.patientAge;
                ischange=YES;
            }
            if (![item.patientSex isEqualToString:info.patientSex]) {
                item.patientSex=info.patientSex;
                ischange=YES;
            }
            if (![item.phoneNo isEqualToString:info.phoneNo]) {
                item.phoneNo=info.phoneNo;
                ischange=YES;
            }
            if (ischange) {
                return [context save:&error];
            }
            else{
                return YES;
            }
           
        }
        return YES;
    }
    return YES;
}
//添加数据
+(BOOL)InsertModelWithModel:(PatientInfo *)info{
    if (info==nil) {
        return false;
    }
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    
    PatientInfoModel *newItem=(PatientInfoModel *)[NSEntityDescription insertNewObjectForEntityForName:@"PatientInfoModel" inManagedObjectContext:context];
    [newItem setPatientNo:info.patientNo];
    [newItem setTerminNo:info.terminNo];
    [newItem setHosNo:info.hosNo];
    [newItem setBingchuangNo:info.bingchuangNo];
    [newItem setJianhuLel:info.jianhuLel];
    [newItem setPatientName:info.patientName];
    [newItem setPatientAge:info.patientAge];
    [newItem setPatientSex:info.patientSex];
    [newItem setPhoneNo:info.phoneNo];
    [newItem setIsShow:[NSNumber numberWithBool:info.isShown]];
    // 当天
    [newItem setAddDate:[NSDate date]];
    NSError *error=nil;
    BOOL a=[context save:&error];
    NSLog(@"%@",error);
    return a;
}
//删除数据
+(BOOL)deleteModelWithPatientNo:(NSString *)patientNo{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PatientInfoModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"patientNo==%@",patientNo];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    for (PatientInfoModel *model in tempArray) {
        //删除个人设置
        [PersonSettingInfo deleteModelWithPatientNo:model.patientNo];
        [context deleteObject:model];
    }
    return [context save:&error];
}
+(NSMutableArray *)getAllModelWithHosno:(NSString *)hosNo{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PatientInfoModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"hosNo==%@",hosNo];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (tempArray&&tempArray.count>0) {
        NSMutableArray *patientArray=[[NSMutableArray alloc]init];
        for (PatientInfoModel *model in tempArray) {
            PatientInfo *patient=[self getModelWithDBModel:model];
            patient.personSetting=[PersonSettingInfo getModelWithPatientNo:model.patientNo];
            [patientArray addObject:patient];
        }
        return patientArray;
    }
    else{
        return nil;
    }
}

+(PatientInfo *)getModelWithDBModel:(PatientInfoModel *)item{
    
    PatientInfo *model=[[PatientInfo alloc]init];
    model.hosNo=item.hosNo;
    model.patientNo=item.patientNo;
    model.bingchuangNo=item.bingchuangNo;
    model.isShown=[item.isShow boolValue];
    model.jianhuLel=item.jianhuLel;
    model.terminNo=item.terminNo;
    model.patientName=item.patientName;
    model.patientAge=item.patientAge;
    model.patientSex=item.patientSex;
    model.phoneNo=item.phoneNo;
    model.addDate=item.addDate;
    
    return model;
}

//获取所有数据
+(NSMutableArray *)getAllModel{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PatientInfoModel"];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (tempArray&&tempArray.count>0) {
        NSMutableArray *patientArray=[[NSMutableArray alloc]init];
        for (PatientInfoModel *model in tempArray) {
            PatientInfo *patient=[self getModelWithDBModel:model];
             patient.personSetting=[PersonSettingInfo getModelWithPatientNo:model.patientNo];
            [patientArray addObject:patient];
        }
        return patientArray;
    }
    else{
        return nil;
    }
}

+(void)clearModels{
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PatientInfoModel"];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    
    for (PatientInfoModel *model in tempArray) {
        [context deleteObject:model];
    }
    [context save:&error];
}
@end
