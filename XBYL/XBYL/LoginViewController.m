
//  LoginViewController.m
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "LoginViewController.h"
#import "SystemSettingViewController.h"
#import "AppDelegate.h"
#import "nstdcomm.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "ViewController.h"
#import "PatientInfo.h"
#import "PersonSettingInfo.h"
#import "HospitalInfo.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tipView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    tipView.hidden=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self appDelegate].appMessageDelegate=self;
    
    //读取本地系统设置参数
    if ([self appDelegate].systemSetting==nil) {
        //弹出提示框
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有进行系统设置，是否前往设置"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        [alter show];
    }
    //填充界面
    [self makeView];
    
    
}

-(AppDelegate *)appDelegate{
      return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
-(void)makeView{
    
    if ([self appDelegate].loginUserInfo) {
        userNameTextField.text=[self appDelegate].loginUserInfo.userName;
        if ([self appDelegate].loginUserInfo.isRemeberPwd) {
            isremeberBtn.selected=NO;
             pwdTextField.text=[self appDelegate].loginUserInfo.pwd;
        }
        else{
            isremeberBtn.selected=YES;
            
        }
         [self remeberPwd:isremeberBtn];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self appDelegate].appMessageDelegate=nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard
     ];
}

-(void)dismissKeyBoard{
    [userNameTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
    
}
- (IBAction)systemSetting:(id)sender {
    [self goSystemSetting];
}
-(void)goSystemSetting{
    SystemSettingViewController *systemSettingVC=[[self appDelegate].mainStoryBoard instantiateViewControllerWithIdentifier:@"SystemSettingViewController"];
    [self presentViewController:systemSettingVC animated:YES completion:nil];
    
}
- (IBAction)login:(id)sender {
    [self dismissKeyBoard];
    if (userNameTextField.text.length<=0||pwdTextField.text.length<=0) {
        
        [SVProgressHUD showErrorWithStatus:@"用户名、密码不能为空"];
//        //提示
//        tipView.message=@"用户名、密码不能为空";
//        [tipView show];
        return;
    }
    if ([self appDelegate].networkStatus==0) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"当前无网络，请检查网络设置"];
        return;
    }
    if (![self appDelegate].connected) {
        int connectResult=0;
        connectResult=[nstdcomm stdcommConnect:[self appDelegate].systemSetting.ip andPort:[[self appDelegate].systemSetting.port intValue]  andWebPort:WebPort_Default  andTermPort:TermPort_Default andLoginType:LoginType_Default];
        
        [self appDelegate].connected=connectResult==1;
        if (![self appDelegate].connected) {
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
            return;
        }
    }
    if ([self appDelegate].connected) {
        //登录操作
        if (![self appDelegate].logined) {
            [nstdcomm stdcommLogin:userNameTextField.text andPwd:pwdTextField.text];
        }
    }
}

- (IBAction)remeberPwd:(id)sender {
    UIButton *btn=(UIButton *)sender;
    btn.selected=!btn.selected;
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        isremeberPwd=YES;
    }
    else{
         [btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        isremeberPwd=NO;
    }
}
-(void)loginSucess:(loginSuccessBlock)block{
    self.block=block;
}

#pragma mark-appdelegate
-(void)logingMessage:(NSString *)mes{
    
    if ([mes isEqualToString:@"success"]) {
        
        //写入本地
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([self appDelegate].loginUserInfo==nil) {
            [self appDelegate].loginUserInfo=[[LoginUserInfo alloc]init];
        }
        BOOL isSameAccount=YES;
    
        [self appDelegate].loginUserInfo.userName=userNameTextField.text;
        [self appDelegate].loginUserInfo.pwd=pwdTextField.text;
        [self appDelegate].loginUserInfo.isLoginOut=NO;
        [self appDelegate].loginUserInfo.isRemeberPwd=isremeberPwd;
        
        NSData *userInfoData=[NSKeyedArchiver archivedDataWithRootObject:[self appDelegate].loginUserInfo];
        NSData *olddata=[defaults objectForKey:user_old_loginUserInfo];
        if (olddata) {
            LoginUserInfo *olduser=[NSKeyedUnarchiver unarchiveObjectWithData:olddata];
            if (![olduser.userName isEqual:[self appDelegate].loginUserInfo.userName]) {
                isSameAccount=NO;
                //清空所有数据库
                [HospitalInfo clearModels];
                [PersonSettingInfo clearModels];
                [PatientInfo clearModels];
                
                //把报警值还原
                [[self appDelegate] defuaultAlarmDic];
                NSData *saveAlarmdata=[NSKeyedArchiver archivedDataWithRootObject:[self appDelegate].defaultAlarmSetting];
                [defaults setObject:saveAlarmdata forKey:user_defaultAlarmSetting];
                
                //不存在把这个给老的
                [defaults setObject:userInfoData forKey:user_old_loginUserInfo];
            }
        }
        else{
            //不存在把这个给老的
            [defaults setObject:userInfoData forKey:user_old_loginUserInfo];
        }
        [defaults setObject:userInfoData forKey:user_loginUserInfo];
        [defaults synchronize];
        [self appDelegate].logined=YES;

        dispatch_sync(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeNone];
        [self dismissViewControllerAnimated:YES completion:^{
//            [nstdcomm stdcommRefreshHosList];
//            [nstdcomm stdcommRefreshPatList];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_loginClick object:[NSNumber numberWithBool:isSameAccount]];
            [SVProgressHUD dismiss];
        }];
        });
    
    }
    else{
        //给出提示
        [self appDelegate].logined=NO;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"登陆失败,用户名或密码不对"];
        });
    }
}

-(void)patientMessage:(NSString*)cmd andMsg:(NSString*)msg{
    
}
-(void)hosMessage:(NSString *)mes{
    
}
-(void)networkMessage:(NSString *)mes{
    [SVProgressHUD showErrorWithStatus:@"网络连接断开"];
    [self appDelegate].connected=NO;
    [self appDelegate].logined=NO;
    
}
#pragma mark-回调函数

#pragma mark-UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //进入系统设置界面
    if (buttonIndex==1) {
        [self goSystemSetting];
    }
}

#pragma mark-UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect frame=textField.superview.frame;
    CGRect selfFrame=self.view.frame;
    
    CGFloat keyboardHeight=216;
    CGFloat offect=self.view.frame.size.height-frame.origin.y-frame.size.height-keyboardHeight;
    //有遮挡
    if (offect<0) {
        [UIView animateWithDuration:0.1 animations:^{
            self.view.frame=CGRectMake(selfFrame.origin.x, -100, selfFrame.size.width, selfFrame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    CGRect selfFrame=self.view.frame;
    if (selfFrame.origin.y<0) {
        [UIView animateWithDuration:0.1 animations:^{
            self.view.frame=CGRectMake(selfFrame.origin.x, 0, selfFrame.size.width, selfFrame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return YES;
}

-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
@end
