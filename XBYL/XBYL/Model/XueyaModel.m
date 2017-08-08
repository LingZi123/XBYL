//
//  XueyaModel.m
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "XueyaModel.h"

@implementation XueyaModel

+(XueyaModel *)getModelWithString:(NSString *)str{
    if (str) {
        XueyaModel *model=[[XueyaModel alloc]init];
        NSArray *arr = [str componentsSeparatedByString:NSLocalizedString(@"|", nil)];
        if (arr) {
            model.patientNo=arr[0];
            model.shousuoya=arr[1];
            model.DBP=arr[2];
            model.mailv=arr[3];
            model.addTime=arr[4];
        }
        
        return model;
    }
    else{
        return nil;
    }
  
}
//远程测量

+(XueyaModel *)getModelWithStringByTest:(NSString *)str{
    if (str) {
        NSLog(@"adfdf %@",str);
        XueyaModel *model=[[XueyaModel alloc]init];
        NSArray *arr = [str componentsSeparatedByString:NSLocalizedString(@"|", nil)];
        if (arr) {
            model.patientNo=arr[0];
            model.shousuoya=arr[1];
            model.DBP=arr[2];
            model.statusStr=arr[3];
            model.resultStr=arr[4];
        }
        
        return model;
    }
    else{
        return nil;
    }

}
@end
