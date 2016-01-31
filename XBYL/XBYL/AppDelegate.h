//
//  AppDelegate.h
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LoginViewController.h"
#import "LoginUserInfo.h"
#import "AppMessgeDelegate.h"
#import "PersonSettingInfo.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL isactive;
    NSMutableArray *listArray;//接收数据
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,retain)UIStoryboard *mainStoryBoard;//公用的变量
@property(nonatomic,retain)LoginUserInfo *loginUserInfo;//登录的用户信息
@property(nonatomic,retain)SystemSettingModel *systemSetting;//系统设置
@property(nonatomic,assign)NSInteger refashValue;//刷新时间值
@property(nonatomic,retain)UINavigationController *mainnav;
@property(nonatomic,assign)BOOL connected;//是否已经连接
@property(nonatomic,assign)BOOL logined;//是否已经登录
@property(nonatomic,retain)PersonSettingInfo *defaultAlarmSetting;//默认的报警设置

@property(nonatomic,assign)id<AppMessgeDelegate> appMessageDelegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)reciveData;
-(void)defuaultAlarmDic;

@end

