//
//  SettingViewController.m
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewTableViewCell.h"
#import "HeadView.h"
#import "HospitalInfo.h"
#import "PatientInfo.h"
#import "nstdcomm.h"
#import "AppDelegate.h"
#import "PersonSettingInfo.h"
#import "AlarmPickView.h"
#import "LewPopupViewAnimationSpring.h"
#import "SVProgressHUD/SVProgressHUD.h"


#define def_shousuoUpValue @"shousuoUpValue"
#define def_shousuoDownValue @"shousuoDownValue"

#define def_shuzhangUpValue @"shuzhangUpValue"
#define def_shuzhangDownValue @"shuzhangDownValue"

#define def_xueyangUpValue @"xueyangUpValue"
#define def_xueyangDownValue @"xueyangDownValue"

#define def_xinlvUpValue @"xinlvUpValue"
#define def_xinlvDownValue @"xinlvDownValue"

#define def_mailvUpValue @"mailvUpValue"
#define def_mailvDownValue @"mailvDownValue"

#define def_huxiUpValue @"huxiUpValue"
#define def_huxiDownValue @"huxiDownValue"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //从本地数据库读取数据
    [self setExtraCellLineHidden:settingTableView];
    alarmSettingView.delegate=self;
    segmentSelected.selectedSegmentIndex=0;
    [self switchSelected:segmentSelected];
}

-(void)viewWillDisappear:(BOOL)animated{
    alarmSettingView.delegate=nil;
//    [nstdcomm stdRegMessageBox:nil andSelect:@selector(stdMessageBox:andMsg:)];
}


-(void)makeView{
    segmentSelected.selectedSegmentIndex=0;
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"默认" style:UIBarButtonItemStylePlain target:self action:@selector(recoverDefault:)];
    [rightBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=rightBar;
    self.navigationItem.title=@"设置";
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    [leftBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem=leftBar;
    
    //xib注册
    UINib *xib=[UINib nibWithNibName:@"SettingViewTableViewCell" bundle:nil];
    [settingTableView registerNib:xib forCellReuseIdentifier:@"SettingViewTableViewCell"];
    
    //读取数据文件填充数据
    if (dataArray==nil) {
        dataArray=[[NSMutableArray alloc]init];
    }
    //通过医院分割数据
    NSMutableArray *hosArray=[HospitalInfo getAllModelFromCore];
    for (HospitalInfo *hosItem in hosArray) {
        hosItem.patients=[PatientInfo getAllModelWithHosno:hosItem.hosNo];
        [dataArray addObject:hosItem];
    }
    
    tempFrame= selectDataTopView.frame;
    refashSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"5秒",@"10秒",@"15秒",@"20秒", nil];
    refashSheet.hidden=YES;
    [refashButton setTitle:[NSString stringWithFormat:@"%ld秒刷新",_refashValue] forState:UIControlStateNormal];
    
    //填充报警参数值
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *data=[defaults objectForKey:user_defaultAlarmSetting];
    if (data) {
        alarmInfo=(PersonSettingInfo *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    if (alarmInfo==nil) {
         [self defuaultAlarmDic];
    }
    alarmSettingView=[[AlarmSettingView alloc]initWithFrame:dateSelectedView.frame info:alarmInfo];
    [self.view addSubview:alarmSettingView];
    
}

-(void)defuaultAlarmDic{
    alarmInfo=[[PersonSettingInfo alloc]init];
    alarmInfo.patientNo=Default_People ;
    
    alarmInfo.shousuoyaupvalue=[NSString stringWithFormat:@"%d",Default_Shousuoya_Up];
    alarmInfo.shuzhangyaupvalue=[NSString stringWithFormat:@"%d",Default_Shuzhangye_Up];
    alarmInfo.xueyangupvalue=[NSString stringWithFormat:@"%d",Default_Xueyang_Up];
    alarmInfo.xinlvupvalue=[NSString stringWithFormat:@"%d",Default_Xinlv_Up];
    alarmInfo.mailvupvalue=[NSString stringWithFormat:@"%d",Default_Mailv_Up];
    alarmInfo.huxiupvalue=[NSString stringWithFormat:@"%d",Default_Huxi_Up];
    alarmInfo.xinlvdownvalue=[NSString stringWithFormat:@"%d",Default_Xinlv_Down];
    alarmInfo.mailvdownvalue=[NSString stringWithFormat:@"%d",Default_Mailv_Down];
    alarmInfo.huxidownvalue=[NSString stringWithFormat:@"%d",Default_Huxi_Down];
    alarmInfo.xueyangdownvalue=[NSString stringWithFormat:@"%d",Default_Xueyang_Down];
    alarmInfo.shousuoyadownvalue=[NSString stringWithFormat:@"%d",Default_Shousuoya_Down];
    alarmInfo.shuzhangyadownvalue=[NSString stringWithFormat:@"%d",Default_Shuzhangye_Down];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
}
#pragma mark-action
-(void)recoverDefault:(UIBarButtonItem *)sender{
    [self dismissKeyBoard];
    if (segmentSelected.selectedSegmentIndex==0) {
        //所有数据全选
        for (HospitalInfo *info in dataArray) {
            for (PatientInfo *patient in info.patients) {
                patient.isShown=YES;
            }
        }
        [settingTableView reloadData];
    }
    else{
        [self defuaultAlarmDic];
        [alarmSettingView recoveDefault:alarmInfo];
    }
}
-(void)back:(id)sender{
    [self dismissKeyBoard];
    [self.settingviewDelegate complateSetting:_refashValue dataArray:dataArray];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)switchSelected:(id)sender {
    if (segmentSelected.selectedSegmentIndex==0) {
        alarmSettingView.hidden=YES;
        dateSelectedView.hidden=NO;
    }
    else{
        alarmSettingView.hidden=NO;
        dateSelectedView.hidden=YES;
    }
}

- (IBAction)refashRateClick:(id)sender {
    
//    [self ViewAnimation:refashRatePicker willHidden:NO];
    [refashSheet showInView:self.view];
    
    
}
- (IBAction)savaData:(id)sender {
    for (HospitalInfo *hospital in dataArray) {
        if (hospital&&hospital.patients) {
            for (PatientInfo *patients in hospital.patients) {
                [PatientInfo updateModelWithModel:patients];
            }
        }
    }
    [SVProgressHUD showErrorWithStatus:@"保存完成"];
    //保存刷新
    
}

#pragma mark-私有方法

-(void)dismissKeyBoard{
}


- (void)ViewAnimation:(UIView*)view willHidden:(BOOL)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
    [view setHidden:hidden];
       
        if (hidden==NO) {
            //上移
            selectDataTopView.frame=CGRectMake(tempFrame.origin.x, -150, tempFrame.size.width, tempFrame.size.height);
        }
        else{
            selectDataTopView.frame=tempFrame;
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
    }];
}

#pragma mark-UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identif=@"SettingViewTableViewCell";
    SettingViewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identif];
    if (cell==nil) {
        cell=[[SettingViewTableViewCell alloc]init];
    }
    
    HospitalInfo *hospitalGroup = dataArray[indexPath.section];
    NSArray *patientArray=hospitalGroup.patients;
    PatientInfo *person = patientArray[indexPath.row];
    
    cell.nameLabel.text=person.patientName;
    cell.ageLabel.text=person.patientAge;
    cell.sexLabel.text=person.patientSex;
    if (person.isShown) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;

    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;

    }
   return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HospitalInfo *hospitalGroup =dataArray[section];
    NSArray *people=hospitalGroup.patients;
    
    NSInteger count = hospitalGroup.isOpened ?people.count : 0;
    if (count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HospitalInfo *hospital=[dataArray objectAtIndex:indexPath.section];
    if (hospital&&hospital.patients) {
        PatientInfo *patient=[hospital.patients objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
            cell.accessoryType=UITableViewCellAccessoryNone;
            patient.isShown=NO;
        }
        else{
            cell.accessoryType=UITableViewCellAccessoryCheckmark  ;
            patient.isShown=YES;
        }

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==settingTableView) {
        HeadView *headView = [HeadView headViewWithTableView:tableView];
        
        headView.delegate = self;
        headView.dataGroup = dataArray[section];
        return headView;
    }
    else{
        return nil;
    }
    
}

#pragma mark-HeadViewDelegate

- (void)clickHeadView
{
    [settingTableView reloadData];
}

- (IBAction)dissMissBottomView:(id)sender {
//     [self ViewAnimation:refashRatePicker willHidden:YES];
}

#pragma mark-UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex=%d",(int)buttonIndex);
    NSInteger refashTime=_refashValue;
    if (buttonIndex==0) {
        refashTime=3;
    }
    else if (buttonIndex==1){
        refashTime=5;
    }
    else if (buttonIndex==2){
        refashTime=10;
    }
    else if (buttonIndex==3){
        refashTime=15;
    }
    if (refashTime!=_refashValue) {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setInteger:refashTime forKey:user_refashTime];
        [defaults synchronize];
    }
    _refashValue=refashTime;
    
    [refashButton setTitle:[NSString stringWithFormat:@"%ld秒刷新",refashTime] forState:UIControlStateNormal];
}

#pragma mark-去掉多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark-PickViewControllerDelegate
-(void)complateInRow:(NSIndexPath *)row upValue:(NSString *)upvalue downValue:(NSString *)downValue{
    [alarmSettingView refashInRow:row upValue:upvalue downValue:downValue];
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
    //保存数据
    alarmInfo=info;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:info];
    [defaults setObject:data forKey:user_defaultAlarmSetting];
    [defaults synchronize];
    
    //修改所有病人的设置
    [PersonSettingInfo updateAllModelWithDic:info];
    [SVProgressHUD showErrorWithStatus:@"修改成功"];

}

@end
