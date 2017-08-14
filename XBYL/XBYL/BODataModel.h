//
//  BODataModel.h
//  HeartRateCurve
//
//  Created by 罗娇 on 2017/7/29.
//  Copyright © 2017年 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SIGLE_DATA @"SIGLE_DATA"


@interface BODataModel : NSObject

@property(nonatomic,assign)ushort hr;//心率
@property(nonatomic,assign)ushort spo2;//血氧
@property(nonatomic,assign)ushort pluse;//脉率
@property(nonatomic,assign)ushort resp;//呼吸
@property(nonatomic,assign)ushort tp;//体温
@property(nonatomic,assign)ushort fingerflag;//手指探测状态1-正常,0-脱落,2-导联线故障
@property(nonatomic,assign)ushort jeadsflag;//电击探测0-正常,1-脱落
@property(nonatomic,assign)ushort mask;//通道掩码

@property(nonatomic,retain)NSMutableArray *ecgArray; //125  a[3][125]
@property(nonatomic,retain)NSMutableArray *spo2Array;//
@property(nonatomic,retain)NSMutableArray *repsArray;//


//y轴0-2048；
//x轴

+(BODataModel *)getModelWithData:(NSData *)data;
@end
