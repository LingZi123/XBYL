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

@protocol appMessgeDelegate <NSObject>

-(void)logingMessage:(NSString *)mes;
-(void)patientMessage:(NSString*)cmd andMsg:(NSString*)msg;
-(void)hosMessage:(NSString *)mes;
-(void)networkMessage:(NSString *)mes;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,LoginViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,retain)UIStoryboard *mainStoryBoard;//公用的变量
@property(nonatomic,retain)LoginUserInfo *loginUserInfo;//登录的用户信息
@property(nonatomic,retain)SystemSettingModel *systemSetting;//系统设置
@property(nonatomic,retain)UINavigationController *mainnav;

@property(nonatomic,assign)id<appMessgeDelegate> appMessageDelegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

