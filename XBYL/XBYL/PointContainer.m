//
//  PointContainer.m
//  nstdDemo
//
//  Created by 罗娇 on 2017/7/22.
//  Copyright © 2017年 popov. All rights reserved.
//

#import "PointContainer.h"

@interface PointContainer ()
@property (nonatomic , assign) NSInteger numberOfRefreshElements;

@property (nonatomic , assign) CGPoint *refreshPointContainer;

@end
@implementation PointContainer

- (void)dealloc
{
    free(self.refreshPointContainer);
    self.refreshPointContainer = NULL;
}

+ (PointContainer *)sharedContainer:(NSInteger)size
{
    static PointContainer *container_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        container_ptr = [[self alloc] init];
        container_ptr.refreshPointContainer = malloc(sizeof(CGPoint) * size);
        memset(container_ptr.refreshPointContainer, 0, sizeof(CGPoint) * size);
        container_ptr.kMaxContainerCapacity=size;
    });
    return container_ptr;
}


-(instancetype)initWithSize:(NSInteger )size{
    self=[super init];
    if (self) {
        self.refreshPointContainer = malloc(sizeof(CGPoint) * size);
        memset(self.refreshPointContainer, 0, sizeof(CGPoint) * size);
        self.kMaxContainerCapacity=size;
    }
    return self;
}
- (void)addPointAsRefreshChangeform:(CGPoint)point
{
    static NSInteger currentPointsCount = 0;
    if (currentPointsCount < self.kMaxContainerCapacity) {
        self.numberOfRefreshElements = currentPointsCount + 1;
        self.refreshPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != self.kMaxContainerCapacity - 1) {
            self.refreshPointContainer[workIndex] = self.refreshPointContainer[workIndex + 1];
            workIndex ++;
        }
        self.refreshPointContainer[self.kMaxContainerCapacity - 1] = point;
        self.numberOfRefreshElements = self.kMaxContainerCapacity;
    }
    
    //    printf("当前元素个数:%2d->",self.numberOfRefreshElements);
    //    for (int k = 0; k != kMaxContainerCapacity; ++k) {
    //        printf("(%4.0f,%4.0f)",self.refreshPointContainer[k].x,self.refreshPointContainer[k].y);
    //    }
    //    putchar('\n');
}

@end
