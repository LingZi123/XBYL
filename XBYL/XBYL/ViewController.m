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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    
    //读取文件填充数据
    if (infoArray==nil) {
        infoArray=[[NSMutableArray alloc]init];
    }
//    if (showArray==nil) {
//        showArray=[[NSMutableArray alloc]init];
//    }
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
    
    if (appDelegate.systemSetting) {
        int a=[nstdcomm stdcommConnect:appDelegate.systemSetting.ip andPort:appDelegate.systemSetting.port andWebPort:appDelegate.systemSetting.webPort andTermPort:TermPort_Default andLoginType:LoginType_Default];
        NSLog(@"a=%d",a);

        if (appDelegate.loginUserInfo) {
             int b=  [nstdcomm stdcommLogin:appDelegate.loginUserInfo.userName andPwd:appDelegate.loginUserInfo.pwd];
            NSLog(@"b=%d",b);
        }
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (appDelegate.loginUserInfo==nil||appDelegate.loginUserInfo.isLoginOut||appDelegate.systemSetting==nil) {
        self.navigationItem.leftBarButtonItem=nil;
       UIAlertView *tipView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录" delegate:self cancelButtonTitle:@"去登陆" otherButtonTitles:nil, nil];
        [tipView show];
    }
    else{
        self.navigationItem.leftBarButtonItem=leftBar;
        if (appDelegate.loginUserInfo) {
            loginNameLabel.text=appDelegate.loginUserInfo.userName;
            reconnectBtn.hidden=YES;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
     appDelegate.appMessageDelegate=self;
    //从本地数据库读取数据
//    [infoArray removeAllObjects];
//    [showArray removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *tempArray=[PatientInfo getAllModel];
        if (tempArray) {
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_contentTablvView reloadData];

            });
        }
    });
    
    [nstdcomm stdcommRefreshHosList];
    [nstdcomm stdcommRefreshPatList];
    //开启刷新时间
    if (refashTimer==nil) {
        refashTimer=[NSTimer scheduledTimerWithTimeInterval:refashValue target:self selector:@selector(refashTimerClick:) userInfo:nil repeats:YES];
    }
    [refashTimer setFireDate:[NSDate distantPast]];
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
    //停止时间
    [refashTimer setFireDate:[NSDate distantFuture]];
    refashTimer=nil;
    
}
-(void)makeView{
     leftBar=[[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
     [leftBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *rightBar2=[[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
     [rightBar2 setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem=leftBar;
    self.navigationItem.rightBarButtonItem=rightBar2;
    
    self.navigationItem.title=@"重庆新标医疗设备有限公司";
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
    appDelegate.appMessageDelegate=self;
    
    //xib注册
    UINib *xib=[UINib nibWithNibName:@"MainTableViewCell" bundle:nil];
    [_contentTablvView registerNib:xib forCellReuseIdentifier:@"MainTableViewCell"];
    _contentTablvView.delegate=self;
    _contentTablvView.dataSource=self;
    
    [self setExtraCellLineHidden:_contentTablvView];
}
-(void)logout:(id)sender{
    appDelegate.loginUserInfo.isLoginOut=YES;
    //保存到本地
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic=[LoginUserInfo getDicWithModel:appDelegate.loginUserInfo];
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
        if (info.status.status==0) {
            cell.onlineLabel.text=@"离线";
            cell.onlineImageView.backgroundColor=[UIColor grayColor];

        }
        else if (info.status.status==1){
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
        if (info.personSetting) {
            if ([info.personSetting.xinlvdownvalue integerValue]>[info.mulData.xinlv integerValue]||[info.mulData.xinlv integerValue]>[info.personSetting.xinlvupvalue integerValue]) {
                cell.xinlvLabel.textColor=[UIColor redColor];
            }
            if ([info.personSetting.xueyangdownvalue integerValue]>[info.mulData.xueyang integerValue]||[info.mulData.xueyang integerValue]>[info.personSetting.xueyangupvalue integerValue]) {
                cell.xueyangLabel.textColor=[UIColor redColor];
            }
        }
        else{
            if (Default_Xinlv_Down>[info.mulData.xinlv integerValue]||[info.mulData.xinlv integerValue]>Default_Xinlv_Up) {
                cell.xinlvLabel.textColor=[UIColor redColor];
            }
            if (Default_Xueyang_Down>[info.mulData.xueyang integerValue]||[info.mulData.xueyang integerValue]>Default_Xueyang_Up) {
                cell.xueyangLabel.textColor=[UIColor redColor];
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
    NSInteger count=0;
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

-(void)personSetting:(UIButton *)sender{
    
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    PatientInfo *patient=[infoArray objectAtIndex:indexPath.row];
    PersonSettingViewController *p=[[PersonSettingViewController alloc]init];
    p.patient=patient;
    [self.navigationController pushViewController:p animated:YES];
}
- (IBAction)reConnect:(id)sender {
    
    [nstdcomm stdcommClose];
    [nstdcomm stdcommEnd];
    [nstdcomm stdcommStart];
    [appDelegate reciveData];
    
    if (appDelegate.systemSetting) {
        [nstdcomm stdcommConnect:appDelegate.systemSetting.ip andPort:appDelegate.systemSetting.port andWebPort:appDelegate.systemSetting.webPort andTermPort:TermPort_Default andLoginType:LoginType_Default];
    }
    //只有登陆才能收到数据
    [nstdcomm stdcommLogin:appDelegate.loginUserInfo.userName andPwd:appDelegate.loginUserInfo.pwd];
}

#pragma mark-回调函数

//-(void)stdMessageBox:(NSString*)cmd andMsg:(NSString*)msg{
#pragma mark-appMessageDelegate

-(void) patientMessage:(NSString *)cmd andMsg:(NSString *)msg{
    //登录界面只接受登陆返回的信息
    NSLog(@"msg=%@,cmd=%@",msg,cmd);
    //刷新病人列表
    if ([cmd isEqualToString:@"patientinfoACK"]) {
        if (![msg isEqualToString:@"fail"]) {
            PatientInfo *tempPatient=[PatientInfo getModelWithString:msg];
            if (tempPatient) {
                [self existPatient:tempPatient];
            }
        }
        [_contentTablvView reloadData];
        
    }
    else if ([cmd isEqualToString:@"bpmdataACK"]){
        //改变血压通知
        XueyaModel *model=[XueyaModel getModelWithString:msg];
        [self updateXueya:model];
    }
    else if ([cmd isEqualToString:@"updateinfoACK"]){
        //病员信息改变通知
        PatientInfo *tempPatient=[PatientInfo getModelWithString:msg];
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

-(void)existPatient:(PatientInfo *)patient{
 
    BOOL isExist=NO;
    NSArray *tempArray=[infoArray copy];
    for (PatientInfo *info in tempArray) {
        if ([info.patientNo isEqualToString:patient.patientNo]) {
            //修改
            if (info.status==nil) {
                info.status=[[PatientStatus alloc]init];
                info.status.status=1;
            }
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
        }
    }
}
-(void)updateXueya:(XueyaModel *)model{
    
    for (int i=0;i<infoArray.count;i++) {
        PatientInfo *info=[infoArray objectAtIndex:i];
        if ([info.patientNo isEqualToString:model.patientNo]) {
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
                }
            }
            else{
                info.status=model;
                info.isRefash=YES;
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
-(void)armBtnClick:(UIButton *)btn{
    PatientInfo *info=[infoArray objectAtIndex:btn.tag];
    if (info==nil) {
        return;
    }
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSString *url= [NSString stringWithFormat:@"%@account=%@&pwd=%@&termid=%@",arm_url,appDelegate.loginUserInfo.userName,appDelegate.loginUserInfo.pwd,info.terminNo];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //要改的
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"SUCCESS"]) {
            [SVProgressHUD showErrorWithStatus:@"发送成功"];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
   
}

#pragma mark-SettingViewControllerDelegate
-(void)complateSetting:(NSInteger)refashTime dataArray:(NSMutableArray *)dataArray{
    refashValue=refashTime;
//    if (dataArray) {
//        for (HospitalInfo *hos in dataArray) {
//            for (PatientInfo *pat in hos.patients) {
//                for (PatientInfo *thepat in infoArray) {
//                    if ([thepat.patientNo isEqualToString:pat.patientNo]&&!pat.isShown) {
//                        [infoArray removeObject:thepat];
//                        break;
//                    }
//                }
//            }
//        }
//    }
    
}

#pragma mark-appMessgeDelegate
-(void)patientMessage:(NSString *)mes{
    
}

-(void)logingMessage:(NSString *)mes{
    
}

-(void)networkMessage:(NSString *)mes{
    reconnectBtn.hidden=NO;
}


#pragma mark-UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //进入登录界面
    
    [self goLoginVC];
}

-(void)goLoginVC{
//    dispatch_async(dispatch_get_main_queue(), ^{
        LoginViewController *loginVC=[appDelegate.mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [loginVC loginSucess:^(LoginUserInfo *tempUserInfo) {
//            [loginVC dismissViewControllerAnimated:YES completion:nil];
//            
//        }];
        [self presentViewController:loginVC animated:YES completion:nil];
//    });
}

#pragma mark-隐藏分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}
@end
