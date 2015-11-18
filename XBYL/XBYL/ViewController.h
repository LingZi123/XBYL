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

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SettingViewControllerDelegate,appMessgeDelegate>
{
    
    __weak IBOutlet UITableView *_contentTablvView;
    UILabel *detailTextLabel;
    AppDelegate *appDelegate;
    __weak IBOutlet UILabel *loginNameLabel;
    NSMutableArray *infoArray;//个人信息数组
//    NSMutableArray *showArray;//显示的数组
    NSTimer *refashTimer;//刷新列表的速度
    NSInteger refashValue;//刷新时间值
//    NSInteger showRowCount;//显示的cell 数量
    __weak IBOutlet UIButton *reconnectBtn;
    
    
    
}
- (IBAction)reConnect:(id)sender;

@end

