//
//  AlarmPickView.m
//  XBYL
//
//  Created by PC_201310113421 on 15/11/25.
//  Copyright © 2015年 罗娇. All rights reserved.
//

#import "AlarmPickView.h"
#import "LewPopupViewAnimationSpring.h"


@implementation AlarmPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
    }
    return self;
}


+ (instancetype)defaultPopupView{
    AlarmPickView *vc=[[AlarmPickView alloc]initWithFrame:CGRectMake(0,0, 320, 250)];
    return vc;
}

//填充数据
-(void)makeView{
    [upPickView selectRow:[self.upValue integerValue]-1 inComponent:0 animated:YES];
    [downPickView selectRow:[self.downValue integerValue]-1 inComponent:0 animated:YES];
    titleLabel.text=self.titleValue;
}
-(IBAction)complate:(id)sender{
    [self.delegate complateInRow:self.selectRow upValue:self.upValue downValue:self.downValue];
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}
-(IBAction)cancel:(id)sender{
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}
#pragma mark-UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView==upPickView) {
        self.upValue=[self.updataArray objectAtIndex:row];
    }
    else{
        self.downValue=[self.downDataArray objectAtIndex:row];
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView==upPickView) {
            return self.updataArray.count;
    }
    else{
            return self.downDataArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

        if (pickerView==upPickView) {
            return [NSString stringWithFormat:@"%@",[self.updataArray objectAtIndex:row]];
        }
        else{
            return [NSString stringWithFormat:@"%@",[self.downDataArray objectAtIndex:row]];
        }
    
}

@end
