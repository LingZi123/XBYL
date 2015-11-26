
//  LoginViewController.m
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "LoginViewController.h"
#import "SystemSettingViewController.h"
#import "AppDelegate.h"
//#import "nstdcomm.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "ViewController.h"

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
    //注册回调
//    [nstdcomm stdRegMessageBox:self andSelect:@selector(stdMessageBox:andMsg:)];
    
    //读取本地系统设置参数
    
    NSUserDefaults *defausts=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defausts objectForKey:user_systemsetting];
    systemSetting=[SystemSettingModel getModelWithDic:dic];
//    if (systemSetting) {
//        //开始链接
//        [nstdcomm stdcommConnect:systemSetting.ip andPort:systemSetting.port  andWebPort:systemSetting.webPort andTermPort:TermPort_Default andLoginType:LoginType_Default];
//    }
//    else{
//        //弹出提示框
//        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有进行系统设置，是否前往设置"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
//        [alter show];
//    }
    
    //填充界面
    [self makeView];
    
    
}

-(AppDelegate *)appDelegate{
      return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
-(void)makeView{
    
    if ([self appDelegate].loginUserInfo) {
        userNameTextField.text=[self appDelegate].loginUserInfo.userName;
        pwdTextField.text=[self appDelegate].loginUserInfo.pwd;
        if ([self appDelegate].loginUserInfo.isRemeberPwd) {
            isremeberBtn.selected=NO;
        }
        else{
            isremeberBtn.selected=YES;
        }
         [self remeberPwd:isremeberBtn];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    //注销回调
//     [nstdcomm stdRegMessageBox:nil andSelect:@selector(stdMessageBox:andMsg:)];
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
    AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    SystemSettingViewController *systemSettingVC=[appdelegate.mainStoryBoard instantiateViewControllerWithIdentifier:@"SystemSettingViewController"];
    [self presentViewController:systemSettingVC animated:YES completion:nil];
    
}
- (IBAction)login:(id)sender {
    [self dismissKeyBoard];
//    if (userNameTextField.text.length<=0||pwdTextField.text.length<=0) {
//        //提示
//        tipView.message=@"用户名、密码不能为空";
//        [tipView show];
//    }
//    [nstdcomm stdcommConnect:systemSetting.ip andPort:systemSetting.port  andWebPort:systemSetting.webPort andTermPort:TermPort_Default andLoginType:LoginType_Default];
//    //登录操作
//    [nstdcomm stdcommLogin:userNameTextField.text andPwd:pwdTextField.text];
    LoginUserInfo *user=[[LoginUserInfo alloc]init];
    
    self.block(nil);
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

#pragma mark-回调函数
-(void)stdMessageBox:(NSString*)cmd andMsg:(NSString*)msg{
    //登录界面只接受登陆返回的信息
    NSLog(@"msg=%@,cmd=%@",msg,cmd);
    if ([cmd isEqualToString:@"loginACK"]) {
        if ([msg isEqualToString:@"success"]) {
            //写入本地
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            LoginUserInfo *tempUserInfo=[[LoginUserInfo alloc]init];
            tempUserInfo.userName=userNameTextField.text;
            tempUserInfo.pwd=pwdTextField.text;
            tempUserInfo.isLoginOut=NO;
            tempUserInfo.isRemeberPwd=isremeberPwd;
            NSDictionary *userInfoDic=[LoginUserInfo getDicWithModel:tempUserInfo];
            [defaults setObject:userInfoDic forKey:user_loginUserInfo];
            [defaults synchronize];

            [self dismissViewControllerAnimated:YES completion:nil];
                        if (self.block!=nil) {
            
                            self.block(tempUserInfo);
                        }
            
        }
        else{
            //给出提示
            [SVProgressHUD showErrorWithStatus:@"登陆失败"];
//            tipView.message=msg;
//            [tipView show];
        }
        
    }
}
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
@end
