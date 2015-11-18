//
//  PersonSettingViewController.m
//  XBYL
//
//  Created by 罗娇 on 15/7/30.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "PersonSettingViewController.h"
#import "PickViewController.h"
#import "AppDelegate.h"
#import "PersonSettingInfo.h"

@interface PersonSettingViewController ()

@end

@implementation PersonSettingViewController

-(instancetype)initWithTitle:(NSString *)title_{
    self=[super init];
    if (self) {
        titleName=title_;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    
    //从本地数据库中获取
    personSetting=[PersonSettingInfo getModelWithPatientNo:_patient.patientNo];
    if (personSetting==nil) {
        personSetting=[[PersonSettingInfo alloc]init];
        [self defaultSetting];
    }
    [self fullAlarmArray];
}
-(void)fullAlarmArray{
    if (dataArray) {
        [dataArray removeAllObjects];
    }
    else{
        dataArray=[[NSMutableArray alloc]init];
    }
    NSMutableDictionary *dic1=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"收缩压",@"title",personSetting.shousuoyadownvalue,@"downValue",personSetting.shousuoyaupvalue,@"upValue", nil];
    NSMutableDictionary *dic2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"舒张压",@"title",personSetting.shuzhangyadownvalue,@"downValue",personSetting.shuzhangyaupvalue,@"upValue", nil];
    NSMutableDictionary *dic3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"血氧",@"title",personSetting.xueyangdownvalue,@"downValue",personSetting.xueyangupvalue,@"upValue", nil];
    NSMutableDictionary *dic4=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"心率",@"title",personSetting.xinlvdownvalue,@"downValue",personSetting.xinlvupvalue,@"upValue", nil];
    NSMutableDictionary *dic5=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"脉率",@"title",personSetting.mailvdownvalue,@"downValue",personSetting.mailvupvalue,@"upValue", nil];
    NSMutableDictionary *dic6=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"呼吸",@"title",personSetting.huxidownvalue,@"downValue",personSetting.huxiupvalue,@"upValue", nil];
    
    [dataArray addObject:dic1];
    [dataArray addObject:dic2];
    [dataArray addObject:dic3];
    [dataArray addObject:dic4];
    [dataArray addObject:dic5];
    [dataArray addObject:dic6];
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=[NSString stringWithFormat:@"%@-报警设置",_patient.patientName];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeView{
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"默认" style:UIBarButtonItemStylePlain target:self action:@selector(recoveDefault:)];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem=leftBar;
    self.navigationItem.rightBarButtonItem=rightBar;
    
}

-(void)defaultSetting{
    
        personSetting.patientNo=_patient.patientNo;
        personSetting.shuzhangyadownvalue=[NSString stringWithFormat:@"%d",Default_Shuzhangye_Down];
        personSetting.shuzhangyaupvalue=[NSString stringWithFormat:@"%d",Default_Shuzhangye_Up];
        personSetting.shousuoyadownvalue=[NSString stringWithFormat:@"%d",Default_Shousuoya_Down];
        personSetting.shousuoyaupvalue=[NSString stringWithFormat:@"%d",Default_Shousuoya_Up];
        personSetting.xueyangdownvalue=[NSString stringWithFormat:@"%d",Default_Xueyang_Down];
        personSetting.xueyangupvalue=[NSString stringWithFormat:@"%d",Default_Xueyang_Up];
        personSetting.xinlvdownvalue=[NSString stringWithFormat:@"%d",Default_Xinlv_Down];
        personSetting.xinlvupvalue=[NSString stringWithFormat:@"%d",Default_Xinlv_Up];
        personSetting.mailvdownvalue=[NSString stringWithFormat:@"%d",Default_Mailv_Down];
        personSetting.mailvupvalue=[NSString stringWithFormat:@"%d",Default_Mailv_Up];
        personSetting.huxidownvalue=[NSString stringWithFormat:@"%d",Default_Huxi_Down];
        personSetting.huxiupvalue=[NSString stringWithFormat:@"%d",Default_Huxi_Up];
}
-(void)recoveDefault:(id)sender{
    [self defaultSetting];
    [self fullAlarmArray];
    [dataTableView reloadData];
}

- (IBAction)saveData:(id)sender {
    if ([PersonSettingInfo getModelWithPatientNo:personSetting.patientNo]!=nil) {
        [PersonSettingInfo updateModelWithModel:personSetting];
    }
    else{
        [PersonSettingInfo InsertModelWithModel:personSetting];
    }
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-私有方法

#pragma mark-UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indentfi=@"personSettingCell";
    UITableViewCell *cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:indentfi];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentfi];
    }
    NSMutableDictionary *data=[dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[data objectForKey:@"title"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@~%@",[data objectForKey:@"downValue"],[data objectForKey:@"upValue"]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray) {
        return dataArray.count;
    }
    else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    PickViewController *vc=[appdelegate.mainStoryBoard instantiateViewControllerWithIdentifier:@"PickViewController"];
    vc.selectRow=indexPath;
    vc.delegate=self;
    NSMutableArray *upArray=[[NSMutableArray alloc]init];
    NSMutableArray *downArray=[[NSMutableArray alloc]init];
    for (int i=1; i<300; i++) {
        NSString *a=[NSString stringWithFormat:@"%d",i];
        [upArray addObject:a];
        [downArray addObject:a];
        
    }
    NSMutableDictionary *data=[dataArray objectAtIndex:indexPath.row];
    vc.updataArray=upArray;
    vc.downDataArray=downArray;
    vc.upValue=[data objectForKey:@"upValue"];
    vc.downValue=[data objectForKey:@"downValue"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-PickViewControllerDelegate
-(void)complateInRow:(NSIndexPath *)row upValue:(NSString *)upvalue downValue:(NSString *)downValue{
    //更新某个cell的值
    NSMutableDictionary *data=[dataArray objectAtIndex:row.row];
    [data setObject:upvalue forKey:@"upValue"];
    [data setObject:downValue forKey:@"downValue"];
    
    if (row.row==0) {
//        shousuoDownValue=[downValue integerValue];
//        shousuoUpValue=[upvalue integerValue];
        personSetting.shousuoyadownvalue=downValue;
        personSetting.shousuoyaupvalue=upvalue;
    }
    else if (row.row==1){
//        shuzhangDownValue=[downValue integerValue];
//        shuzhangUpValue=[upvalue integerValue];
        personSetting.shuzhangyadownvalue=downValue;
        personSetting.shuzhangyaupvalue=upvalue;
    }
    else if (row.row==2){
//        xueyangDownValue=[downValue integerValue];
//        xueyangUpValue=[upvalue integerValue];
        personSetting.xueyangdownvalue=downValue;
        personSetting.xueyangupvalue=upvalue;
    }
    else if (row.row==3){
//        xinlvDownValue=[downValue integerValue];
//        xinlvUpValue=[upvalue integerValue];
        personSetting.xinlvdownvalue=downValue;
        personSetting.xinlvupvalue=upvalue;
    }
    else if (row.row==4){
//        mailvDownValue=[downValue integerValue];
//        mailvUpValue=[upvalue integerValue];
        personSetting.mailvdownvalue=downValue;
        personSetting.mailvupvalue=upvalue;
    }
    else if (row.row==5){
//        huxiDownValue=[downValue integerValue];
//        huxiUpValue=[upvalue integerValue];
        personSetting.huxidownvalue=downValue;
        personSetting.huxiupvalue=upvalue;
    }
    
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:row, nil];
    [dataTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}
@end
