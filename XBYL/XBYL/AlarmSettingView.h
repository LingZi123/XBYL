//
//  AlarmSettingView.h
//  XBYL
//
//  Created by 罗娇 on 16/1/26.
//  Copyright (c) 2016年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonSettingInfo.h"


@protocol AlarmSettingViewDelegate <NSObject>

-(void)popAlarmPickView:(NSArray *)upArray downArray:(NSArray *)downArray data:(NSMutableDictionary *)data selectRow:(NSIndexPath *)selectRow;
-(void)savedata:(PersonSettingInfo *)info;

@end

@interface AlarmSettingView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *dataTableView;
    NSMutableArray *dataArray;
}

@property(nonatomic,retain)PersonSettingInfo *info;//个人报警信息
@property(nonatomic,assign)id<AlarmSettingViewDelegate>delegate;

-(void)refashInRow:(NSIndexPath *)row upValue:(NSString *)upvalue downValue:(NSString *)downValue;
-(void)recoveDefault:(PersonSettingInfo *)info;
-(instancetype)initWithFrame:(CGRect)frame info:(PersonSettingInfo *)info;
@end
