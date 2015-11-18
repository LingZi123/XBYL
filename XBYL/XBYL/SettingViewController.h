//
//  SettingViewController.h
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "PickViewController.h"

@protocol SettingViewControllerDelegate <NSObject>

-(void)complateSetting:(NSInteger)refashTime dataArray:(NSMutableArray *)dataArray;

@end

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate,UIActionSheetDelegate,PickViewControllerDelegate>{
    
    __weak IBOutlet UISegmentedControl *segmentSelected;
    __weak IBOutlet UIView *dateSelectedView;
    NSString *refashDataValue;
    __weak IBOutlet UITableView *settingTableView;
    NSMutableArray *dataArray;
    __weak IBOutlet UIView *selectDataTopView;
    CGRect tempFrame;//原图的位置
    __weak IBOutlet UIView *selectDataBottomView;//底图
    UIActionSheet *refashSheet;
   
    __weak IBOutlet UIButton *refashButton;
    NSMutableDictionary *alarmDic;
    
    //报警设置参数
    __weak IBOutlet UITableView *armTableView;
    NSMutableArray *alarmArray;//报警参数数组
    __weak IBOutlet UIView *alarmSettingView;
    NSInteger shousuoUpValue;
    NSInteger shuzhangUpValue;
    NSInteger xueyangUpValue;
    NSInteger xinlvUpValue;
    NSInteger mailvUpValue;
    NSInteger huxiUpValue;
    NSInteger xinlvDownValue;
    NSInteger mailvDownValue;
    NSInteger huxiDownValue;
    NSInteger xueyangDownValue;
    NSInteger shousuoDownValue;
    NSInteger shuzhangDownValue;
}

@property(nonatomic,assign)NSInteger refashValue;//刷新频率
@property(nonatomic,assign)id<SettingViewControllerDelegate> settingviewDelegate;

- (IBAction)switchSelected:(id)sender;
- (IBAction)saveAlarmSetting:(id)sender;
- (IBAction)refashRateClick:(id)sender;
- (IBAction)savaData:(id)sender;

@end
