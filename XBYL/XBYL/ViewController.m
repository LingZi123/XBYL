//
//  ViewController.m
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "MainTableViewCell.h"
#import "PersonSettingViewController.h"
#import "nstdcomm.h"
#import "PatientInfo.h"
#import "XueyaModel.h"
#import "MulDataModel.h"
#import "HospitalInfo.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "AFNetworking/AFHTTPRequestOperationManager.h"
#import "Helper.h"
#import "HeartRateCurveViewController.h"


@interface ViewController ()<HeartRateCurveViewControllerDelegate>

@end

@implementation ViewController


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIF_patientMessage object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIF_getbpmACK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIF_loginClick object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIF_networkMessage object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotif:) name:NOTIF_loginClick object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotif:) name:NOTIF_patientMessage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotif:) name:NOTIF_getbpmACK object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotif:) name:NOTIF_networkMessage object:nil];
    
    //读取文件填充数据
    if (infoArray==nil) {
        infoArray=[[NSMutableArray alloc]init];
    }
    //读取本地的刷新凭率
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    id tempvalue=[defaults objectForKey:user_refashTime];
    if (tempvalue==0) {
        refashValue=5;
        //保存一个默认值5
        [defaults setInteger:5 forKey:user_refashTime];
        [defaults synchronize];
    }
    else{
        refashValue=[tempvalue integerValue];
    }
   
    //读取病人数据
    [self getPatientInfoList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    appDelegate.appMessageDelegate=self;
    if (appDelegate.loginUserInfo==nil||appDelegate.loginUserInfo.isLoginOut||appDelegate.systemSetting==nil) {
        self.navigationItem.leftBarButtonItem=nil;
       UIAlertView *tipView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录" delegate:self cancelButtonTitle:@"去登陆" otherButtonTitles:nil, nil];
        tipView.tag=101;
        [tipView show];
        return;
    }
    else{
        self.navigationItem.leftBarButtonItem=leftBar;
        if (appDelegate.loginUserInfo) {
            self.navigationItem.title=appDelegate.loginUserInfo.userName;
        }
    }
}

-(void)getPatientInfoList{
    
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSArray *tempArray=[PatientInfo getAllModel];
    if (tempArray) {
        if (tempArray.count<=0) {
            [infoArray removeAllObjects];
        }
        for (PatientInfo *tempinfo in tempArray) {
            BOOL isexist=NO;
            for (PatientInfo *sourceInfo in infoArray) {
                if ([tempinfo.patientNo isEqual:sourceInfo.patientNo]) {
                    sourceInfo.isShown=tempinfo.isShown;
                    sourceInfo.personSetting=tempinfo.personSetting;
                    isexist=true;
                    break;
                }
            }
            if (!isexist) {
                [infoArray addObject:tempinfo];
            }
        }
        
        //            dispatch_async(dispatch_get_main_queue(), ^{
        [_contentTablvView reloadData];
        
        //            });
    }
    else {
        [infoArray removeAllObjects];
    }
    //    });
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (appDelegate.loginUserInfo==nil||appDelegate.loginUserInfo.isLoginOut||appDelegate.systemSetting==nil) {
        return;
    }
//    if (!appDelegate.loginUserInfo.isLoginOut) {
//         [self reConnectTryThree];
//    }
    //开启刷新时间
    if (refashTimer==nil) {
        refashTimer=[NSTimer scheduledTimerWithTimeInterval:refashValue target:self selector:@selector(refashTimerClick:) userInfo:nil repeats:YES];
    }
    [refashTimer setFireDate:[NSDate distantPast]];
    
    if (refashStatusTimer==nil) {
        refashStatusTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refashStatusClick:) userInfo:nil repeats:YES];
    }
    [refashStatusTimer setFireDate:[NSDate distantPast]];
    
   
    
}

-(void)refashStatusClick:(NSTimer *)timer{
    NSArray *tempArray=[infoArray copy];
    for (NSInteger i=0;i<tempArray.count;i++) {
        PatientInfo *info=[tempArray objectAtIndex:i];
        if (info.reciveCount>0) {
            info.reciveCount=0;
            if (info.status) {
                if (info.status.status==patient_status_offline) {
                    info.status.status=patient_status_online;
                    info.isRefash=YES;
                    [self refashTableviewCell:i];
                }
            }
            else{
                info.status=[[PatientStatus alloc]init];
                info.status.status=patient_status_online;
                info.isRefash=YES;
                [self refashTableviewCell:i];
            }
        }
        else{
            if (info.status) {
                if (info.status.status==patient_status_online) {
                    info.status.status=patient_status_offline;
                    info.isRefash=YES;
                    [self refashTableviewCell:i];
                }
                else{
                    info.isRefash=NO;
                }
            }
            else{
                info.status=[[PatientStatus alloc]init];
                info.status.status=patient_status_offline;
                [self refashTableviewCell:i];
            }
        }
    }
}

-(void)refashTableviewCell:(NSInteger)row{
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [_contentTablvView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)refashTimerClick:(NSTimer *)timer{
    if (infoArray.count<=0) {
        nodataView.hidden=NO;
        _contentTablvView.hidden=YES;
    }
    else{
        nodataView.hidden=YES;
        _contentTablvView.hidden=NO;
        [_contentTablvView reloadData];
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    appDelegate.appMessageDelegate=nil;
    //停止时间
    [refashTimer setFireDate:[NSDate distantFuture]];
    refashTimer=nil;
    [refashStatusTimer setFireDate:[NSDate distantFuture]];
    refashStatusTimer=nil;
    
}
-(void)makeView{
     leftBar=[[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
     [leftBar setTintColor:[UIColor whiteColor]];
     rigthBar=[[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
     [rigthBar setTintColor:[UIColor whiteColor]];
    
    reconnectBtn=[[UIBarButtonItem alloc]initWithTitle:@"重连" style:UIBarButtonItemStylePlain target:self action:@selector(reConnect:)];
    [reconnectBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem=leftBar;
    self.navigationItem.rightBarButtonItems=@[rigthBar];

    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    CGSize tempSize=self.navigationItem.titleView.frame.size;
    
    NSLog(@"size width=%f  height=%f",tempSize.width,tempSize.height);
    
    detailTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,20, self.navigationItem.titleView.frame.size.width, 20)];
    detailTextLabel.textColor=[UIColor greenColor];
    detailTextLabel.text=@"在线";
    [self.navigationItem.titleView addSubview:detailTextLabel];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //xib注册
    UINib *xib=[UINib nibWithNibName:@"MainTableViewCell" bundle:nil];
    [_contentTablvView registerNib:xib forCellReuseIdentifier:@"MainTableViewCell"];
    _contentTablvView.delegate=self;
    _contentTablvView.dataSource=self;
    
    [self setExtraCellLineHidden:_contentTablvView];
}
-(void)logout:(id)sender{
    appDelegate.loginUserInfo.isLoginOut=YES;
    [nstdcomm stdcommClose];
    appDelegate.connected=NO;
    appDelegate.logined=NO;
    
    //保存到本地
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *userInfoDic=[NSKeyedArchiver archivedDataWithRootObject:appDelegate.loginUserInfo];
    [defaults setObject:userInfoDic forKey:user_loginUserInfo];
    [defaults synchronize];
    [self goLoginVC];
}

-(void)setting:(id)sender{
    SettingViewController *settingVC=[appDelegate.mainStoryBoard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    settingVC.refashValue=refashValue;
    settingVC.settingviewDelegate=self;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark-UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    PatientInfo *info=[infoArray objectAtIndex:indexPath.row];
    
    NSString *identif=@"MainTableViewCell";
    MainTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identif];
    if (cell==nil) {
        cell=[[MainTableViewCell alloc]init];
    }
    if (info&&info.isShown) {
    cell.nameLabel.text=info.patientName;
    cell.sexLabel.text=info.patientSex;
    cell.ageLabel.text=[NSString stringWithFormat:@"%@岁",info.patientAge];
    cell.identifNoLabel.text=info.patientNo;
    cell.nextNoLabel.text=info.bingchuangNo;
    cell.noLabel.text=info.hosNo;
    cell.onlineImageView.layer.cornerRadius=5.0;
    cell.armBtn.tag=indexPath.row;
    [cell.armBtn addTarget:self action:@selector(armBtnClick:) forControlEvents:UIControlEventTouchUpInside];
       
    if (info.status) {
        if (info.status.status==patient_status_offline) {
            cell.onlineLabel.text=@"离线";
            cell.onlineImageView.backgroundColor=[UIColor grayColor];

        }
        else if (info.status.status==patient_status_online){
            cell.onlineLabel.text=@"在线";
            cell.onlineImageView.backgroundColor=[UIColor greenColor];
        }
        else{
            cell.onlineLabel.text=@"删除";
            cell.onlineImageView.backgroundColor=[UIColor redColor];
        }
    }
    else{
         cell.onlineLabel.text=@"离线";
        cell.onlineImageView.backgroundColor=[UIColor grayColor];
    }
    
    
    cell.typeLabel.text=@"手动测量血压";
    if (info.xueya) {
        cell.xueyaLabel1.text=info.xueya.DBP;
        cell.xueyaLabel2.text=info.xueya.shousuoya;
        cell.mailvLabel.text=info.xueya.mailv;
        
        cell.xueyaLabel1.textColor=[UIColor blackColor];
        cell.xueyaLabel2.textColor=[UIColor blackColor];
        cell.mailvLabel.textColor=[UIColor blackColor];
        
        if (info.personSetting) {
            if ([info.personSetting.shuzhangyadownvalue integerValue]>[info.xueya.DBP integerValue]||[info.xueya.DBP integerValue]>[info.personSetting.shuzhangyaupvalue integerValue]) {
                cell.xueyaLabel1.textColor=[UIColor redColor];
            }
            if ([info.personSetting.shousuoyadownvalue integerValue]>[info.xueya.shousuoya integerValue]||[info.xueya.shousuoya integerValue]>[info.personSetting.shousuoyaupvalue integerValue]) {
                cell.xueyaLabel2.textColor=[UIColor redColor];
            }

            if ([info.personSetting.mailvdownvalue integerValue]>[info.xueya.mailv integerValue]||[info.xueya.mailv integerValue]>[info.personSetting.mailvupvalue integerValue]) {
                cell.mailvLabel.textColor=[UIColor redColor];
            }
        }
        else if (appDelegate.defaultAlarmSetting){
            if ([appDelegate.defaultAlarmSetting.shuzhangyadownvalue integerValue]>[info.xueya.DBP integerValue]||[info.xueya.DBP integerValue]>[appDelegate.defaultAlarmSetting.shuzhangyaupvalue integerValue]) {
                cell.xueyaLabel1.textColor=[UIColor redColor];
            }
            if ([appDelegate.defaultAlarmSetting.shousuoyadownvalue integerValue]>[info.xueya.shousuoya integerValue]||[info.xueya.shousuoya integerValue]>[appDelegate.defaultAlarmSetting.shousuoyaupvalue integerValue]) {
                cell.xueyaLabel2.textColor=[UIColor redColor];
            }
            
            if ([appDelegate.defaultAlarmSetting.mailvdownvalue integerValue]>[info.xueya.mailv integerValue]||[info.xueya.mailv integerValue]>[appDelegate.defaultAlarmSetting.mailvupvalue integerValue]) {
                cell.mailvLabel.textColor=[UIColor redColor];
            }
        }
        else{
            if (Default_Shuzhangye_Down>[info.xueya.DBP integerValue]||[info.xueya.DBP integerValue]>Default_Shuzhangye_Up) {
                cell.xueyaLabel1.textColor=[UIColor redColor];
            }
            if (Default_Shousuoya_Down>[info.xueya.shousuoya integerValue]||[info.xueya.shousuoya integerValue]>Default_Shousuoya_Up) {
                cell.xueyaLabel2.textColor=[UIColor redColor];
            }

            if (Default_Xinlv_Down>[info.xueya.mailv integerValue]||[info.xueya.mailv integerValue]>Default_Xinlv_Up) {
                cell.mailvLabel.textColor=[UIColor redColor];
            }

        }
    }
    if (info.mulData) {
        cell.xinlvLabel.text=info.mulData.xinlv;
        cell.xueyangLabel.text=info.mulData.xueyang;
        cell.xinlvLabel.textColor=[UIColor blackColor];
        cell.xueyangLabel.textColor=[UIColor blackColor];
        
        cell.huxiLabel.text=info.mulData.resp;
        cell.huxiLabel.textColor=[UIColor blackColor];
        
        cell.mailvLabel.text=info.mulData.mailv;
        cell.mailvLabel.textColor=[UIColor blackColor];
        if (info.personSetting) {
            if ([info.personSetting.xinlvdownvalue integerValue]>[info.mulData.xinlv integerValue]||[info.mulData.xinlv integerValue]>[info.personSetting.xinlvupvalue integerValue]) {
                cell.xinlvLabel.textColor=[UIColor redColor];
            }
            if ([info.personSetting.xueyangdownvalue integerValue]>[info.mulData.xueyang integerValue]||[info.mulData.xueyang integerValue]>[info.personSetting.xueyangupvalue integerValue]) {
                cell.xueyangLabel.textColor=[UIColor redColor];
            }
            if ([info.personSetting.huxidownvalue integerValue]>[info.mulData.resp integerValue]||[info.mulData.resp integerValue]>[info.personSetting.huxiupvalue integerValue]) {
                cell.huxiLabel.textColor=[UIColor redColor];
            }
            if ([info.personSetting.mailvdownvalue integerValue]>[info.mulData.mailv integerValue]||[info.mulData.mailv integerValue]>[info.personSetting.mailvupvalue integerValue]) {
                cell.mailvLabel.textColor=[UIColor redColor];
            }
        }
        else if (appDelegate.defaultAlarmSetting){
            if ([appDelegate.defaultAlarmSetting.xinlvdownvalue integerValue]>[info.mulData.xinlv integerValue]||[info.mulData.xinlv integerValue]>[appDelegate.defaultAlarmSetting.xinlvupvalue integerValue]) {
                cell.xinlvLabel.textColor=[UIColor redColor];
            }
            if ([appDelegate.defaultAlarmSetting.xueyangdownvalue integerValue]>[info.mulData.xueyang integerValue]||[info.mulData.xueyang integerValue]>[appDelegate.defaultAlarmSetting.xueyangupvalue integerValue]) {
                cell.xueyangLabel.textColor=[UIColor redColor];
            }
            if ([appDelegate.defaultAlarmSetting.huxidownvalue integerValue]>[info.mulData.resp integerValue]||[info.mulData.resp integerValue]>[appDelegate.defaultAlarmSetting.huxiupvalue integerValue]) {
                cell.huxiLabel.textColor=[UIColor redColor];
            }
            if ([appDelegate.defaultAlarmSetting.mailvdownvalue integerValue]>[info.mulData.mailv integerValue]||[info.mulData.mailv integerValue]>[appDelegate.defaultAlarmSetting.mailvupvalue integerValue]) {
                cell.mailvLabel.textColor=[UIColor redColor];
            }
        }
        else{
            if (Default_Xinlv_Down>[info.mulData.xinlv integerValue]||[info.mulData.xinlv integerValue]>Default_Xinlv_Up) {
                cell.xinlvLabel.textColor=[UIColor redColor];
            }
            if (Default_Xueyang_Down>[info.mulData.xueyang integerValue]||[info.mulData.xueyang integerValue]>Default_Xueyang_Up) {
                cell.xueyangLabel.textColor=[UIColor redColor];
            }
            if (Default_Huxi_Down>[info.mulData.resp integerValue]||[info.mulData.resp integerValue]>Default_Huxi_Up) {
                cell.huxiLabel.textColor=[UIColor redColor];
            }
            if (Default_Mailv_Down>[info.mulData.mailv integerValue]||[info.mulData.mailv integerValue]>Default_Mailv_Up) {
                cell.mailvLabel.textColor=[UIColor redColor];
            }
        }
    }

    cell.accessoryType=UITableViewCellAccessoryDetailButton;
    }
    else{
        cell.hidden=YES;
    }
   
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (infoArray) {
         return infoArray.count;
    }
    else{
        return 0;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     PatientInfo *info=[infoArray objectAtIndex:indexPath.row];
    if(info&&info.isShown){
    return 140;
    }
    else{
        return 0;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PatientInfo *info=[infoArray objectAtIndex:indexPath.row];
    HeartRateCurveViewController *vc=[[HeartRateCurveViewController alloc]initWithNibName:@"HeartRateCurveViewController" bundle:[NSBundle mainBundle]];
    vc.patientInfo=info;
    vc.delegate=self;
    [self presentViewController:vc animated:YES completion:nil];
    
    

}
-(void)personSetting:(UIButton *)sender{
    
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    PatientInfo *patient=[infoArray objectAtIndex:indexPath.row];
    PersonSettingViewController *p=[[PersonSettingViewController alloc]init];
    p.patient=patient;
    [self.navigationController pushViewController:p animated:YES];
}
- (void)reConnect:(id)sender {
    
   [SVProgressHUD showWithStatus:@"正在重接" maskType:SVProgressHUDMaskTypeNone];
    
    if (!appDelegate.connected&&appDelegate.systemSetting) {
        appDelegate.connected=[nstdcomm stdcommConnect:appDelegate.systemSetting.ip andPort:[appDelegate.systemSetting.port intValue]  andWebPort:WebPort_Default andTermPort:TermPort_Default andLoginType:LoginType_Default]==1;
        if (!appDelegate.connected) {
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
        }
    }
    if (appDelegate.connected) {
       
        if (appDelegate.loginUserInfo&&!appDelegate.logined) {
            //只有登陆才能收到数据
            [nstdcomm stdcommLogin:appDelegate.loginUserInfo.userName andPwd:appDelegate.loginUserInfo.pwd];
        }
    }
}

#pragma mark-appMessageDelegate

-(void) patientMessage:(NSString *)cmd andMsg:(NSString *)msg{
}

-(void)existPatient:(PatientInfo *)patient{
 
    BOOL isExist=NO;
    NSArray *tempArray=[infoArray copy];
    for (PatientInfo *info in tempArray) {
        if ([info.patientNo isEqualToString:patient.patientNo]) {
            //修改
            if (info.status==nil) {
                info.status=[[PatientStatus alloc]init];
            }
            info.status.status=patient_status_online;
            isExist=YES;
            break;
        }
    }
    if (isExist==NO) {
        [infoArray addObject:patient];
        //并存入数据库
        [PatientInfo InsertModelWithModel:patient];
    }
}

-(void)updateMulData:(MulDataModel *)model{
    for (int i=0;i<infoArray.count;i++) {
        PatientInfo *info=[infoArray objectAtIndex:i];
        
        if ([info.terminNo isEqualToString:model.terminNo]) {
            //修改
            info.reciveCount+=1;
            if (info.mulData) {
                if (![info.mulData.xueyang isEqualToString:model.xueyang]) {
                    info.mulData.xueyang=model.xueyang;
                    info.isRefash=YES;
                }
                if (![info.mulData.xinlv isEqualToString:model.xinlv]) {
                    info.mulData.xinlv=model.xinlv;
                    info.isRefash=YES;
                }
            }
            else{
                info.mulData=model;
                info.isRefash=YES;
            }
            if (info.status) {
                if (info.status.status==patient_status_offline) {
                    info.status.status=patient_status_online;
                    info.isRefash=YES;
                }
            }
            else{
                info.status=[[PatientStatus alloc]init];
                info.status.patientNo=info.patientNo;
                info.status.status=patient_status_online;
                info.isRefash=YES;
            }
        }
    }
}
-(void)updateXueya:(XueyaModel *)model{
    
    for (int i=0;i<infoArray.count;i++) {
        PatientInfo *info=[infoArray objectAtIndex:i];
        if ([info.patientNo isEqualToString:model.patientNo]) {
             info.reciveCount+=1;
            //修改
            if (info.xueya) {
               
                if (![info.xueya.shousuoya isEqualToString:model.shousuoya]) {
                    info.xueya.shousuoya=model.shousuoya;
                    info.isRefash=YES;
                }
                if (![info.xueya.DBP isEqualToString:model.DBP]) {
                    info.xueya.DBP=model.DBP;
                    info.isRefash=YES;
                }
                if (![info.xueya.mailv isEqualToString:model.mailv]) {
                    info.xueya.mailv=model.mailv;
                    info.isRefash=YES;
                }
            }
            else{
                info.xueya=model;
                info.isRefash=YES;
            }
            if (info.status) {
                if (info.status.status==patient_status_offline) {
                    info.status.status=patient_status_online;
                }
            }
            else{
                info.status=[[PatientStatus alloc]init];
                info.status.patientNo=info.patientNo;
                info.status.status=patient_status_online;
               
            }
             info.isRefash=YES;
            break;
        }
    }
}


-(void)updateStatus:(PatientStatus *)model{
    
    for (int i=0;i<infoArray.count;i++) {
        PatientInfo *info=[infoArray objectAtIndex:i];
        if ([info.patientNo isEqualToString:model.patientNo]) {
            //修改
            if (info.status) {
                if (info.status.status!=model.status) {
                    info.status.status=model.status;
                    info.isRefash=YES;
                    [self refashTableviewCell:i];
                }
            }
            else{
                info.status=model;
                info.isRefash=YES;
                [self refashTableviewCell:i];
            }
            break;
        }
    }
}

-(void)refashTableViewCell:(NSInteger) row{
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [_contentTablvView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
  
}

#pragma mark-事件
//铃铛发送远程测试血压事件
-(void)armBtnClick:(UIButton *)btn{
    PatientInfo *info=[infoArray objectAtIndex:btn.tag];
    if (info==nil) {
        return;
    }
    selectedModel=info;
    //弹出框
    UIAlertView *armShow=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要远程测量血压?(血压计未正常连接时无法回应)" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    armShow.tag=102;
    [armShow show];
}

#pragma mark-SettingViewControllerDelegate
-(void)complateSetting:(NSInteger)refashTime dataArray:(NSMutableArray *)dataArray{
    refashValue=refashTime;
    if (dataArray) {
        for (HospitalInfo *hos in dataArray) {
            for (PatientInfo *pat in hos.patients) {
                BOOL isExist=NO;
                for (PatientInfo *thepat in infoArray) {
                    if ([thepat.patientNo isEqualToString:pat.patientNo]){
                        isExist=YES;
                        if (!pat.isShown) {
                            [infoArray removeObject:thepat];
                            break;

                        }
                    }
                }
                if (!isExist) {
                    if (pat.isShown) {
                        [infoArray addObject:pat];
                    }
                }
            }
        }
    }
    
    [_contentTablvView reloadData];
    
}

#pragma mark-appMessgeDelegate
-(void)patientMessage:(NSString *)mes{
    
}

-(void)logingMessage:(NSString *)mes{
    [SVProgressHUD dismiss];
    if ([mes isEqualToString:@"success"]) {
        //重新获取患者数据
        [self getPatientInfoList];
        if(self.navigationItem.rightBarButtonItems.count>1){
            self.navigationItem.rightBarButtonItems=@[rigthBar];//连接成功后要消失
            self.navigationItem.title=[NSString stringWithFormat:@"%@  在线",appDelegate.loginUserInfo.userName];
        }
        appDelegate.logined=YES;
        [nstdcomm stdcommRefreshHosList];
        [nstdcomm stdcommRefreshPatList];
        if (istryConnect) {
            istryConnect=NO;
        }
    }
    else{
        appDelegate.logined=NO;
    }
}

-(void)networkMessage:(NSString *)mes{
    
}

-(void)reConnectTryThree{
    reconnectCount=0;
    while (reconnectCount<3) {
        if (appDelegate.systemSetting&&!appDelegate.connected) {
            int connectResult=[nstdcomm stdcommConnect:appDelegate.systemSetting.ip andPort:[appDelegate.systemSetting.port intValue] andWebPort:WebPort_Default  andTermPort:TermPort_Default andLoginType:LoginType_Default];
            
            appDelegate.connected=connectResult==1;
        }
        if (appDelegate.connected) {
            if (appDelegate.loginUserInfo&&!appDelegate.logined) {
                NSLog(@"登录");
                int loginResult=  [nstdcomm stdcommLogin:appDelegate.loginUserInfo.userName andPwd:appDelegate.loginUserInfo.pwd];
//                appDelegate.logined=loginResult==1;
                if (appDelegate.logined) {
                    self.navigationItem.title=[NSString stringWithFormat:@"%@  在线",appDelegate.loginUserInfo.userName];
                    break;
                }
            }
            else{
                self.navigationItem.title=[NSString stringWithFormat:@"%@  在线",appDelegate.loginUserInfo.userName];
                break;
            }
        }
        
        [NSThread sleepForTimeInterval:1];
        reconnectCount+=1;
        
    }
    if (reconnectCount>=3) {
        self.navigationItem.rightBarButtonItems=@[rigthBar,reconnectBtn];
        
        
    }
    else{
        self.navigationItem.rightBarButtonItems=@[rigthBar];
    }
    reconnectCount=0;
}

#pragma mark-UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==101) {
        //进入登录界面
        [self goLoginVC];
    }
    else{
        if (buttonIndex==1) {
            
//            //发送远程测试血压
//            AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
//            NSString *url= [NSString stringWithFormat:@"%@%@account=%@&pwd=%@&termid=%@",appDelegate.systemSetting.webPort,arm_url,appDelegate.loginUserInfo.userName,appDelegate.loginUserInfo.pwd,selectedModel.terminNo];
//            manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                //要改的
//                NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//                if ([str isEqualToString:@"SUCCESS"]) {
//                    [SVProgressHUD showErrorWithStatus:@"发送成功"];
//                }
//                else{
//                    [SVProgressHUD showErrorWithStatus:@"发送失败"];
//                }
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [SVProgressHUD showErrorWithStatus:@"发送失败"];
//            }];
            
            [nstdcomm stdcommGetPatBPM:selectedModel.patientNo andTermid:[selectedModel.terminNo integerValue]];
        }
    }
   
}

-(void)goLoginVC{
        LoginViewController *loginVC=[appDelegate.mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark-隐藏分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark-HeartRateCurveViewControllerDelegate
-(void)closeHeartRateViewController{
     [nstdcomm stdSetTremId:0];
}

-(void)reciveNotif:(NSNotification *)sender{
    if ([sender.name isEqualToString:NOTIF_loginClick]) {
        //重新获取患者数据
        [self getPatientInfoList];
        if(self.navigationItem.rightBarButtonItems.count>1){
            self.navigationItem.rightBarButtonItems=@[rigthBar];//连接成功后要消失
            self.navigationItem.title=[NSString stringWithFormat:@"%@  在线",appDelegate.loginUserInfo.userName];
        }
        appDelegate.logined=YES;
        [nstdcomm stdcommRefreshHosList];
        [nstdcomm stdcommRefreshPatList];
        if (istryConnect) {
            istryConnect=NO;
        }

    }
    else if ([sender.name isEqualToString:NOTIF_patientMessage]){
        NSDictionary *dic=sender.object;
        NSString *cmd=[dic objectForKey:@"cmd"];
        NSString *msg=[dic objectForKey:@"msg"];
        
        //刷新病人列表
        if ([cmd isEqualToString:@"patientinfoACK"]) {
            if (![msg isEqualToString:@"fail"]) {
                PatientInfo *tempPatient=[PatientInfo getModelWithString:msg];
                tempPatient.reciveCount+=1;
                if (tempPatient) {
                    [self existPatient:tempPatient];
                }
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (!nodataView.hidden) {
                    _contentTablvView.hidden=NO;
                    nodataView.hidden=YES;
                }
                [_contentTablvView reloadData];
            });
        }
        else if ([cmd isEqualToString:@"bpmdataACK"]){
            //改变血压通知
            XueyaModel *model=[XueyaModel getModelWithString:msg];
            [self updateXueya:model];
        }
        else if ([cmd isEqualToString:@"updateinfoACK"]){
            //病员信息改变通知
            PatientInfo *tempPatient=[PatientInfo getModelWithString:msg];
            tempPatient.reciveCount+=1;
            if (tempPatient) {
                [self existPatient:tempPatient];
            }
            [_contentTablvView reloadData];
            
        }
        else if ([cmd isEqualToString:@"updateonlinestatusACK"]){
            //病员在线状态改变通知
            PatientStatus *status=[PatientStatus getModelWithString:msg];
            [self updateStatus:status];
            
        }
        else if ([cmd isEqualToString:@"bodataACK"]){
            //多参数数据到达通知
            MulDataModel *model=[MulDataModel getModelWithString:msg];
            [self updateMulData:model];
            
        }
    }
    else if ([sender.name isEqualToString:NOTIF_getbpmACK]){

        NSString *msg=sender.object;
        XueyaModel *model=[XueyaModel getModelWithStringByTest:msg];
        [self updateXueya:model];
    }
    else if([sender.name isEqualToString:NOTIF_networkMessage]){
        NSString *mes=sender.object;
        dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD showErrorWithStatus:mes];
        });
        if (![mes isEqualToString:@"已恢复网络"]) {
            appDelegate.connected=NO;
            appDelegate.logined=NO;
            
             dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.title=[NSString stringWithFormat:@"%@  离线",appDelegate.loginUserInfo.userName];
             });
            //开启自动重连3次
            //3次链接不上再显示
            istryConnect=YES;
            [self reConnectTryThree];
        }
        else{
            if (appDelegate.loginUserInfo&&!appDelegate.loginUserInfo.isLoginOut) {
                [self reConnectTryThree];
            }
            else{
                
            }
            
        }
    }
}
@end
