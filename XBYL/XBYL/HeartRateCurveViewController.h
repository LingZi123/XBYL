//
//  HeartRateCurveViewController.h
//  nstdDemo
//
//  Created by 罗娇 on 2017/7/22.
//  Copyright © 2017年 popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PatientInfo.h"

@protocol HeartRateCurveViewControllerDelegate <NSObject>

-(void)closeHeartRateViewController;

@end

@interface HeartRateCurveViewController : BaseViewController

@property(nonatomic,retain)PatientInfo *patientInfo;
@property(nonatomic,assign)id<HeartRateCurveViewControllerDelegate>delegate;

@end
