//
//  HeartRateCurveViewController.m
//  nstdDemo
//
//  Created by 罗娇 on 2017/7/22.
//  Copyright © 2017年 popov. All rights reserved.
//

#import "HeartRateCurveViewController.h"
#import "SurFaceView.h"
#import "PointContainer.h"
#import "BODataModel.h"
#import "Helper.h"
#import "nstdcomm.h"

static const NSInteger leftWith=160;
static const CGFloat multiple=1.5f;//放大系数默认为1
static float hrViewHeight=0.375f;
static float respViewHeight=0.25f;

static const NSInteger maxMultiple=2048;
static const NSInteger midMultiple=1024;
static const NSInteger smallMultiple=512;

@interface HeartRateCurveViewController ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property(nonatomic,retain)SurFaceView *hrView;
@property(nonatomic,retain)SurFaceView *respView;
@property(nonatomic,retain)SurFaceView *spoView;

@property (weak, nonatomic) IBOutlet UILabel *bedNoLabel;//床号
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//姓名
@property (weak, nonatomic) IBOutlet UILabel *bodyTemperatureLabel;//体温
@property (weak, nonatomic) IBOutlet UILabel *pulseFrequencyLabel;//脉率
@property (weak, nonatomic) IBOutlet UILabel *bloodPressureLabel;//血压
@property (weak, nonatomic) IBOutlet UILabel *noLabel;//编号
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//状态
@property (weak, nonatomic) IBOutlet UILabel *netStatusLabel;//网络状态
@property (weak, nonatomic) IBOutlet UILabel *jeadsLabel;
@property (weak, nonatomic) IBOutlet UILabel *fingerLabel;

@property(nonatomic,retain)NSTimer *hrTimer;
@property(nonatomic,retain)NSTimer *respTimer;
@property(nonatomic,retain)NSTimer *spoTimer;

@property (nonatomic , strong) NSArray *dataSource;

@property(nonatomic,retain)NSMutableArray *reciveArray;

@property (weak, nonatomic) IBOutlet UILabel *pbmStatusLabel;

@end

@implementation HeartRateCurveViewController{
    CGFloat viewHeight;
    CGFloat viewWidth;
    bool isActive;
    
    bool isonline;
    
    NSInteger boViewWidth;
    
    NSInteger hrMultiple;
    NSInteger spoMultiple;
    NSInteger respMultiple;
    
//    NSMutableArray *currentHrPointArray;
//    NSInteger hrindex;
//    NSMutableArray *currentSpoPointArray;
//      NSInteger spoindex;
//    NSMutableArray *curretnRespPointArray;
//      NSInteger respindex;
//    bool newHrData;
//    bool newSpoData;
//    bool newRespData;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    isActive=YES;
    viewWidth=CGRectGetHeight([UIScreen mainScreen ].bounds);
    viewHeight=CGRectGetWidth([UIScreen mainScreen ].bounds)-20;
    boViewWidth=(NSInteger)((viewWidth-leftWith)*1.25f);
    //画界面
    //设置HR页面
    self.jeadsLabel.clipsToBounds=YES;
    self.jeadsLabel.layer.cornerRadius=6.f;
    self.fingerLabel.clipsToBounds=YES;
    self.fingerLabel.layer.cornerRadius=6.f;
    [self.view addSubview:self.hrView];
    [self.view addSubview:self.respView];
    [self.view addSubview:self.spoView];
//    hrindex=1;
//    spoindex=1;
//    respindex=1;
    
    //设置默认值
    hrMultiple=maxMultiple;
    spoMultiple=maxMultiple;
    respMultiple=maxMultiple;
    
    //页面显示
    self.bedNoLabel.text=self.patientInfo.bingchuangNo;
    self.nameLabel.text=self.patientInfo.patientName;
    self.noLabel.text=self.patientInfo.patientNo;
    if (self.patientInfo.status) {
        if (self.patientInfo.status.status==patient_status_offline) {
            self.statusLabel.text=@"离线";
            
        }
        else if (self.patientInfo.status.status==patient_status_online){
            self.statusLabel.text=@"在线";
        }
        else{
            self.statusLabel.text=@"删除";
        }
    }
    else{
        self.statusLabel.text=@"离线";
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isActive=YES;
    [self displayData];
    
//    [self createWorkDataSourceWithTimeInterval:0.2];
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotif:) name:NOTIF_SIGLE_DATA object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotif:) name:NOTIF_getbpmACK object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    isActive=NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIF_SIGLE_DATA object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIF_getbpmACK object:nil];
    
    if (self.hrTimer!=nil) {
        [self.hrTimer setFireDate:[NSDate distantFuture]];
        self.hrTimer=nil;
    }
    if (self.respTimer!=nil) {
        [self.respTimer setFireDate:[NSDate distantFuture]];
        self.respTimer=nil;
    }
    if (self.spoTimer!=nil) {
        [self.spoTimer setFireDate:[NSDate distantFuture]];
        self.spoTimer=nil;
    }
}

-(SurFaceView *)hrView{
    if (!_hrView) {
        _hrView=[[SurFaceView alloc]initWithFrame:CGRectMake(leftWith+10, 10, viewWidth-leftWith, viewHeight*hrViewHeight)];
        [_hrView setDefaultContentView];
        _hrView.titileLabel.text=@"HR:--";
        NSLog(@"leftview.frame=%@,hrview.frame=%@,self.view.bouds=%@",NSStringFromCGRect(self.leftView.frame),NSStringFromCGRect(_hrView.frame),NSStringFromCGRect(self.view.bounds));
    }
    return _hrView;
}

-(SurFaceView *)respView{
    if (!_respView) {
        _respView=[[SurFaceView alloc]initWithFrame:CGRectMake(leftWith+10, CGRectGetMaxY(self.hrView.frame), viewWidth-leftWith, viewHeight*respViewHeight)];
        [_respView setDefaultContentView];
        _respView.titileLabel.text=@"RESP:--";
        NSLog(@"leftview.frame=%@,hrview.frame=%@,self.view.bouds=%@",NSStringFromCGRect(self.leftView.frame),NSStringFromCGRect(_respView.frame),NSStringFromCGRect(self.view.bounds));
    }
    return _respView;
}
-(SurFaceView *)spoView{
    if (!_spoView) {
        _spoView=[[SurFaceView alloc]initWithFrame:CGRectMake(leftWith+10, CGRectGetMaxY(self.respView.frame), viewWidth- leftWith, viewHeight*hrViewHeight)];
        [_spoView setDefaultContentView];
        _spoView.titileLabel.text=@"SPO2:--";
        NSLog(@"leftview.frame=%@,hrview.frame=%@,self.view.bouds=%@",NSStringFromCGRect(self.leftView.frame),NSStringFromCGRect(_spoView.frame),NSStringFromCGRect(self.view.bounds));
    }
    return _spoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)createWorkDataSourceWithTimeInterval:(NSTimeInterval )timeInterval
//{
//    self.hrTimer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerRefreshHrSiglePoint) userInfo:nil repeats:YES];
//    self.respTimer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerRefresnRespSiglePoint) userInfo:nil repeats:YES];
//    self.spoTimer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerRefresnSpoSiglePoint) userInfo:nil repeats:YES];
//}


////画一个点
//-(void)timerRefreshHrSiglePoint{
//    if (currentHrPointArray==nil) {
//        return;
//    }
//    if (hrindex>5) {
//        if (!newHrData) {
//            hrindex=1;
//            return;
//        }
//        else{
//            hrindex=1;
//        }
//    }
//    
////    NSLog(@"timerRefreshHrSiglePoint index=%lD",(long)hrindex);
//    
//    if (newHrData) {
//        newHrData=NO;
//    }
//    for (int i=0; i<25;i++) {
//
//        [[PointContainer sharedContainer:boViewWidth] addPointAsHrChangeform:[self bubbleHrPoint:currentHrPointArray]];
//        [self.hrView fireDrawingWithPoints:[PointContainer sharedContainer:boViewWidth].hrPointContainer pointsCount:[PointContainer sharedContainer:boViewWidth].numberOfHrElements];
//    }
//    
//    hrindex=hrindex+1;
//    
//    //说明没有画完就来了新数据
//    if (newHrData&&hrindex<6) {
//        for (int j=0; j<currentHrPointArray.count-hrindex*25; j++) {
//            [[PointContainer sharedContainer:boViewWidth] addPointAsHrChangeform:[self bubbleHrPoint:currentHrPointArray]];
//            [self.hrView fireDrawingWithPoints:[PointContainer sharedContainer:boViewWidth].hrPointContainer pointsCount:[PointContainer sharedContainer:boViewWidth].numberOfHrElements];
//        }
//        hrindex=1;
//    }
//}
//
/////画一个点
//-(void)timerRefresnRespSiglePoint{
//    if (curretnRespPointArray==nil) {
//        return;
//    }
//    if (respindex>5) {
//        if (!newRespData) {
//            respindex=1;
//            return;
//        }
//        else{
//            respindex=1;
//        }
//    }
//    
////    NSLog(@"timerRefreshHrSiglePoint index=%lD",(long)respindex);
//    
//    if (newRespData) {
//        newRespData=NO;
//    }
//    for (int i=0; i<25;i++) {
//        
//        [[PointContainer sharedContainer:boViewWidth] addPointAsRespChangeform:[self bubbleRespPoint:curretnRespPointArray]];
//        
//        [self.respView fireDrawingWithPoints:[PointContainer sharedContainer:boViewWidth].respPointContainer pointsCount:[PointContainer sharedContainer:boViewWidth].numberOfRespElements];
//    }
//    
//    respindex=respindex+1;
//    
//    //说明没有画完就来了新数据
//    if (newHrData&&respindex<6) {
//        for (int j=0; j<currentHrPointArray.count-respindex*25; j++) {
//            [[PointContainer sharedContainer:boViewWidth] addPointAsRespChangeform:[self bubbleRespPoint:curretnRespPointArray]];
//            
//            [self.respView fireDrawingWithPoints:[PointContainer sharedContainer:boViewWidth].respPointContainer pointsCount:[PointContainer sharedContainer:boViewWidth].numberOfRespElements];
//        }
//        respindex=1;
//    }
//}
//
//
////画一个点
//-(void)timerRefresnSpoSiglePoint{
//    if (currentSpoPointArray==nil) {
//        return;
//    }
//    if (spoindex>5) {
//        if (!newSpoData) {
//            spoindex=1;
//            return;
//        }
//        else{
//            spoindex=1;
//        }
//    }
//    
//    NSLog(@"timerRefreshHrSiglePoint index=%lD",(long)spoindex);
//    
//    if (newSpoData) {
//        newSpoData=NO;
//    }
//    for (int i=0; i<25;i++) {
//        
//        [[PointContainer sharedContainer:boViewWidth] addPointAsSpoChangeform:[self bubbleSpoPoint:currentSpoPointArray]];
//        
//        [self.spoView fireDrawingWithPoints:[PointContainer sharedContainer:boViewWidth].spoPointContainer pointsCount:[PointContainer sharedContainer:boViewWidth].numberOfSpoElements];
//    }
//    
//    spoindex=spoindex+1;
//    
//    //说明没有画完就来了新数据
//    if (newHrData&&spoindex<6) {
//        for (int j=0; j<currentHrPointArray.count-spoindex*25; j++) {
//            [[PointContainer sharedContainer:boViewWidth] addPointAsSpoChangeform:[self bubbleSpoPoint:currentSpoPointArray]];
//            
//            [self.spoView fireDrawingWithPoints:[PointContainer sharedContainer:boViewWidth].spoPointContainer pointsCount:[PointContainer sharedContainer:boViewWidth].numberOfSpoElements];
//        }
//        spoindex=1;
//    }
//}
//
//刷新方式绘制
- (void)timerRefresnHrFun:(NSMutableArray *)array
{
    NSLog(@"timerRefresnHrFun");
   [self.hrView setOnlineContentView:[UIColor greenColor].CGColor fullmodel:NO];

    //遍历求放大倍数
    NSInteger maxValue = [[array valueForKeyPath:@"@max.floatValue"] integerValue];
    NSInteger minValue = [[array valueForKeyPath:@"@min.floatValue"] integerValue];
    NSInteger chaValue=maxValue-minValue;
    
    hrMultiple=smallMultiple;
    if (chaValue>midMultiple) {
        hrMultiple=maxMultiple;
    }
    else if (chaValue>smallMultiple&&chaValue<=midMultiple){
        hrMultiple=midMultiple;
    }
    else if(chaValue<=smallMultiple){
        hrMultiple=smallMultiple;
    }
    
    NSInteger nextmaxValue=maxValue-midMultiple+hrMultiple/2;
    NSInteger nextminValue=minValue-midMultiple+hrMultiple/2;
    if (nextmaxValue>hrMultiple||nextminValue<0) {
        if (hrMultiple<maxMultiple) {
            hrMultiple=hrMultiple*2;
        }
    }

    for (int i=0; i<5;i++) {
        if (!isActive) {
            break;
        }
//        [self performSelector:@selector(complateHrView:) withObject:array];
        [self complateHrView:array];
    }
}

-(void)complateHrView :(NSMutableArray *)arry{
    for (int i=0; i<25; i++) {
        if (!isActive) {
            break;
        }
        [[PointContainer sharedContainer:boViewWidth] addPointAsHrChangeform:[self bubbleHrPoint:arry]];
        [self.hrView fireDrawingWithPoints:[PointContainer sharedContainer:boViewWidth].hrPointContainer pointsCount:[PointContainer sharedContainer:boViewWidth].numberOfHrElements];

    }
}

//刷新方式绘制
- (void)timerRefresnRespFun:(NSMutableArray *)array
{

    [self.respView setOnlineContentView:[UIColor yellowColor].CGColor fullmodel:NO];
    //遍历求放大倍数
    NSInteger maxValue = [[array valueForKeyPath:@"@max.floatValue"] integerValue];
    NSInteger minValue = [[array valueForKeyPath:@"@min.floatValue"] integerValue];
    NSInteger chaValue=maxValue-minValue;
    
    respMultiple=smallMultiple;
    
    if (chaValue>midMultiple) {
        respMultiple=maxMultiple;
    }
    else if (chaValue>smallMultiple&&chaValue<=midMultiple){
        respMultiple=midMultiple;
    }
    else if(chaValue<=smallMultiple){
        respMultiple=smallMultiple;
    }
    NSInteger nextmaxValue=maxValue-midMultiple+respMultiple/2;
    NSInteger nextminValue=minValue-midMultiple+respMultiple/2;
    if (nextmaxValue>respMultiple||nextminValue<0) {
        if (respMultiple<maxMultiple) {
            respMultiple=respMultiple*2;
        }
    }

    for (int i=0; i<5;i++) {
        if (!isActive) {
            break;
        }
//        [self performSelector:@selector(complateRespView:) withObject:array afterDelay:0.15];
        [self complateRespView:array];
    }

}

-(void)complateRespView :(NSMutableArray *)arry{
    for (int i=0; i<25; i++) {
        if (!isActive) {
            break;
        }
        [[PointContainer sharedContainer:boViewWidth] addPointAsRespChangeform:[self bubbleRespPoint:arry]];
        
        [self.respView fireDrawingWithPoints:[PointContainer sharedContainer:boViewWidth].respPointContainer pointsCount:[PointContainer sharedContainer:boViewWidth].numberOfRespElements];
    }
}


//刷新方式绘制
- (void)timerRefresnSPOFun:(NSMutableArray *)array
{

    [self.spoView setOnlineContentView:[UIColor redColor].CGColor fullmodel:NO];
    
    //遍历求放大倍数
    NSInteger maxValue = [[array valueForKeyPath:@"@max.floatValue"] integerValue];
    NSInteger minValue = [[array valueForKeyPath:@"@min.floatValue"] integerValue];
    NSInteger chaValue=maxValue-minValue;
    
    spoMultiple=smallMultiple;
    if (chaValue>midMultiple) {
        spoMultiple=maxMultiple;
    }
    else if (chaValue>smallMultiple&&chaValue<=midMultiple){
        spoMultiple=midMultiple;
    }
    else if(chaValue<=smallMultiple){
        spoMultiple=smallMultiple;
    }
    
    NSInteger nextmaxValue=maxValue-midMultiple+spoMultiple/2;
    NSInteger nextminValue=minValue-midMultiple+spoMultiple/2;
    if (nextmaxValue>spoMultiple||nextminValue<0) {
        if (spoMultiple<maxMultiple) {
            spoMultiple=spoMultiple*2;
        }
    }
    
    for (int i=0; i<5;i++) {
        if (!isActive) {
            break;
        }
//        [self performSelector:@selector(complateSpoView:) withObject:array afterDelay:0.15];
        [self complateSpoView:array];
    }

}

-(void)complateSpoView :(NSMutableArray *)arry{
    for (int i=0; i<25; i++) {
        if (!isActive) {
            break;
        }
        [[PointContainer sharedContainer:boViewWidth] addPointAsSpoChangeform:[self bubbleSpoPoint:arry]];
        [self.spoView fireDrawingWithPoints:[PointContainer sharedContainer:boViewWidth].spoPointContainer pointsCount:[PointContainer sharedContainer:boViewWidth].numberOfSpoElements];
    }
}


// 如果需要横屏的时候，一定要重写这个方法并返回NO
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持横屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    // 如果该界面需要支持横竖屏切换
//    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
    // 如果该界面仅支持横屏
    return UIInterfaceOrientationMaskLandscapeRight;
}


-(void)drawHeartView:(NSData *)data{
    BODataModel *model=[BODataModel getModelWithData:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bodyTemperatureLabel.text=[NSString stringWithFormat:@"%d",model.tp];
        self.pulseFrequencyLabel.text=[NSString stringWithFormat:@"%d",model.pluse];
        self.noLabel.text=[NSString stringWithFormat:@"%d",model.mask];
        self.spoView.titileLabel.text=[NSString stringWithFormat:@"SPO2:%d",model.spo2];
        self.respView.titileLabel.text=[NSString stringWithFormat:@"RESP:%d",model.resp];
        self.hrView.titileLabel.text=[NSString stringWithFormat:@"HR:%d",model.hr];
        
        if (model.fingerflag==0) {
            self.fingerLabel.backgroundColor=[UIColor greenColor];
        }
        else{
            self.fingerLabel.backgroundColor=[UIColor redColor];
        }
        
        if (model.jeadsflag==0) {
            self.jeadsLabel.backgroundColor=[UIColor greenColor];
        }
        else{
            self.jeadsLabel.backgroundColor=[UIColor redColor];
        }
        [self timerRefresnHrFun:model.ecgArray];
        [self timerRefresnRespFun:model.repsArray];
        [self timerRefresnSPOFun:model.spo2Array];
    });

}


#pragma mark-数据
-(void)reciveNotif:(NSNotification *)sender{
    if([sender.name isEqualToString:NOTIF_SIGLE_DATA]){
        
        NSLog(@"接收到通知");
        if (self.reciveArray==nil) {
            self.reciveArray=[[NSMutableArray alloc]init];
        }
        
        [self.reciveArray addObject:sender.object];
    }
    else if ([sender.name isEqualToString:NOTIF_getbpmACK]){
        NSString *msg=sender.object;
        XueyaModel *model=[XueyaModel getModelWithStringByTest:msg];
        if (model) {
            //更新数据
            NSString *resultstr=@"";
            if ([model.resultStr isEqualToString:@"0"]) {
                //测量成功
                resultstr=@"测量成功";
                self.bloodPressureLabel.text=[NSString stringWithFormat:@"%@/%@",model.shousuoya,model.DBP];
                self.patientInfo.xueya.shousuoya=model.shousuoya;
                self.patientInfo.xueya.DBP=model.DBP;
            }
            else{
                resultstr=@"测量失败";
                self.bloodPressureLabel.text=@"--/--";
            }
            
            NSString *statusstr=@"";
            if ([model.statusStr isEqualToString:@"0"]) {
                statusstr=@"血压计断开";
            }
            else if ([model.statusStr isEqualToString:@"1"]){
                statusstr=@"血压计正常连接";
            }
            else{
                statusstr=@"血压计正常连接但电量低";
            }
            self.pbmStatusLabel.text=[NSString stringWithFormat:@"%@  %@",resultstr,statusstr];
        }
        else{
            self.bloodPressureLabel.text=@"--/--";
            self.pbmStatusLabel.text=@"测量失败";
        }
    }
}

-(void)displayData{
    
    dispatch_queue_t donelistQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(donelistQueue, ^(){
        while (isActive) {
            if (!isActive) {
                break;
            }
            NSMutableArray *tempArray=[self.reciveArray copy];
            if (tempArray&&tempArray.count>0) {
                for (NSData *buf in tempArray) {
                    if (!isActive) {
                        break;
                    }
                    [self drawHeartView:buf];
                    if ([self.reciveArray containsObject:buf]) {
                        [self.reciveArray removeObject:buf];
                    }
                }
            }
        }
    });
}

#pragma mark-action
- (IBAction)backAction:(id)sender {
    [self.delegate closeHeartRateViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)testBloodAction:(id)sender {
    
    //该警告是因为string 类型转intvalue值和integerValue 不一致，正确值应该是integerValue
    [nstdcomm stdcommGetPatBPM:self.patientInfo.patientNo andTermid:[self.patientInfo.terminNo integerValue]];
    //修改测量值
    self.bloodPressureLabel.text=@"正在远程测量血压";
    
}

- (CGPoint)bubbleHrPoint:(NSMutableArray *)array
{
    static NSInteger dataSourceCounterIndex = -1;
    dataSourceCounterIndex ++;
    dataSourceCounterIndex %= [array count];
    
    
    NSInteger pixelPerPoint = 1;
    static NSInteger xCoordinateInMoniter = 0;
    
    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter*0.8,(CGRectGetHeight(self.hrView.bounds)-30)-([array[dataSourceCounterIndex] integerValue]-midMultiple+hrMultiple*0.5f)*((CGRectGetHeight(self.hrView.bounds)-30)/hrMultiple)};
    xCoordinateInMoniter += pixelPerPoint;
    xCoordinateInMoniter %= boViewWidth;
    
//    NSLog(@"吐出来的点:%@",NSStringFromCGPoint(targetPointToAdd));
    return targetPointToAdd;
}

- (CGPoint)bubbleRespPoint:(NSMutableArray *)array
{
    static NSInteger dataSourceCounterIndex = -1;
    dataSourceCounterIndex ++;
    dataSourceCounterIndex %= [array count];
    
    
    NSInteger pixelPerPoint = 1;
    static NSInteger xCoordinateInMoniter = 0;
    
    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter*0.8,(CGRectGetHeight(self.respView.bounds)-30)-([array[dataSourceCounterIndex] integerValue]-midMultiple+respMultiple*0.5f)*((CGRectGetHeight(self.respView.bounds)-30)/respMultiple)};
    xCoordinateInMoniter += pixelPerPoint;
    xCoordinateInMoniter %= boViewWidth;
//    NSLog(@"吐出来的点:%@",NSStringFromCGPoint(targetPointToAdd));
    return targetPointToAdd;
}

- (CGPoint)bubbleSpoPoint:(NSMutableArray *)array
{
    static NSInteger dataSourceCounterIndex = -1;
    dataSourceCounterIndex ++;
    dataSourceCounterIndex %= [array count];
    
    
    NSInteger pixelPerPoint = 1;
    static NSInteger xCoordinateInMoniter = 0;
    
    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter*0.8,(CGRectGetHeight(self.spoView.bounds)-30)-([array[dataSourceCounterIndex] integerValue]-midMultiple+spoMultiple*0.5f)*((CGRectGetHeight(self.spoView.bounds)-30)/spoMultiple)};
    xCoordinateInMoniter += pixelPerPoint;
    xCoordinateInMoniter %= boViewWidth;
//    NSLog(@"吐出来的点:%@",NSStringFromCGPoint(targetPointToAdd));
    return targetPointToAdd;
}
@end
