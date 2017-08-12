//
//  MulDataModel.m
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "MulDataModel.h"

@implementation MulDataModel

+(MulDataModel *)getModelWithString:(NSString *)str{
    if (str) {
        MulDataModel *model=[[MulDataModel alloc]init];
        NSArray *arr = [str componentsSeparatedByString:NSLocalizedString(@"|", nil)];
        if (arr) {
            model.terminNo=arr[0];
            model.xueyang=arr[1];
            model.xinlv=arr[2];
            model.mailv=arr[3];
            model.resp=arr[4];
        }
        
        return model;
    }
    else{
        return nil;
    }
}

@end
