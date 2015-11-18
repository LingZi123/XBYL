//
//  AppDelegate.m
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import "nstdcomm/nstdcomm/nstdcomm.h"
#import "LoginUserInfo.h"
#import "SystemSettingModel.h"
#import "PatientInfo.h"
#import "HospitalInfo.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //判断是否退出
    //如果退出进入登录界面
    //否则直接进入主界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    //通信IO反应堆初始化(应用启动时调用,建议在APP启动后调用,只调用一次)
    [nstdcomm stdcommStart];
    NSDictionary *systemSettingDic=[defaults objectForKey:user_systemsetting];
    _systemSetting=[SystemSettingModel getModelWithDic:systemSettingDic];
    
    NSDictionary *userInfoDic=[defaults objectForKey:user_loginUserInfo];
    _loginUserInfo=[LoginUserInfo getModelWithDic:userInfoDic];
    
    self.mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (_loginUserInfo==nil||_loginUserInfo.isLoginOut) {
        
        LoginViewController *loginVc=[self.mainStoryBoard  instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [loginVc loginSucess:^(LoginUserInfo *tempUserinfo) {
            _loginUserInfo.userName=tempUserinfo.userName;
            _loginUserInfo.pwd=tempUserinfo.pwd;
            _loginUserInfo.isLoginOut=tempUserinfo.isLoginOut;
            _loginUserInfo.isRemeberPwd=tempUserinfo.isRemeberPwd;
            
            ViewController *mainVc=[self.mainStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
             _mainnav=[[UINavigationController alloc]initWithRootViewController:mainVc];
            self.window.rootViewController=_mainnav;
            
        }];
        self.window.rootViewController=loginVc;
    }
    else{
        
        if (_systemSetting) {
            [nstdcomm stdcommConnect:_systemSetting.ip andPort:_systemSetting.port andWebPort:_systemSetting.webPort andTermPort:TermPort_Default andLoginType:LoginType_Default];
        }
        //只有登陆才能收到数据
        [nstdcomm stdcommLogin:_loginUserInfo.userName andPwd:_loginUserInfo.pwd];
        ViewController *mainVc=[self.mainStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
        _mainnav=[[UINavigationController alloc]initWithRootViewController:mainVc];
        self.window.rootViewController=_mainnav;
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //应该端开链接
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//再重新连接
    [nstdcomm stdcommClose];
    if (_systemSetting) {
        [nstdcomm stdcommConnect:_systemSetting.ip andPort:_systemSetting.port andWebPort:_systemSetting.webPort andTermPort:TermPort_Default andLoginType:LoginType_Default];
        if (_loginUserInfo) {
               [nstdcomm stdcommLogin:_loginUserInfo.userName andPwd:_loginUserInfo.pwd];
        }
    }
    //检查数据库是否过期
    NSDate *today=[NSDate date];
    //获取所有病人信息
    NSMutableArray *patients=[PatientInfo getAllModel];
    if (patients&&patients.count>0) {
        //比较日期
        for (PatientInfo *patient in patients) {
            NSTimeInterval interval = [patient.addDate timeIntervalSinceDate:today];
            if (interval>=60*60*24*30) {
                [PatientInfo deleteModelWithPatientNo:patient.patientNo];
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [nstdcomm stdcommEnd];
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xb.XBYL" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XBYL" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XBYL.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark-LoginViewControllerDelegate
//-(void)loginSuccess:(LoginUserInfo *)tempUserInfo{
//    _loginUserInfo.userName=tempUserInfo.userName;
//    _loginUserInfo.pwd=tempUserInfo.pwd;
//    _loginUserInfo.isLoginOut=tempUserInfo.isLoginOut;
//    _loginUserInfo.isRemeberPwd=tempUserInfo.isRemeberPwd;
//    if (_mainnav==nil) {
//        ViewController *mainVc=[self.mainStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
//        _mainnav=[[UINavigationController alloc]initWithRootViewController:mainVc];
//        self.window.rootViewController=nil;
//    }
//    if (self.window.rootViewController.view.superview==nil) {
//        [self.window.rootViewController.view removeFromSuperview];
//    }
//    self.window.rootViewController=_mainnav;
//}

-(void)stdMessageBox:(NSString*)cmd andMsg:(NSString*)msg{
    
    //登录界面只接受登陆返回的信息
    NSLog(@"msg=%@,cmd=%@",msg,cmd);
    if ([cmd isEqualToString:@"loginACK"]) {
        [self.appMessageDelegate logingMessage:msg];
    }
    //登录界面只接受登陆返回的信息
    NSLog(@"msg=%@,cmd=%@",msg,cmd);
    //刷新病人列表
    if ([cmd isEqualToString:@"patientinfoACK"]||
        [cmd isEqualToString:@"bpmdataACK"]||
        [cmd isEqualToString:@"updateinfoACK"]||
        [cmd isEqualToString:@"updateonlinestatusACK"]||
        [cmd isEqualToString:@"bodataACK"]) {
        [self.appMessageDelegate patientMessage:cmd andMsg:msg];
    }
    else if ([cmd isEqualToString:@"hoslistACK"]){
        //刷新病人列表
        if (![msg isEqualToString:@"fail"]) {
            //一次性返回的数据解析
            [HospitalInfo getHosWithMsg:msg];
        }
    }
    else if ([cmd isEqualToString:@"onClose"]){
        //网络断开就要重连
        [SVProgressHUD showErrorWithStatus:@"网络断开"];
        [self.appMessageDelegate networkMessage:msg];
    }
}

@end
