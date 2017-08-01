//
//  PointContainer.h
//  nstdDemo
//
//  Created by 罗娇 on 2017/7/22.
//  Copyright © 2017年 popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PointContainer : NSObject

@property(nonatomic,assign)NSInteger kMaxContainerCapacity;
@property (nonatomic , readonly) NSInteger numberOfRefreshElements;
@property (nonatomic , readonly) NSInteger numberOfTranslationElements;
@property (nonatomic , readonly) CGPoint *refreshPointContainer;

+ (PointContainer *)sharedContainer:(NSInteger)size;

-(instancetype)initWithSize:(NSInteger )size;
//刷新变换
- (void)addPointAsRefreshChangeform:(CGPoint)point;

- (CGPoint)bubbleRefreshPoint:(NSInteger)viewWidth  viewHeight:(CGFloat)viewHeight array:(NSMutableArray *)array;
@end
