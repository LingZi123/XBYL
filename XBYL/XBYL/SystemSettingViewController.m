//
//  SystemSettingViewController.m
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "SystemSettingModel.h"
#import "AppDelegate.h"

@interface SystemSettingViewController ()

@end

@implementation SystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tipView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"数据不能为空" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    tipView.hidden=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{

    if ([self appdelegate].systemSetting) {
        ipField.text=[self appdelegate].systemSetting.ip;
        portField.text=[self appdelegate].systemSetting.port;
        webField.text=[self appdelegate].systemSetting.webPort;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [ipField resignFirstResponder];
    [portField resignFirstResponder];
    [webField resignFirstResponder];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(id)sender {
    if (ipField.text.length<=0||portField.text.length<=0||webField.text.length<=0) {
        tipView.message=@"数据不能为空";
        tipView.hidden=NO;
        [tipView show];
        return;
    }
//    if (![self isIPAddress:ipField.text]) {
//        tipView.message=@"ip地址不合法";
//        [tipView show];
//        return;
//    }
    if (![self isPureInt:portField.text]) {
        tipView.message=@"端口号为纯数字";
        [tipView show];
        return;
    }

    [self saveToLocalIp:ipField.text andPort:portField.text andWebport:webField.text];
    //执行连接
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveDefault:(id)sender {
    ipField.text=IP_Default;
    portField.text=Port_Default;
    webField.text=web_Interfer;
    
    [self saveToLocalIp:IP_Default andPort:Port_Default andWebport:arm_url];
    
}

#pragma mark-UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma  mark-校验方法

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否是ip
-(BOOL) isIPAddress:(NSString *)str{

    NSString *checkStr=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regx_Ip];
    return [predicate evaluateWithObject:checkStr];
}

-(void)saveToLocalIp:(NSString *)ip andPort:(NSString *)port andWebport:(NSString *)webport{
    if ([self appdelegate].systemSetting==nil) {
        [self appdelegate].systemSetting=[[SystemSettingModel alloc]init];
        
    }
    //保存
    [self appdelegate].systemSetting.ip=ip;
    [self appdelegate].systemSetting.port=port;
    [self appdelegate].systemSetting.webPort=webport;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *systemdata=[NSKeyedArchiver archivedDataWithRootObject:[self appdelegate].systemSetting];
    
    [defaults setObject:systemdata forKey:user_systemsetting];
    [defaults synchronize];

}

-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@end
