//
//  PickViewController.m
//  XBYL
//
//  Created by 罗娇 on 15/8/17.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import "PickViewController.h"

@interface PickViewController ()

@end

@implementation PickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeView{
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complate:)];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem=leftBar;
    self.navigationItem.rightBarButtonItem=rightBar;
    
    upPickView=[[UIPickerView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)-30)/2+20, 74, (CGRectGetWidth(self.view.bounds)-30)/2, CGRectGetHeight(self.view.frame)-84)];
    upPickView.delegate=self;
    upPickView.dataSource=self;
    upPickView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:upPickView];
    downPickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(10, 74, (CGRectGetWidth(self.view.bounds)-30)/2, CGRectGetHeight(self.view.frame)-84)];
    downPickerView.dataSource=self;
    downPickerView.delegate=self;
    downPickerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:downPickerView];
    
    [upPickView selectRow:[self.upValue integerValue]-1 inComponent:1 animated:YES];
    [downPickerView selectRow:[self.downValue integerValue]-1 inComponent:1 animated:YES];
}
-(void)complate:(id)sender{
    [self.delegate complateInRow:self.selectRow upValue:self.upValue downValue:self.downValue];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        return;
    }
    if (pickerView==upPickView) {
        self.upValue=[self.updataArray objectAtIndex:row];
    }
    else{
       self.downValue=[self.downDataArray objectAtIndex:row];
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView==upPickView) {
        if (component==0) {
            return 1;
        }
        else{
            return self.updataArray.count;
        }
    }
    else{
        if (component==0) {
            return 1;
        }
        else{
            return self.downDataArray.count;
        }
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        if (pickerView==upPickView) {
            return @"上限";
        }
        else{
            return @"下限";
        }
    }
    else{
        if (pickerView==upPickView) {
            return [NSString stringWithFormat:@"%@",[self.updataArray objectAtIndex:row]];
        }
        else{
            return [NSString stringWithFormat:@"%@",[self.downDataArray objectAtIndex:row]];
        }
    }
        
}
@end
