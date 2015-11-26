//
//  AlarmPickView.h
//  XBYL
//
//  Created by PC_201310113421 on 15/11/25.
//  Copyright © 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlarmPickViewDelegate <NSObject>

-(void)complateInRow:(NSIndexPath *)row upValue:(NSString *)upvalue downValue:(NSString*)downValue;

@end

@interface AlarmPickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIPickerView *upPickView;
    __weak IBOutlet UIPickerView *downPickView;
}
@property(nonatomic,copy)NSString *titleValue;
@property(nonatomic,copy) NSString *upValue;
@property(nonatomic,copy) NSString *downValue;
@property(nonatomic,retain)NSArray *updataArray;
@property(nonatomic,retain)NSArray *downDataArray;
@property(nonatomic,assign)NSIndexPath *selectRow;
@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;

+ (instancetype)defaultPopupView;
@property (nonatomic,assign)id<AlarmPickViewDelegate> delegate;
-(void)makeView;

@end
