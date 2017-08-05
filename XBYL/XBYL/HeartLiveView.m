//
//  HeartLiveView.m
//  nstdDemo
//
//  Created by 罗娇 on 2017/7/22.
//  Copyright © 2017年 popov. All rights reserved.
//

#import "HeartLiveView.h"


@interface HeartLiveView ()

@property (nonatomic , assign) CGPoint *points;
@property (nonatomic , assign) NSInteger currentPointsCount;

@end

@implementation HeartLiveView{
    CGFloat full_height;
    CGFloat full_width;
}

- (void)setPoints:(CGPoint *)points
{
    _points = points;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (void)drawGrid
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    full_height = self.frame.size.height;
    full_width = self.frame.size.width;
    CGFloat cell_square_width = 30;
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    //画第一条横线
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, full_width, 0);
    
    //画第二条横线
//    CGContextMoveToPoint(context, 0, full_height);
//    CGContextAddLineToPoint(context, full_width, full_height);
    
    CGContextStrokePath(context);
    
//    int pos_x = 1;
//    while (pos_x < full_width) {
//        CGContextMoveToPoint(context, pos_x, 1);
//        CGContextAddLineToPoint(context, pos_x, full_height);
//        pos_x += cell_square_width;
//        
//        CGContextStrokePath(context);
//    }
//    
//    CGFloat pos_y = 1;
//    while (pos_y <= full_height) {
//        
//        CGContextSetLineWidth(context, 0.2);
//        
//        CGContextMoveToPoint(context, 1, pos_y);
//        CGContextAddLineToPoint(context, full_width, pos_y);
//        pos_y += cell_square_width;
//        
//        CGContextStrokePath(context);
//    }
//    
//    
//    CGContextSetLineWidth(context, 0.1);
//    
//    cell_square_width = cell_square_width / 5;
//    pos_x = 1 + cell_square_width;
//    while (pos_x < full_width) {
//        CGContextMoveToPoint(context, pos_x, 1);
//        CGContextAddLineToPoint(context, pos_x, full_height);
//        pos_x += cell_square_width;
//        
//        CGContextStrokePath(context);
//    }
//    
//    pos_y = 1 + cell_square_width;
//    while (pos_y <= full_height) {
//        CGContextMoveToPoint(context, 1, pos_y);
//        CGContextAddLineToPoint(context, full_width, pos_y);
//        pos_y += cell_square_width;
//        
//        CGContextStrokePath(context);
//    }
//    
}

- (void)fireDrawingWithPoints:(CGPoint *)points pointsCount:(NSInteger)count
{
    self.currentPointsCount = count;
    self.points = points;
}

- (void)drawCurve
{
    if (self.currentPointsCount == 0) {
        return;
    }
    CGFloat curveLineWidth = 0.8;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, curveLineWidth);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.color);
    CGContextMoveToPoint(currentContext, self.points[0].x, self.points[0].y);

    for (int i = 1; i != self.currentPointsCount; ++ i) {
        if (self.points[i - 1].x < self.points[i].x) {
            CGContextAddLineToPoint(currentContext, self.points[i].x, self.points[i].y);
        } else {
            CGContextMoveToPoint(currentContext, self.points[i].x, self.points[i].y);
        }
    }
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

- (void)drawCurveWithFill
{
    if (self.currentPointsCount == 0) {
        return;
    }
    CGFloat curveLineWidth = 0.8;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, curveLineWidth);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor clearColor].CGColor);
    CGContextMoveToPoint(currentContext, self.points[0].x, self.points[0].y);
    
    CGPoint stardpoint=self.points[0];
    
    for (int i = 1; i != self.currentPointsCount; ++ i) {
        if (self.points[i - 1].x < self.points[i].x) {
            CGContextAddLineToPoint(currentContext, self.points[i].x, self.points[i].y);
        } else {
            //确定了起点
            stardpoint=CGPointMake(self.points[i].x,self.points[i].y);
            CGContextMoveToPoint(currentContext, self.points[i].x, self.points[i].y);
            
        }
    }
   
    //确定终点
    CGPoint endPoint=self.points[self.currentPointsCount-1];
    CGPoint xstartPoint=CGPointMake(stardpoint.x, full_height);
    CGPoint xendPoint=CGPointMake(endPoint.x, full_height);
    
    NSLog(@"xstartPoint.x=%f,xstartPoint.y=%f,xendPoint.x=%f,xendPoint.y=%f,stardpoint.x=%f,stardpoint.y=%f,endPoint.x=%f,endPoint.y=%f",xstartPoint.x,xstartPoint.y,xendPoint.x,xendPoint.y,stardpoint.x,stardpoint.y,endPoint.x,endPoint.y);
    
    CGContextAddLineToPoint(currentContext, xendPoint.x, xendPoint.y);
    CGContextAddLineToPoint(currentContext, xstartPoint.x, xstartPoint.y);
    CGContextSetFillColorWithColor(currentContext,[UIColor redColor].CGColor);
    CGContextFillPath(currentContext);//填充路径
    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    CGContextClosePath(currentContext);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawGrid];
    if (self.fillModel) {
        [self drawCurveWithFill];
    }
    else{
        [self drawCurve];
    }
}


@end
