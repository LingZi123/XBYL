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

@implementation HeartLiveView

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
    CGFloat full_height = self.frame.size.height;
    CGFloat full_width = self.frame.size.width;
    CGFloat cell_square_width = 30;
    
    CGContextSetLineWidth(context, 0.2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    int pos_x = 1;
    while (pos_x < full_width) {
        CGContextMoveToPoint(context, pos_x, 1);
        CGContextAddLineToPoint(context, pos_x, full_height);
        pos_x += cell_square_width;
        
        CGContextStrokePath(context);
    }
    
    CGFloat pos_y = 1;
    while (pos_y <= full_height) {
        
        CGContextSetLineWidth(context, 0.2);
        
        CGContextMoveToPoint(context, 1, pos_y);
        CGContextAddLineToPoint(context, full_width, pos_y);
        pos_y += cell_square_width;
        
        CGContextStrokePath(context);
    }
    
    
    CGContextSetLineWidth(context, 0.1);
    
    cell_square_width = cell_square_width / 5;
    pos_x = 1 + cell_square_width;
    while (pos_x < full_width) {
        CGContextMoveToPoint(context, pos_x, 1);
        CGContextAddLineToPoint(context, pos_x, full_height);
        pos_x += cell_square_width;
        
        CGContextStrokePath(context);
    }
    
    pos_y = 1 + cell_square_width;
    while (pos_y <= full_height) {
        CGContextMoveToPoint(context, 1, pos_y);
        CGContextAddLineToPoint(context, full_width, pos_y);
        pos_y += cell_square_width;
        
        CGContextStrokePath(context);
    }
    
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    [self drawGrid];
    [self drawCurve];
}


@end
