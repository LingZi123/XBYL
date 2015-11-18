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


@protocol LoginViewControllerDelegate <NSObject>

-(void)loginSuccess:(LoginUserInfo *)tempUserInfo;

@end

typedef void (^loginSuccessBlock)(LoginUserInfo *tempUserinfo);


@interface LoginViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>{

    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *pwdTextField;
    SystemSettingModel *systemSetting;
    BOOL connectResult;//连接服务器结果
    BOOL isremeberPwd;
    
    UIAlertView *tipView;
    
    __weak IBOutlet UIButton *isremeberBtn;
    
}
- (IBAction)systemSetting:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)remeberPwd:(id)sender;

@property(nonatomic,assign) id<LoginViewControllerDelegate> delegate;
@property(nonatomic,copy)loginSuccessBlock block;
-(void)loginSucess:(loginSuccessBlock)block;
@end
