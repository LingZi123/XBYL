//
//  ViewController.h
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SettingViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SettingViewControllerDelegate,AppMessgeDelegate,UIAlertViewDelegate>
{
    
    __weak IBOutlet UITableView *_contentTablvView;
    UILabel *detailTextLabel;
    AppDelegate *appDelegate;
    NSMutableArray *infoArray;//个人信息数组
    NSTimer *refashTimer;//刷新列表的速度
    NSTimer *refashStatusTimer;//刷新病人状态，要是5秒没有收到数据就要设置为离线
    NSInteger refashValue;//刷新时间值
    UIBarButtonItem *reconnectBtn;
    UIBarButtonItem *rigthBar;
    
    __weak IBOutlet UIView *nodataView;//不存在数据
    UIBarButtonItem *leftBar;
    
    int reconnectCount;
    
    
}

@end

