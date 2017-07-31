//
//  BODataModel.m
//  HeartRateCurve
//
//  Created by 罗娇 on 2017/7/29.
//  Copyright © 2017年 N/A. All rights reserved.
//

#import "BODataModel.h"

static const NSInteger datalength=676;

@implementation BODataModel


+(BODataModel *)getModelWithData:(NSData*)data{
     NSLog(@" wavedataACK  buf[%D]=%d",data.bytes );
    if (data.length<datalength) {
        return nil;
    }
    
    
    BODataModel *model=[[BODataModel alloc]init];
    
    Byte *bytes=data.bytes;
    
//    for (int j=0; j<data.length; j++) {
//        NSLog(@"byte[j]%d",bytes[j]);
//    }
    model.hr=(ushort)(bytes[1]<<8)+bytes[0];
    model.spo2=(ushort)(bytes[3]<<8)+bytes[2];
    model.pluse=(ushort)(bytes[5]<<8)+bytes[4];
    model.resp=(ushort)(bytes[7]<<8)+bytes[6];
    model.tp=(ushort)(bytes[9]<<8)+bytes[8];
    model.fingerflag=(ushort)(bytes[11]<<8)+bytes[10];
    model.jeadsflag=(ushort)(bytes[13]<<8)+bytes[12];
    model.mask=(ushort)(bytes[15]<<8)+bytes[14];
    
    if (model.ecgArray==nil) {
        model.ecgArray=[[NSMutableArray alloc]init];
    }
    if (model.spo2Array==nil) {
        model.spo2Array=[[NSMutableArray alloc]init];
    }
    if (model.repsArray==nil) {
        model.repsArray=[[NSMutableArray alloc]init];
    }

    
    int i=16;
    
    while (i<data.length) {
        //从下标14开始
        ushort tempdata=(ushort)(bytes[i+1]<<8)+bytes[i];
        if (i<266) {
            [model.ecgArray addObject:[NSNumber numberWithUnsignedShort:tempdata]];
        }
        else if (i>=266&&i<516){
                        [model.spo2Array addObject:[NSNumber numberWithUnsignedShort:tempdata]];
        }
        else{
            
            [model.repsArray addObject:[NSNumber numberWithUnsignedShort:tempdata]];
        }

        i=i+2;
        NSLog(@"tempdata=%d",tempdata);
    }
    NSLog(@"model====%@",model);
    return model;
}
@end
