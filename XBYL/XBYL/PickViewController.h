//
//  PickViewController.h
//  XBYL
//
//  Created by 罗娇 on 15/8/17.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickViewControllerDelegate <NSObject>

-(void)complateInRow:(NSIndexPath *)row upValue:(NSString *)upvalue downValue:(NSString*)downValue;

@end

@interface PickViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
     UIPickerView *upPickView;
     UIPickerView *downPickerView;
}
@property(nonatomic,copy) NSString *upValue;
@property(nonatomic,copy) NSString *downValue;
@property(nonatomic,retain)NSArray *updataArray;
@property(nonatomic,retain)NSArray *downDataArray;
@property(nonatomic,assign)NSIndexPath *selectRow;
@property (nonatomic,assign)id<PickViewControllerDelegate> delegate;


@end
