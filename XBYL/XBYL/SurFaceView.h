//
//  SurFaceView.h
//  nstdDemo
//
//  Created by 罗娇 on 2017/7/22.
//  Copyright © 2017年 popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeartLiveView.h"
@interface SurFaceView : UIView

@property (nonatomic,retain) UILabel *titileLabel;

//@property (nonatomic,retain) UIView *contentView;
@property(nonatomic,retain) HeartLiveView *heartView;


-(void)setDefaultContentView;//设置默认的视图
//设置在线视图
-(void)setOnlineContentView:(CGColorRef)color fullmodel:(BOOL)fullmodel;
- (void)fireDrawingWithPoints:(CGPoint *)points pointsCount:(NSInteger)count;

@end
