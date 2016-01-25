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
    //从本地数据库读取数据
    [self setExtraCellLineHidden:settingTableView];
    [self setExtraCellLineHidden:armTableView];
    
    //开启接收数据
//    [nstdcomm stdRegMessageBox:self andSelect:@selector(stdMessageBox:andMsg:)];
//    [nstdcomm stdcommRefreshHosList];
}

-(void)viewWillDisappear:(BOOL)animated{
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
    refashSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"3秒",@"5秒",@"10秒",@"15秒", nil];
    refashSheet.hidden=YES;
    [refashButton setTitle:[NSString stringWithFormat:@"%ld秒刷新",_refashValue] forState:UIControlStateNormal];
    
    //填充报警参数值
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (alarmDic==nil) {
        alarmDic=[[NSMutableDictionary alloc]initWithDictionary:[defaults objectForKey:user_defaultAlarmSetting]];
    }
    if (alarmDic) {
        shousuoUpValue=[[alarmDic objectForKey:def_shousuoUpValue]integerValue];
        shuzhangUpValue=[[alarmDic objectForKey:def_shuzhangUpValue]integerValue];
        xueyangUpValue=[[alarmDic objectForKey:def_xueyangUpValue]integerValue];
        xinlvUpValue=[[alarmDic objectForKey:def_xinlvUpValue]integerValue];
        mailvUpValue=[[alarmDic objectForKey:def_mailvUpValue]integerValue];
        huxiUpValue=[[alarmDic objectForKey:def_huxiUpValue]integerValue];
        xinlvDownValue=[[alarmDic objectForKey:def_xinlvDownValue]integerValue];
        mailvDownValue=[[alarmDic objectForKey:def_mailvDownValue]integerValue];
        huxiDownValue=[[alarmDic objectForKey:def_huxiDownValue]integerValue];
        xueyangDownValue=[[alarmDic objectForKey:def_xueyangDownValue]integerValue];
        shousuoDownValue=[[alarmDic objectForKey:def_shousuoDownValue]integerValue];
        shuzhangDownValue=[[alarmDic objectForKey:def_shuzhangDownValue]integerValue];
    }
    else{
        [self defuaultAlarmDic];
    }
    
    [self fullAlarmArray];
    
}

-(void)defuaultAlarmDic{
    shousuoUpValue=Default_Shousuoya_Up;
    shuzhangUpValue=Default_Shuzhangye_Up;
    xueyangUpValue=Default_Xueyang_Up;
    xinlvUpValue=Default_Xinlv_Up;
    mailvUpValue=Default_Mailv_Up;
    huxiUpValue=Default_Huxi_Up;
    xinlvDownValue=Default_Xinlv_Down;
    mailvDownValue=Default_Mailv_Down;
    huxiDownValue=Default_Huxi_Down;
    xueyangDownValue=Default_Xueyang_Down;
    shousuoDownValue=Default_Shousuoya_Down;
    shuzhangDownValue=Default_Shuzhangye_Down;
    alarmDic=[[NSMutableDictionary alloc]init];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",shousuoUpValue] forKey:def_shousuoUpValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",shuzhangUpValue] forKey:def_shuzhangUpValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",xueyangUpValue] forKey:def_xueyangUpValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",xinlvUpValue] forKey:def_xinlvUpValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",mailvUpValue] forKey:def_mailvUpValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",huxiUpValue] forKey:def_huxiUpValue];
    
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",xinlvDownValue] forKey:def_xinlvDownValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",mailvDownValue] forKey:def_mailvDownValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",huxiDownValue] forKey:def_huxiDownValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",xueyangDownValue] forKey:def_xueyangDownValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",shousuoDownValue] forKey:def_shousuoDownValue];
    [alarmDic setObject:[NSString stringWithFormat:@"%ld",shuzhangDownValue] forKey:def_shuzhangDownValue];

}

-(void)fullAlarmArray{
    if (alarmArray) {
        [alarmArray removeAllObjects];
    }
    else{
        alarmArray=[[NSMutableArray alloc]init];
    }
    NSMutableDictionary *dic1=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"收缩压",@"title",[NSString stringWithFormat:@"%ld",shousuoDownValue],@"downValue",[NSString stringWithFormat:@"%ld",shousuoUpValue],@"upValue", nil];
    NSMutableDictionary *dic2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"舒张压",@"title",[NSString stringWithFormat:@"%ld",shuzhangDownValue],@"downValue",[NSString stringWithFormat:@"%ld",shuzhangUpValue],@"upValue", nil];
    NSMutableDictionary *dic3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"血氧",@"title",[NSString stringWithFormat:@"%ld",xueyangDownValue],@"downValue",[NSString stringWithFormat:@"%ld",xueyangUpValue],@"upValue", nil];
    NSMutableDictionary *dic4=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"心率",@"title",[NSString stringWithFormat:@"%ld",xinlvDownValue],@"downValue",[NSString stringWithFormat:@"%ld",xinlvUpValue],@"upValue", nil];
    NSMutableDictionary *dic5=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"脉率",@"title",[NSString stringWithFormat:@"%ld",mailvDownValue],@"downValue",[NSString stringWithFormat:@"%ld",mailvUpValue],@"upValue", nil];
    NSMutableDictionary *dic6=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"呼吸",@"title",[NSString stringWithFormat:@"%ld",huxiDownValue],@"downValue",[NSString stringWithFormat:@"%ld",huxiUpValue],@"upValue", nil];
    
    [alarmArray addObject:dic1];
    [alarmArray addObject:dic2];
    [alarmArray addObject:dic3];
    [alarmArray addObject:dic4];
    [alarmArray addObject:dic5];
    [alarmArray addObject:dic6];
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
        [self fullAlarmArray];
        [armTableView reloadData];
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
        [armTableView reloadData];
    }
}

- (IBAction)saveAlarmSetting:(id)sender {
    //保存数据
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:alarmDic forKey:user_defaultAlarmSetting];
    [defaults synchronize];
    
    //修改所有病人的设置
    [PersonSettingInfo updateAllModelWithDic:alarmDic];
    [SVProgressHUD showErrorWithStatus:@"修改成功"];
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
    if (tableView==settingTableView) {
        return dataArray.count;
    }
    else{
        return 1;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==settingTableView) {
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
    else{
        NSString *identif=@"alarmTableViewCell";
        UITableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:identif];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identif];
        }
        NSDictionary *dic=[alarmArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[dic objectForKey:@"title"];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld~%ld",[[dic objectForKey:@"downValue"]integerValue],[[dic objectForKey:@"upValue"]integerValue]] ;
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==settingTableView) {
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
    else{
        return alarmArray.count;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==settingTableView) {
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
    else{
        
        AlarmPickView *alarmpickview=[AlarmPickView defaultPopupView];
        alarmpickview.parentVC = self;
        alarmpickview.delegate=self;
//        AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//        PickViewController *vc=[appdelegate.mainStoryBoard instantiateViewControllerWithIdentifier:@"PickViewController"];
        alarmpickview.selectRow=indexPath;
        NSMutableArray *upArray=[[NSMutableArray alloc]init];
        NSMutableArray *downArray=[[NSMutableArray alloc]init];
        for (int i=1; i<300; i++) {
            NSString *a=[NSString stringWithFormat:@"%d",i];
            [upArray addObject:a];
            [downArray addObject:a];
            
        }
        NSMutableDictionary *data=[alarmArray objectAtIndex:indexPath.row];
        alarmpickview.titleValue=[data objectForKey:@"title"];
        alarmpickview.updataArray=upArray;
        alarmpickview.downDataArray=downArray;
        alarmpickview.upValue=[data objectForKey:@"upValue"];
        alarmpickview.downValue=[data objectForKey:@"downValue"];
        [alarmpickview makeView];
        [self lew_presentPopupView:alarmpickview animation:[LewPopupViewAnimationSpring new] dismissed:^{
            NSLog(@"动画结束");
        }];
//        [self.navigationController pushViewController:vc animated:YES];
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
    NSMutableDictionary *dic=[alarmArray objectAtIndex:row.row];
    [dic setObject:upvalue forKey:@"upValue"];
    [dic setObject:downValue forKey:@"downValue"];

    if (alarmDic==nil) {
        alarmDic=[[NSMutableDictionary alloc]init];
    }
    if (row.row==0) {
        shousuoDownValue=[downValue integerValue];
        shousuoUpValue=[upvalue integerValue];
        [alarmDic setObject:downValue forKey:def_shousuoDownValue];
        [alarmDic setObject:upvalue forKey:def_shousuoUpValue];
    }
    else if (row.row==1){
        shuzhangDownValue=[downValue integerValue];
        shuzhangUpValue=[upvalue integerValue];
        [alarmDic setObject:downValue forKey:def_shuzhangDownValue];
        [alarmDic setObject:upvalue forKey:def_shuzhangUpValue];
    }
    else if (row.row==2){
        xueyangDownValue=[downValue integerValue];
        xueyangUpValue=[upvalue integerValue];
        [alarmDic setObject:downValue forKey:def_xueyangDownValue];
        [alarmDic setObject:upvalue forKey:def_xueyangUpValue];
    }
    else if (row.row==3){
        xinlvDownValue=[downValue integerValue];
        xinlvUpValue=[upvalue integerValue];
        [alarmDic setObject:downValue forKey:def_xinlvDownValue];
        [alarmDic setObject:upvalue forKey:def_xinlvUpValue];
    }
    else if (row.row==4){
        mailvDownValue=[downValue integerValue];
        mailvUpValue=[upvalue integerValue];
        [alarmDic setObject:downValue forKey:def_mailvDownValue];
        [alarmDic setObject:upvalue forKey:def_mailvUpValue];
    }
    else if (row.row==5){
        huxiDownValue=[downValue integerValue];
        huxiUpValue=[upvalue integerValue];
        [alarmDic setObject:downValue forKey:def_huxiDownValue];
        [alarmDic setObject:upvalue forKey:def_huxiUpValue];
    }
    //刷新
    [armTableView reloadRowsAtIndexPaths:[[NSArray alloc]initWithObjects:row, nil] withRowAnimation:UITableViewRowAnimationNone];
}


@end
