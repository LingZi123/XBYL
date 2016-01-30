//
//  PersonSettingInfo.m
//  XBYL
//
//  Created by 罗娇 on 15/8/27.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "PersonSettingInfo.h"
#import "AppDelegate.h"
#import "PersonSettingModel.h"

@implementation PersonSettingInfo

//-(AppDelegate *)appDelegate{
//    
//    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
//}

+(PersonSettingInfo *)getModelWithPatientNo:(NSString *)patientNo//从数据库获取所有的保存的数据，可以显示的
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PersonSettingModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"patientNo==%@",patientNo];
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (error!=nil) {
        return nil;
    }
    else{
        PersonSettingInfo *model=[[PersonSettingInfo alloc]init];
        if (tempArray&&tempArray.count>0) {
            for (PersonSettingModel *item in tempArray) {
                model.patientNo=item.patientNo;
                model.shousuoyadownvalue=item.shousuoyadownvalue;
                model.shousuoyaupvalue=item.shousuoyaupvalue;
                model.shuzhangyadownvalue=item.shuzhangyadownvalue;
                model.shuzhangyaupvalue=item.shuzhangyaupvalue;
                model.mailvdownvalue=item.mailvdownvalue;
                model.mailvupvalue=item.mailvupvalue;
                model.huxidownvalue=item.huxidownvalue;
                model.huxiupvalue=item.huxiupvalue;
                model.xueyangdownvalue=item.xueyangdownvalue;
                model.xueyangupvalue=item.xueyangupvalue;
                model.xinlvdownvalue=item.xinlvdownvalue;
                model.xinlvupvalue=item.xinlvupvalue;
                break;
            }
            return model;
        }
        else{
            return nil;
        }
    }
}
//修改数据
+(BOOL)updateModelWithModel:(PersonSettingInfo *)info{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PersonSettingModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"patientNo==%@",info.patientNo];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (tempArray==nil||tempArray.count<=0) {
        //不存在不用修改
        return YES;
    }
    else{
        for (PersonSettingModel *item in tempArray) {
            if (![item.shousuoyadownvalue isEqualToString:info.shousuoyadownvalue]) {
                item.shousuoyadownvalue=info.shousuoyadownvalue;
            }
            if (![item.shousuoyaupvalue isEqualToString:info.shousuoyaupvalue]) {
                item.shousuoyaupvalue=info.shousuoyaupvalue;
            }
            if (![item.xueyangdownvalue isEqualToString:info.xueyangdownvalue]) {
                item.xueyangdownvalue=info.xueyangdownvalue;
            }
            if (![item.xueyangupvalue isEqualToString:info.xueyangupvalue]) {
                item.xueyangupvalue=info.xueyangupvalue;
            }
            if (![item.shuzhangyadownvalue isEqualToString: info.shuzhangyadownvalue]) {
                item.shuzhangyadownvalue=info.shuzhangyadownvalue;
            }
            if (![item.shuzhangyaupvalue isEqualToString: info.shuzhangyaupvalue]) {
                item.shuzhangyaupvalue=info.shuzhangyaupvalue;
            }
            if (![item.xinlvdownvalue isEqualToString: info.xinlvdownvalue]) {
                item.xinlvdownvalue=info.xinlvdownvalue;
            }
            if (![item.xinlvupvalue isEqualToString: info.xinlvupvalue]) {
                item.xinlvupvalue=info.xinlvupvalue;
            }
            if (![item.mailvupvalue isEqualToString: info.mailvupvalue]) {
                item.mailvupvalue=info.mailvupvalue;
            }
            if (![item.mailvdownvalue isEqualToString: info.mailvdownvalue]) {
                item.mailvdownvalue=info.mailvdownvalue;
            }
            if (![item.huxidownvalue isEqualToString: info.huxidownvalue]) {
                item.huxidownvalue=info.huxidownvalue;
            }
            if (![item.huxiupvalue isEqualToString: info.huxiupvalue]) {
                item.huxiupvalue=info.huxiupvalue;
            }
        }
        return [context save:&error];
    }

}

//添加数据
+(BOOL)InsertModelWithModel:(PersonSettingInfo *)info{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    
    PersonSettingModel *newItem=(PersonSettingModel *)[NSEntityDescription insertNewObjectForEntityForName:@"PersonSettingModel" inManagedObjectContext:context];
    [newItem setPatientNo:info.patientNo];
    [newItem setShuzhangyadownvalue:info.shuzhangyadownvalue];
    [newItem setShuzhangyaupvalue:info.shuzhangyaupvalue];
    [newItem setShousuoyadownvalue:info.shousuoyadownvalue];
    [newItem setShousuoyaupvalue:info.shousuoyaupvalue];
    [newItem setMailvdownvalue:info.mailvdownvalue];
    [newItem setMailvupvalue:info.mailvupvalue];
    [newItem setHuxidownvalue:info.huxidownvalue];
    [newItem setHuxiupvalue:info.huxiupvalue];
    [newItem setXueyangdownvalue:info.xueyangdownvalue];
    [newItem setXueyangupvalue:info.xueyangupvalue];
    [newItem setXinlvdownvalue:info.xinlvdownvalue];
    [newItem setXinlvupvalue:info.xinlvupvalue];

    NSError *error=nil;
    return [context save:&error];
}

//删除数据
+(BOOL)deleteModelWithPatientNo:(NSString *)patientNo
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PersonSettingModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"patientNo==%@",patientNo];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    for (PersonSettingModel *model in tempArray) {
        [context deleteObject:model];
    }
    return [context save:&error];
}

//获取所有数据都修改
+(BOOL)updateAllModelWithDic:(PersonSettingInfo *)dic{
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PersonSettingModel"];
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (error!=nil) {
        return nil;
    }
    else{
        PersonSettingInfo *model=[[PersonSettingInfo alloc]init];
        if (tempArray&&tempArray.count>0) {
            for (PersonSettingModel *item in tempArray) {
                PersonSettingInfo *info=[[PersonSettingInfo alloc]init];
                info.patientNo=item.patientNo;
                info.shousuoyaupvalue=dic.shousuoyaupvalue;
                info.shuzhangyaupvalue=dic.shuzhangyaupvalue;
                info.xueyangupvalue=dic.xueyangupvalue;
                info.xinlvupvalue=dic.xinlvupvalue;
                info.mailvupvalue=dic.mailvupvalue;
                info.huxiupvalue=dic.huxiupvalue;
                
                info.xinlvdownvalue=dic.xinlvdownvalue;
                info.mailvdownvalue=dic.mailvdownvalue;
                info.huxidownvalue=dic.huxidownvalue;
                info.xueyangdownvalue=dic.xueyangdownvalue;
                info.shousuoyadownvalue=dic.shousuoyadownvalue;
                info.shuzhangyadownvalue=dic.shuzhangyadownvalue;
                
                [self updateModelWithModel:info];
//                break;
            }
            return model;
        }
        else{
            return nil;
        }
    }
 
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.patientNo forKey:@"patientNo"];
    [aCoder encodeObject:self.shuzhangyaupvalue forKey:@"shuzhangyaupvalue"];
    [aCoder encodeObject:self.huxidownvalue forKey:@"huxidownvalue"];
    [aCoder encodeObject:self.xueyangdownvalue forKey:@"xueyangdownvalue"];
    [aCoder encodeObject:self.xueyangupvalue forKey:@"xueyangupvalue"];
    [aCoder encodeObject:self.shousuoyadownvalue forKey:@"shousuoyadownvalue"];
    [aCoder encodeObject:self.shuzhangyadownvalue forKey:@"shuzhangyadownvalue"];
    [aCoder encodeObject:self.shousuoyaupvalue forKey:@"shousuoyaupvalue"];
    [aCoder encodeObject:self.huxiupvalue forKey:@"huxiupvalue"];
    [aCoder encodeObject:self.xinlvdownvalue forKey:@"xinlvdownvalue"];
    [aCoder encodeObject:self.xinlvupvalue forKey:@"xinlvupvalue"];
    [aCoder encodeObject:self.mailvdownvalue forKey:@"mailvdownvalue"];
    [aCoder encodeObject:self.mailvupvalue forKey:@"mailvupvalue"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.patientNo=[aDecoder decodeObjectForKey:@"patientNo"];
        self.shuzhangyaupvalue=[aDecoder decodeObjectForKey:@"shuzhangyaupvalue"];
        self.shuzhangyadownvalue=[aDecoder decodeObjectForKey:@"shuzhangyadownvalue"];
        
        self.huxidownvalue=[aDecoder decodeObjectForKey:@"huxidownvalue"];
        self.huxiupvalue=[aDecoder decodeObjectForKey:@"huxiupvalue"];
        
        self.xueyangdownvalue=[aDecoder decodeObjectForKey:@"xueyangdownvalue"];
        self.xueyangupvalue=[aDecoder decodeObjectForKey:@"xueyangupvalue"];
        
        self.shousuoyadownvalue=[aDecoder decodeObjectForKey:@"shousuoyadownvalue"];
        self.shousuoyaupvalue=[aDecoder decodeObjectForKey:@"shousuoyaupvalue"];
        
        self.xinlvdownvalue=[aDecoder decodeObjectForKey:@"xinlvdownvalue"];
        self.xinlvupvalue=[aDecoder decodeObjectForKey:@"xinlvupvalue"];
        
        self.mailvdownvalue=[aDecoder decodeObjectForKey:@"mailvdownvalue"];
        self.mailvupvalue=[aDecoder decodeObjectForKey:@"mailvupvalue"];
    }
    return self;
}

+(void)clearModels{
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"PersonSettingModel"];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    
    for (PersonSettingModel *model in tempArray) {
        [context deleteObject:model];
    }
    [context save:&error];
}

@end
