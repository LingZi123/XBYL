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
@property (nonatomic , readonly) NSInteger numberOfHrElements;
@property (nonatomic , readonly) NSInteger numberOfSpoElements;
@property (nonatomic , readonly) NSInteger numberOfRespElements;
@property (nonatomic , readonly) CGPoint *hrPointContainer;
@property (nonatomic , readonly) CGPoint *spoPointContainer;
@property (nonatomic , readonly) CGPoint *respPointContainer;

+ (PointContainer *)sharedContainer:(NSInteger)size;

-(instancetype)initWithSize:(NSInteger )size;
//刷新变换
- (void)addPointAsHrChangeform:(CGPoint)point;
- (void)addPointAsSpoChangeform:(CGPoint)point;
- (void)addPointAsRespChangeform:(CGPoint)point;

- (CGPoint)bubbleRefreshPoint:(NSInteger)viewWidth  viewHeight:(CGFloat)viewHeight array:(NSMutableArray *)array;
@end
