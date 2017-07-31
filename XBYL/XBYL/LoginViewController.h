//
//  LoginViewController.h
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemSettingModel.h"
#import "LoginUserInfo.h"
#import "AppDelegate.h"
#import "AppMessgeDelegate.h"
#import "BaseViewController.h"

typedef void (^loginSuccessBlock)(LoginUserInfo *tempUserinfo);


@interface LoginViewController : BaseViewController<UIAlertViewDelegate,UITextFieldDelegate,AppMessgeDelegate>{

    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *pwdTextField;
    BOOL connectResult;//连接服务器结果
    BOOL isremeberPwd;
    UIAlertView *tipView;
    
    __weak IBOutlet UIButton *isremeberBtn;
    
}
- (IBAction)systemSetting:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)remeberPwd:(id)sender;

@property(nonatomic,copy)loginSuccessBlock block;
-(void)loginSucess:(loginSuccessBlock)block;
@end
