//
//  PersonSettingViewController.h
//  XBYL
//
//  Created by 罗娇 on 15/7/30.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickViewController.h"
#import "PatientInfo.h"
#import "PersonSettingInfo.h"

@interface PersonSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PickViewControllerDelegate>
{
//    NSInteger shousuoUpValue;
//    NSInteger shuzhangUpValue;
//    NSInteger xueyangUpValue;
//    NSInteger xinlvUpValue;
//    NSInteger mailvUpValue;
//    NSInteger huxiUpValue;
//    NSInteger xinlvDownValue;
//    NSInteger mailvDownValue;
//    NSInteger huxiDownValue;
//    NSInteger xueyangDownValue;
//    NSInteger shousuoDownValue;
//    NSInteger shuzhangDownValue;
    NSString *titleName;
    PersonSettingInfo *personSetting;
    
    __weak IBOutlet UITableView *dataTableView;
    NSMutableArray *dataArray;
}
- (IBAction)add:(id)sender;
- (IBAction)substract:(id)sender;
- (IBAction)saveData:(id)sender;

-(instancetype)initWithTitle:(NSString *)title_;
@property(nonatomic,retain)PatientInfo *patient;//病人信息

@end
