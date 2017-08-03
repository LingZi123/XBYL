//
//  SurFaceView.m
//  nstdDemo
//
//  Created by 罗娇 on 2017/7/22.
//  Copyright © 2017年 popov. All rights reserved.
//

#import "SurFaceView.h"
#import "HeartLiveView.h"
#import "PointContainer.h"

@implementation SurFaceView
{
    
    UILabel *defatultSurFaceViewLabel;
    bool isOnline;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titileLabel];
        [self addSubview:self.heartView];
    }
    return self;
}

-(UILabel *)titileLabel{
    if (!_titileLabel) {
        _titileLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30)];
        _titileLabel.font=[UIFont systemFontOfSize:16];
        _titileLabel.textColor=[UIColor whiteColor];
    }
    return _titileLabel;
}

-(HeartLiveView *)heartView{
    if (!_heartView) {
        _heartView=[[HeartLiveView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titileLabel.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-CGRectGetMaxY(self.titileLabel.frame))];
        }
    return _heartView;
}
//设置默认的视图
-(void)setDefaultContentView{
    self.heartView.backgroundColor=[UIColor lightGrayColor];
    defatultSurFaceViewLabel.hidden=NO;
    isOnline=NO;
}

//设置在线视图
-(void)setOnlineContentView:(CGColorRef)color{
    if (isOnline) {
        return;
    }
    isOnline=YES;
    self.heartView.backgroundColor=[UIColor blackColor];
    self.heartView.color=color;
    defatultSurFaceViewLabel.hidden=YES;
    //    [heartView fireDrawingWithPoints:self.points pointsCount:self.currentPointsCount];
    
}

- (void)fireDrawingWithPoints:(CGPoint *)points pointsCount:(NSInteger)count{
    [self.heartView fireDrawingWithPoints:points pointsCount:count];
}
@end
