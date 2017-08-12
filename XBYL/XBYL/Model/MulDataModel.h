//
//  MulDataModel.h
//  XBYL
//
//  Created by 罗娇 on 15/8/23.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MulDataModel : NSObject

@property(nonatomic,copy)NSString *terminNo;//终端编号
@property(nonatomic,copy)NSString *mailv;//脉率
@property(nonatomic,copy)NSString *xinlv;//心率
@property(nonatomic,copy)NSString *xueyang;//血氧饱和度
@property(nonatomic,copy)NSString *resp;//呼吸
+(MulDataModel *)getModelWithString:(NSString *)str;

@end
