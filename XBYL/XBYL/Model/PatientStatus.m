//
//  PatientStatus.m
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "PatientStatus.h"

@implementation PatientStatus
+(PatientStatus *)getModelWithString:(NSString *)str{
    if (str) {
        PatientStatus *model=[[PatientStatus alloc]init];
        NSArray *arr = [str componentsSeparatedByString:NSLocalizedString(@"|", nil)];
        if (arr) {
            model.patientNo=arr[0];
            model.status=[arr[1] integerValue];
        }
        
        return model;
    }
    else{
        return nil;
    }
}
@end
