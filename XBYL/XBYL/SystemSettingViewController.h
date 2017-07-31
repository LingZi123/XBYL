//
//  SystemSettingViewController.h
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SystemSettingViewController : BaseViewController<UITextFieldDelegate>{
    
    __weak IBOutlet UITextField *ipField;
    __weak IBOutlet UITextField *portField;
    __weak IBOutlet UITextField *webField;
    UIAlertView *tipView;// 提示
}
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)saveDefault:(id)sender;

@end
