//
//  HospitalInfo.m
//  XBYL
//
//  Created by 罗娇 on 15/8/26.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "HospitalInfo.h"
#import "HospitalModel.h"
#import "AppDelegate.h"

@implementation HospitalInfo

//-(AppDelegate *)appDelegate{
//    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
//}

//从数据库获取所有的保存的数据，可以显示的
+(NSMutableArray *)getAllModelFromCore
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"HospitalModel"];

    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (error!=nil) {
        return nil;
    }
    else{
        if (tempArray&&tempArray.count>0) {
             NSMutableArray *modelArray=[[NSMutableArray alloc]init];
            for (HospitalModel *item in tempArray) {
                HospitalInfo *model=[[HospitalInfo alloc]init];
                model.hosNo=item.hosNo;
                model.hosName=item.hosName;
                model.hosRight=item.hosRight;
                [modelArray addObject:model];
            }
            return modelArray;
        }
        else{
            return nil;
        }
    }
}

+(BOOL)existModelWithHosno:(NSString *)hosno
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"HospitalModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"hosNo==%@",hosno];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (error!=nil) {
        return NO;
    }
    else{
        if (tempArray&&tempArray.count>0) {
            return YES;
        }
        else{
            return NO;
        }
    }
}
//修改数据
+(BOOL)updateModelWithModel:(HospitalInfo *)info{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"HospitalModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"hosNo==%@",info.hosNo];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    if (tempArray==nil||tempArray.count<=0) {
        //不存在不用修改
        return YES;
    }
    else{
        for (HospitalModel *item in tempArray) {
            if (![item.hosName isEqualToString:info.hosName]) {
                item.hosName=info.hosName;
            }
            if (![item.hosRight isEqualToString:info.hosRight]) {
                item.hosRight=info.hosRight;
            }
        }
        return [context save:&error];
    }
}
//添加数据
+(BOOL)InsertModelWithModel:(HospitalInfo *)info{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    
    HospitalModel *newItem=(HospitalModel *)[NSEntityDescription insertNewObjectForEntityForName:@"HospitalModel" inManagedObjectContext:context];
    [newItem setHosName:info.hosName];
    [newItem setHosNo:info.hosNo];
    [newItem setHosRight:info.hosRight];
    
    NSError *error=nil;
    return [context save:&error];

}
//删除数据
+(BOOL)deleteModelWithModel:(NSString *)hosNo{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"HospitalModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"hosNo==%@",hosNo];
    
    NSError *error=nil;
    NSArray *tempArray=[context executeFetchRequest:request error:&error];
    for (HospitalModel *model in tempArray) {
        [context deleteObject:model];
    }
    return [context save:&error];
}

+(NSMutableArray *)getHosWithMsg:(NSString *)msg{
    NSMutableArray *hosArray=[[NSMutableArray alloc]init];
    if (msg) {
         NSArray *arr = [msg componentsSeparatedByString:NSLocalizedString(@"\n", nil)];
        for (int i=0;i<arr.count;i++) {
            NSString *str=[arr objectAtIndex:i];
            if (![str isEqualToString:@""]) {
                NSArray *singleArr=[str componentsSeparatedByString:NSLocalizedString(@"|", nil)];
                HospitalInfo *hosInfo=[[HospitalInfo alloc]init];
                hosInfo.hosNo=singleArr[0];
                hosInfo.hosName=singleArr[1];
                hosInfo.hosRight=singleArr[2];
                
                //数据库中是否存在，不存在就添加，存在修改
                if ([self existModelWithHosno:hosInfo.hosNo]) {
                    [self updateModelWithModel:hosInfo];
                }
                else{
                    [self InsertModelWithModel:hosInfo];
                }
                
                [hosArray addObject:hosInfo];
            }
           
        }
    }
    return hosArray;
}

@end
