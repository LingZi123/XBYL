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
#import "nstdcomm.h"
#import "LoginUserInfo.h"
#import "SystemSettingModel.h"
#import "PatientInfo.h"
#import "HospitalInfo.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "AFNetworkReachabilityManager.h"

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
    if (!_isInited) {
        [nstdcomm stdcommStart];
        _isInited=YES;
    }
    [self reciveData];
   
    //系统设置数据
   NSData *systemdata=[defaults objectForKey:user_systemsetting];
    _systemSetting=[NSKeyedUnarchiver unarchiveObjectWithData:systemdata];
    
    //用户信息
    NSData *logindata=[defaults objectForKey:user_loginUserInfo];
    _loginUserInfo=[NSKeyedUnarchiver unarchiveObjectWithData:logindata];
    
    //读取本地的刷新凭率
    id tempvalue=[defaults objectForKey:user_refashTime];
    if (tempvalue==0) {
        _refashValue=5;
        //保存一个默认值5
        [defaults setInteger:5 forKey:user_refashTime];
        [defaults synchronize];
    }
    else{
        _refashValue=[tempvalue integerValue];
    }
    
    NSData *alarmdata=[defaults objectForKey:user_defaultAlarmSetting];
    if (alarmdata) {
        _defaultAlarmSetting=(PersonSettingInfo *)[NSKeyedUnarchiver unarchiveObjectWithData:alarmdata];
    }
    else{
        //付默认值
        [self defuaultAlarmDic];
        NSData *saveAlarmdata=[NSKeyedArchiver archivedDataWithRootObject:_defaultAlarmSetting];
        [defaults setObject:saveAlarmdata forKey:user_defaultAlarmSetting];
        [defaults synchronize];
    }
    
    self.mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *mainVc=[self.mainStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
        _mainnav=[[UINavigationController alloc]initWithRootViewController:mainVc];
        self.window.rootViewController=_mainnav;

    [self.window makeKeyAndVisible];
    
    [[AFNetworkReachabilityManager sharedManager]startMonitoring] ;
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _networkStatus=(NSInteger)status;
        if (status==0) {
            [nstdcomm stdcommClose];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_networkMessage object:@"无网络，请检查网络设置"];
        }
        else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_networkMessage object:@"已恢复网络"];
        }
        }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    if (_connected) {
        [nstdcomm stdcommClose];
        _connected=NO;
        _logined=NO;
    }
//    if (_isInited) {
//        [nstdcomm stdcommEnd];
//        _isInited=NO;
//        [NSThread sleepForTimeInterval:1];
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    isactive=NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    if (!_isInited) {
//        [nstdcomm stdcommStart];
//        _isInited=YES;
//        [NSThread sleepForTimeInterval:1];
//    }
//    [self reciveData];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_networkMessage object:@"已恢复网络"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    isactive=YES;
    
    dispatch_queue_t donelistQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(donelistQueue, ^(){
        int count=0;
        while (isactive) {
            if (_logined&&_connected) {
                
                NSMutableArray *temparray=[listArray copy];
                if (temparray) {
                    for (int i=0; i<temparray.count; i++) {
                        if (_loginUserInfo.isLoginOut||!_connected||!_logined) {
                            @synchronized (listArray) {
                                [listArray removeAllObjects];
                            }
                            break;
                        }
                        NSDictionary *dic=[temparray objectAtIndex:i];
                        NSString *cmd=[dic objectForKey:@"cmd"];
                        NSString *msg=[dic objectForKey:@"msg"];
                        
                        //刷新病人列表
                        if ([cmd isEqualToString:@"patientinfoACK"]||
                            [cmd isEqualToString:@"bpmdataACK"]||
                            [cmd isEqualToString:@"updateinfoACK"]||
                            [cmd isEqualToString:@"updateonlinestatusACK"]
                            ) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_patientMessage object:dic];
                            //                        [self.appMessageDelegate patientMessage:cmd andMsg:msg];
                        }
                        else if ([cmd isEqualToString:@"bodataACK"]){
                            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_patientMessage object:dic];
                            //                        [self.appMessageDelegate patientMessage:cmd andMsg:msg];
                            
                        }
                        else if ([cmd isEqualToString:@"hoslistACK"]){
                            //刷新病人列表
                            if (![msg isEqualToString:@"fail"]) {
                                //一次性返回的数据解析
                                [HospitalInfo getHosWithMsg:msg];
                            }
                        }
                        else{
                            
                            //                        NSLog(@"cmd=====%@",cmd);
                        }
                        @synchronized (listArray) {
                            [listArray removeObject:dic];
                        }
                    }
                }
                [NSThread sleepForTimeInterval:0.05];
            }
            else{
                [NSThread sleepForTimeInterval:1];
            }
         }
    });
    
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
    if(_isInited){
        [nstdcomm stdcommEnd];
        _isInited=NO;
    }
   
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

#pragma mark-数据接收
-(void)stdMessageBox:(NSString*)cmd andMsg:(NSString*)msg{
    
//    NSLog(@"msg=%@,cmd=%@",msg,cmd);

    if (listArray==nil) {
        listArray=[[NSMutableArray alloc]init];
    }
    
    if ([cmd isEqualToString:@"loginACK"]) {
        [self.appMessageDelegate logingMessage:msg];
    }
    else if ([cmd isEqualToString:@"onClose"]){
        //网络断开就要重连
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD showErrorWithStatus:@"网络断开"];
//        });
        if (isactive) {
            
            if (_isInited) {
                [nstdcomm stdcommEnd];
                [NSThread sleepForTimeInterval:1];
                _isInited=NO;
            }
            if (!_isInited) {
                [nstdcomm stdcommStart];
                [NSThread sleepForTimeInterval:1];

            }
            [self reciveData];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_networkMessage object:@"网络断开"];
        }
    }
    else if ([cmd isEqualToString:@"getbpmACK"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_getbpmACK object:msg];
    }
    else{
        
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",listArray.count],@"index",cmd,@"cmd",msg,@"msg", nil];
        @synchronized (listArray) {
            [listArray addObject:dic];
        }
    }
}


-(void)stdDataBox:(NSString*)cmd andData:(NSData*) buf{
    //NSLog(@"Recv Message cmd:%@, msg:%@", cmd, msg);
    //此处处理回应数据
    if([cmd isEqualToString:@"wavedataACK"]){
        
//        NSLog(@"wavedataACK %@",buf);
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_SIGLE_DATA object:buf];
        
    }
}

-(void)reciveData{
    [nstdcomm stdRegMessageBox:self andSelect:@selector(stdMessageBox:andMsg:) andSelectDat:@selector(stdDataBox:andData:) andTermId:0];
}

-(void)defuaultAlarmDic{
    if(_defaultAlarmSetting==nil){
        _defaultAlarmSetting=[[PersonSettingInfo alloc]init];
    }
    _defaultAlarmSetting.patientNo=Default_People ;
    
    _defaultAlarmSetting.shousuoyaupvalue=[NSString stringWithFormat:@"%d",Default_Shousuoya_Up];
    _defaultAlarmSetting.shuzhangyaupvalue=[NSString stringWithFormat:@"%d",Default_Shuzhangye_Up];
    _defaultAlarmSetting.xueyangupvalue=[NSString stringWithFormat:@"%d",Default_Xueyang_Up];
    _defaultAlarmSetting.xinlvupvalue=[NSString stringWithFormat:@"%d",Default_Xinlv_Up];
    _defaultAlarmSetting.mailvupvalue=[NSString stringWithFormat:@"%d",Default_Mailv_Up];
    _defaultAlarmSetting.huxiupvalue=[NSString stringWithFormat:@"%d",Default_Huxi_Up];
    _defaultAlarmSetting.xinlvdownvalue=[NSString stringWithFormat:@"%d",Default_Xinlv_Down];
    _defaultAlarmSetting.mailvdownvalue=[NSString stringWithFormat:@"%d",Default_Mailv_Down];
    _defaultAlarmSetting.huxidownvalue=[NSString stringWithFormat:@"%d",Default_Huxi_Down];
    _defaultAlarmSetting.xueyangdownvalue=[NSString stringWithFormat:@"%d",Default_Xueyang_Down];
    _defaultAlarmSetting.shousuoyadownvalue=[NSString stringWithFormat:@"%d",Default_Shousuoya_Down];
    _defaultAlarmSetting.shuzhangyadownvalue=[NSString stringWithFormat:@"%d",Default_Shuzhangye_Down];
}

@end
