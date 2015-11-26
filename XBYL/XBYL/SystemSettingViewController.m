//
//  SystemSettingViewController.m
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "SystemSettingModel.h"
//#import "nstdcomm.h"

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
    //取出本地数据填充
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *systemDic=[defaults objectForKey:user_systemsetting];
    SystemSettingModel *model=[SystemSettingModel getModelWithDic:systemDic];
    if (model) {
        ipField.text=model.ip;
        portField.text=[NSString stringWithFormat:@"%d",model.port];
        webField.text=[NSString stringWithFormat:@"%d",model.webPort];
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
    if (![self isPureInt:portField.text]||![self isPureInt:webField.text]) {
        tipView.message=@"端口号为纯数字";
        [tipView show];
        return;
    }

    [self saveToLocalIp:ipField.text andPort:[portField.text intValue] andWebport:[webField.text intValue]];
    //执行连接
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveDefault:(id)sender {
    ipField.text=IP_Default;
    portField.text=[NSString stringWithFormat:@"%d",Port_Default];
    webField.text=[NSString stringWithFormat:@"%d",WebPort_Default];
    
    [self saveToLocalIp:IP_Default andPort:Port_Default andWebport:WebPort_Default];
    
}

#pragma mark-UITextFieldDelegate
//-(void)textFieldSholdEndEditing:(UITextField *)textField{
//    if (textField==ipField) {
//        //检验
//        if (![self isIPAddress:ipField.text]) {
//           tipView.message=@"ip地址不合法";
//           [tipView show];
//        }
//    }
//    else{
//        //只能是数字
//        if (![self isPureInt:textField.text]) {
//            tipView.message=@"端口号为纯数字";
//            [tipView show
//             ];
//        }
//    }
//}

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

-(void)saveToLocalIp:(NSString *)ip andPort:(int)port andWebport:(int)webport{
    //保存
    SystemSettingModel *model=[[SystemSettingModel alloc]init];
    model.ip=ip;
    model.port=port;
    model.webPort=webport;
    NSDictionary *dic=[SystemSettingModel getDicWithModel:model];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:dic forKey:user_systemsetting];
    [defaults synchronize];

}
@end
