//
//  PersonSettingViewController.h
//  XBYL
//
//  Created by 罗娇 on 15/7/30.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientInfo.h"
#import "PersonSettingInfo.h"
#import "AlarmPickView.h"
#import "AlarmSettingView.h"
#import "BaseViewController.h"

@interface PersonSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AlarmPickViewDelegate,AlarmSettingViewDelegate>
{
    NSString *titleName;
    PersonSettingInfo *personSetting;
    AlarmSettingView *settingView;
    
//    __weak IBOutlet UITableView *dataTableView;
//    NSMutableArray *dataArray;
}

//- (IBAction)saveData:(id)sender;

-(instancetype)initWithTitle:(NSString *)title_;
@property(nonatomic,retain)PatientInfo *patient;//病人信息

@end
