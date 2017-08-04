//
//  HeartLiveView.h
//  nstdDemo
//
//  Created by 罗娇 on 2017/7/22.
//  Copyright © 2017年 popov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HeartLiveView : UIView
- (void)fireDrawingWithPoints:(CGPoint *)points pointsCount:(NSInteger)count;
@property(nonatomic,assign)CGColorRef color;
@property(nonatomic,assign)BOOL fillModel;//填充模式

@end
