//
//  PersonSettingViewController.m
//  XBYL
//
//  Created by 罗娇 on 15/7/30.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "PersonSettingViewController.h"
#import "AppDelegate.h"
#import "PersonSettingInfo.h"
#import "AlarmPickView.h"
#import "LewPopupViewAnimationSpring.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface PersonSettingViewController ()

@end

@implementation PersonSettingViewController

-(instancetype)initWithTitle:(NSString *)title_ info:(PersonSettingInfo *)info{
    self=[super init];
    if (self) {
        titleName=title_;
        personSetting=info;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //从本地数据库中获取
    personSetting=[PersonSettingInfo getModelWithPatientNo:_patient.patientNo];
    if (personSetting==nil) {
        personSetting=[[PersonSettingInfo alloc]init];
        [self defaultSetting];
    }
    [self makeView];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=[NSString stringWithFormat:@"%@-报警设置",_patient.patientName];
    settingView.delegate=self;
}

-(void)viewWillDisappear:(BOOL)animated{
    settingView.delegate=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)makeView{
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"默认" style:UIBarButtonItemStylePlain target:self action:@selector(recoveDefault:)];
     [rightBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
     [leftBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem=leftBar;
    self.navigationItem.rightBarButtonItem=rightBar;
    
    settingView=[[AlarmSettingView alloc]initWithFrame:CGRectMake(0,8, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-8) info:personSetting];
    [self.view addSubview:settingView];
}

-(void)defaultSetting{
    personSetting.patientNo=_patient.patientNo;
    personSetting.shuzhangyadownvalue=[NSString stringWithFormat:@"%d",Default_Shuzhangye_Down];
    personSetting.shuzhangyaupvalue=[NSString stringWithFormat:@"%d",Default_Shuzhangye_Up];
    personSetting.shousuoyadownvalue=[NSString stringWithFormat:@"%d",Default_Shousuoya_Down];
    personSetting.shousuoyaupvalue=[NSString stringWithFormat:@"%d",Default_Shousuoya_Up];
    personSetting.xueyangdownvalue=[NSString stringWithFormat:@"%d",Default_Xueyang_Down];
    personSetting.xueyangupvalue=[NSString stringWithFormat:@"%d",Default_Xueyang_Up];
    personSetting.xinlvdownvalue=[NSString stringWithFormat:@"%d",Default_Xinlv_Down];
    personSetting.xinlvupvalue=[NSString stringWithFormat:@"%d",Default_Xinlv_Up];
    personSetting.mailvdownvalue=[NSString stringWithFormat:@"%d",Default_Mailv_Down];
    personSetting.mailvupvalue=[NSString stringWithFormat:@"%d",Default_Mailv_Up];
    personSetting.huxidownvalue=[NSString stringWithFormat:@"%d",Default_Huxi_Down];
    personSetting.huxiupvalue=[NSString stringWithFormat:@"%d",Default_Huxi_Up];
}
-(void)recoveDefault:(id)sender{
    [self defaultSetting];
    [settingView recoveDefault:personSetting];
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-PickViewControllerDelegate
-(void)complateInRow:(NSIndexPath *)row upValue:(NSString *)upvalue downValue:(NSString *)downValue{
    [settingView refashInRow:row upValue:upvalue downValue:downValue];
}

#pragma mark-AlarmSettingViewDelegate
-(void)popAlarmPickView:(NSArray *)upArray downArray:(NSArray *)downArray data:(NSMutableDictionary *)data selectRow:(NSIndexPath *)selectRow{
    AlarmPickView *alarmpickview=[AlarmPickView defaultPopupView];
    alarmpickview.parentVC = self;
    alarmpickview.delegate=self;
    
    alarmpickview.selectRow=selectRow;
    alarmpickview.titleValue=[data objectForKey:@"title"];
    alarmpickview.updataArray=upArray;
    alarmpickview.downDataArray=downArray;
    alarmpickview.upValue=[data objectForKey:@"upValue"];
    alarmpickview.downValue=[data objectForKey:@"downValue"];
    [alarmpickview makeView];
    [self lew_presentPopupView:alarmpickview animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];

}
-(void)savedata:(PersonSettingInfo *)info{
    BOOL result=NO;
    if ([PersonSettingInfo getModelWithPatientNo:info.patientNo]!=nil) {
        result=[PersonSettingInfo updateModelWithModel:info];
    }
    else{
        result=[PersonSettingInfo InsertModelWithModel:info];
    }
    if (result) {
        [SVProgressHUD showErrorWithStatus:@"保存成功"];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }
 
}
@end
