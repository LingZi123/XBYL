//
//  AlarmSettingView.m
//  XBYL
//
//  Created by 罗娇 on 16/1/26.
//  Copyright (c) 2016年 罗娇. All rights reserved.
//

#import "AlarmSettingView.h"
#import "SVProgressHUD/SVProgressHUD.h"

@implementation AlarmSettingView

-(instancetype)initWithFrame:(CGRect)frame info:(PersonSettingInfo *)info{
    self=[super initWithFrame:frame];
    if (self) {
        _info=info;
        [self makeview];
    }
    return self;
}

-(void)makeview{
    dataTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 280)];
    dataTableView.delegate=self;
    dataTableView.dataSource=self;
    [self addSubview:dataTableView];
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(dataTableView.frame)+100,self.frame.size.width-40, 35)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveData:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:saveBtn];
    //填充数据
    [self fullAlarmArray];
}

-(void)saveData:(UIButton *)sender{
    [self.delegate savedata:_info];
}

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
    
    NSMutableArray *upArray=[[NSMutableArray alloc]init];
    NSMutableArray *downArray=[[NSMutableArray alloc]init];
    for (int i=1; i<300; i++) {
        NSString *a=[NSString stringWithFormat:@"%d",i];
        [upArray addObject:a];
        [downArray addObject:a];
        
    }
    NSMutableDictionary *data=[dataArray objectAtIndex:indexPath.row];
    
    [self.delegate popAlarmPickView:upArray downArray:downArray data:data selectRow:indexPath];
    
   
//    AlarmPickView *alarmpickview=[AlarmPickView defaultPopupView];
//    alarmpickview.parentVC = self;
//    alarmpickview.delegate=self;
//    
//    alarmpickview.selectRow=indexPath;
//    
//    alarmpickview.titleValue=[data objectForKey:@"title"];
//    alarmpickview.updataArray=upArray;
//    alarmpickview.downDataArray=downArray;
//    alarmpickview.upValue=[data objectForKey:@"upValue"];
//    alarmpickview.downValue=[data objectForKey:@"downValue"];
//    [alarmpickview makeView];
//    [self lew_presentPopupView:alarmpickview animation:[LewPopupViewAnimationSpring new] dismissed:^{
//        NSLog(@"动画结束");
//    }];
}


-(void)refashInRow:(NSIndexPath *)row upValue:(NSString *)upvalue downValue:(NSString *)downValue{
    
    //更新某个cell的值
    NSMutableDictionary *data=[dataArray objectAtIndex:row.row];
    [data setObject:upvalue forKey:@"upValue"];
    [data setObject:downValue forKey:@"downValue"];
    
    if (row.row==0) {
        _info.shousuoyadownvalue=downValue;
        _info.shousuoyaupvalue=upvalue;
    }
    else if (row.row==1){
        _info.shuzhangyadownvalue=downValue;
        _info.shuzhangyaupvalue=upvalue;
    }
    else if (row.row==2){
        _info.xueyangdownvalue=downValue;
        _info.xueyangupvalue=upvalue;
    }
    else if (row.row==3){
        _info.xinlvdownvalue=downValue;
        _info.xinlvupvalue=upvalue;
    }
    else if (row.row==4){
        _info.mailvdownvalue=downValue;
        _info.mailvupvalue=upvalue;
    }
    else if (row.row==5){
        _info.huxidownvalue=downValue;
        _info.huxiupvalue=upvalue;
    }
    
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:row, nil];
    [dataTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark-去掉多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

-(void)fullAlarmArray{
    if (dataArray) {
        [dataArray removeAllObjects];
    }
    else{
        dataArray=[[NSMutableArray alloc]init];
    }
    NSMutableDictionary *dic1=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"收缩压",@"title",_info.shousuoyadownvalue,@"downValue",_info.shousuoyaupvalue,@"upValue", nil];
    NSMutableDictionary *dic2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"舒张压",@"title",_info.shuzhangyadownvalue,@"downValue",_info.shuzhangyaupvalue,@"upValue", nil];
    NSMutableDictionary *dic3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"血氧",@"title",_info.xueyangdownvalue,@"downValue",_info.xueyangupvalue,@"upValue", nil];
    NSMutableDictionary *dic4=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"心率",@"title",_info.xinlvdownvalue,@"downValue",_info.xinlvupvalue,@"upValue", nil];
    NSMutableDictionary *dic5=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"脉率",@"title",_info.mailvdownvalue,@"downValue",_info.mailvupvalue,@"upValue", nil];
    NSMutableDictionary *dic6=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"呼吸",@"title",_info.huxidownvalue,@"downValue",_info.huxiupvalue,@"upValue", nil];
    
    [dataArray addObject:dic1];
    [dataArray addObject:dic2];
    [dataArray addObject:dic3];
    [dataArray addObject:dic4];
    [dataArray addObject:dic5];
    [dataArray addObject:dic6];
}

//默认
-(void)recoveDefault:(PersonSettingInfo *)info{
    _info=info;
    [self fullAlarmArray];
    [dataTableView reloadData];
}

@end
