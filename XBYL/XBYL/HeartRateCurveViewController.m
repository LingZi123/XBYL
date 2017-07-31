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
static float hrViewHeight=0.375f;
static float respViewHeight=0.25f;

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

@property(nonatomic,retain)PointContainer *ecgContainer;
@property(nonatomic,retain)PointContainer *spo2Container;
@property(nonatomic,retain)PointContainer *respContainer;

@property(nonatomic,retain)NSTimer *hrTimer;
@property(nonatomic,retain)NSTimer *respTimer;
@property(nonatomic,retain)NSTimer *spoTimer;

@property (nonatomic , strong) NSArray *dataSource;

@property(nonatomic,retain)NSMutableArray *reciveArray;


@end

@implementation HeartRateCurveViewController{
    CGFloat viewHeight;
    CGFloat viewWidth;
    bool isActive;
    
    bool isonline;
    
    NSInteger boViewWidth;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    isActive=YES;
    viewWidth=CGRectGetWidth(self.view.bounds);
    viewHeight=CGRectGetHeight(self.view.bounds);
    boViewWidth=(NSInteger)(viewWidth-leftWith);
    //画界面
    //设置HR页面
    self.jeadsLabel.clipsToBounds=YES;
    self.jeadsLabel.layer.cornerRadius=6.f;
    self.fingerLabel.clipsToBounds=YES;
    self.fingerLabel.layer.cornerRadius=6.f;
    [self.view addSubview:self.hrView];
    [self.view addSubview:self.respView];
    [self.view addSubview:self.spoView];
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotif:) name:SIGLE_DATA object:nil];
    isActive=YES;
    [self displayData];

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
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    isActive=NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SIGLE_DATA object:nil];
    if (self.hrTimer!=nil) {
        self.hrTimer=nil;
    }
    if (self.respTimer!=nil) {
        self.respTimer=nil;
    }
    if (self.spoTimer!=nil) {
        self.spoTimer=nil;
    }
    
    [self.delegate closeHeartRateViewController];
}

-(SurFaceView *)hrView{
    if (!_hrView) {
        _hrView=[[SurFaceView alloc]initWithFrame:CGRectMake(leftWith+10, 0, viewWidth-leftWith, viewHeight*hrViewHeight)];
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
//    self.hrTimer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerRefresnHrFun) userInfo:nil repeats:YES];
//    self.respTimer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerRefresnRespFun) userInfo:nil repeats:YES];
//    self.spoTimer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerRefresnSPOFun) userInfo:nil repeats:YES];
//}

//刷新方式绘制
- (void)timerRefresnHrFun:(NSMutableArray *)array
{
//    if (!isonline) {
        if (self.ecgContainer==nil) {
            self.ecgContainer=[[PointContainer alloc]initWithSize:boViewWidth];
        }
         [self.hrView setOnlineContentView];
//        isonline=YES;
//    }
   
    for (int i=0; i<array.count;i++) {
        [self.ecgContainer addPointAsRefreshChangeform:[self bubbleRefreshPoint:self.hrView array:array]];
        
        [self.hrView fireDrawingWithPoints:self.ecgContainer.refreshPointContainer pointsCount:self.ecgContainer.numberOfRefreshElements];
//        [NSThread sleepForTimeInterval:0.001];
        
//        [NSThread sleepForTimeInterval:0.001];
    }
   
   
   
    
}

//刷新方式绘制
- (void)timerRefresnRespFun:(NSMutableArray *)array
{

    
    if (self.respContainer==nil) {
        self.respContainer=[[PointContainer alloc]initWithSize:boViewWidth];
    }
    [self.respView setOnlineContentView];
    for (int i=0; i<array.count;i++) {
        [self.respContainer addPointAsRefreshChangeform:[self bubbleRefreshPoint:self.respView array:array]];
        
        [self.respView fireDrawingWithPoints:self.respContainer.refreshPointContainer pointsCount:self.respContainer.numberOfRefreshElements];

    }

}

//刷新方式绘制
- (void)timerRefresnSPOFun:(NSMutableArray *)array
{
    if (self.spo2Container==nil) {
        self.spo2Container=[[PointContainer alloc]initWithSize:boViewWidth];
    }
    [self.spoView setOnlineContentView];
    
    for (int i=0; i<array.count;i++) {
        [self.spo2Container addPointAsRefreshChangeform:[self bubbleRefreshPoint:self.spoView array:array]];
        
        [self.spoView fireDrawingWithPoints:self.spo2Container.refreshPointContainer pointsCount:self.spo2Container.numberOfRefreshElements];

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

- (CGPoint)bubbleRefreshPoint:(SurFaceView *)senderView array:(NSMutableArray *)array
{
    static NSInteger dataSourceCounterIndex = -1;
    dataSourceCounterIndex ++;
    dataSourceCounterIndex %= [array count];
    
    
    NSInteger pixelPerPoint = 1;
    static NSInteger xCoordinateInMoniter = 0;
    
    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter,[array[dataSourceCounterIndex] integerValue]*((CGRectGetHeight(senderView.bounds)-30)/2048)};
    xCoordinateInMoniter += pixelPerPoint;
    xCoordinateInMoniter %= boViewWidth;
    
    if (targetPointToAdd.y<10) {
        NSLog(@"targetPointToAdd.yr=%f",targetPointToAdd.y);
    }
    NSLog(@"吐出来的点:%@",NSStringFromCGPoint(targetPointToAdd));
    return targetPointToAdd;
}



#pragma mark-数据
-(void)reciveNotif:(NSNotification *)sender{
    if([sender.name isEqualToString:SIGLE_DATA]){
        
        NSLog(@"接收到通知");
        if (self.reciveArray==nil) {
            self.reciveArray=[[NSMutableArray alloc]init];
        }
        
        [self.reciveArray addObject:sender.object];
//         BODataModel *model=[BODataModel getModelWithData:sender.object];
//        NSLog(@"model==%@",model);
    
    }
}

-(void)displayData{
    
    dispatch_queue_t donelistQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(donelistQueue, ^(){
        while (isActive) {
            NSMutableArray *tempArray=[self.reciveArray copy];
            if (tempArray&&tempArray.count>0) {
                for (NSData *buf in tempArray) {
                    BODataModel *model=[BODataModel getModelWithData:buf];
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
//                        [self timerRefresnRespFun:model.repsArray];
//                        [self timerRefresnSPOFun:model.spo2Array];
                    });
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)testBloodAction:(id)sender {
    [nstdcomm stdcommGetPatBPM:self.patientInfo.patientNo andTermid:[self.patientInfo.terminNo intValue]];
}

@end