//
//  PointContainer.m
//  nstdDemo
//
//  Created by 罗娇 on 2017/7/22.
//  Copyright © 2017年 popov. All rights reserved.
//

#import "PointContainer.h"

@interface PointContainer ()
@property (nonatomic , assign) NSInteger numberOfHrElements;
@property (nonatomic , assign) NSInteger numberOfSpoElements;
@property (nonatomic , assign) NSInteger numberOfRespElements;

@property (nonatomic , assign) CGPoint *hrPointContainer;
@property (nonatomic , assign) CGPoint *spoPointContainer;
@property (nonatomic , assign) CGPoint *respPointContainer;
@end
@implementation PointContainer

- (void)dealloc
{
    free(self.hrPointContainer);
    self.hrPointContainer = NULL;
    free(self.respPointContainer);
    self.respPointContainer = NULL;
    free(self.spoPointContainer);
    self.spoPointContainer = NULL;
    
    self.numberOfRespElements=0;
    self.numberOfSpoElements=0;
    self.numberOfHrElements=0;
}

+ (PointContainer *)sharedContainer:(NSInteger)size
{
    static PointContainer *container_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        container_ptr = [[self alloc] init];
        container_ptr.hrPointContainer = malloc(sizeof(CGPoint) * size);
        memset(container_ptr.hrPointContainer, 0, sizeof(CGPoint) * size);
        
        container_ptr.spoPointContainer = malloc(sizeof(CGPoint) * size);
        memset(container_ptr.spoPointContainer, 0, sizeof(CGPoint) * size);
        
        container_ptr.respPointContainer = malloc(sizeof(CGPoint) * size);
        memset(container_ptr.respPointContainer, 0, sizeof(CGPoint) * size);
        
        container_ptr.kMaxContainerCapacity=size;
    });
    return container_ptr;
}


-(instancetype)initWithSize:(NSInteger )size{
    self=[super init];
    if (self) {
        self.hrPointContainer = malloc(sizeof(CGPoint) * size);
        memset(self.hrPointContainer, 0, sizeof(CGPoint) * size);
        
        self.spoPointContainer = malloc(sizeof(CGPoint) * size);
        memset(self.spoPointContainer, 0, sizeof(CGPoint) * size);
        
        self.respPointContainer = malloc(sizeof(CGPoint) * size);
        memset(self.respPointContainer, 0, sizeof(CGPoint) * size);
        
        self.kMaxContainerCapacity=size;

    }
    return self;
}
- (void)addPointAsHrChangeform:(CGPoint)point
{
    static NSInteger currentPointsCount = 0;
    if (currentPointsCount < self.kMaxContainerCapacity) {
        self.numberOfHrElements = currentPointsCount + 1;
        self.hrPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != self.kMaxContainerCapacity - 1) {
            self.hrPointContainer[workIndex] = self.hrPointContainer[workIndex + 1];
            workIndex ++;
        }
        self.hrPointContainer[self.kMaxContainerCapacity - 1] = point;
        self.numberOfHrElements = self.kMaxContainerCapacity;
    }
    
    //    printf("当前元素个数:%2d->",self.numberOfRefreshElements);
    //    for (int k = 0; k != kMaxContainerCapacity; ++k) {
    //        printf("(%4.0f,%4.0f)",self.refreshPointContainer[k].x,self.refreshPointContainer[k].y);
    //    }
    //    putchar('\n');
}

- (void)addPointAsSpoChangeform:(CGPoint)point
{
    static NSInteger currentPointsCount = 0;
    if (currentPointsCount < self.kMaxContainerCapacity) {
        self.numberOfSpoElements = currentPointsCount + 1;
        self.spoPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != self.kMaxContainerCapacity - 1) {
            self.spoPointContainer[workIndex] = self.spoPointContainer[workIndex + 1];
            workIndex ++;
        }
        self.spoPointContainer[self.kMaxContainerCapacity - 1] = point;
        self.numberOfSpoElements = self.kMaxContainerCapacity;
    }
    
    //    printf("当前元素个数:%2d->",self.numberOfRefreshElements);
    //    for (int k = 0; k != kMaxContainerCapacity; ++k) {
    //        printf("(%4.0f,%4.0f)",self.refreshPointContainer[k].x,self.refreshPointContainer[k].y);
    //    }
    //    putchar('\n');
}

- (void)addPointAsRespChangeform:(CGPoint)point
{
    static NSInteger currentPointsCount = 0;
    if (currentPointsCount < self.kMaxContainerCapacity) {
        self.numberOfRespElements = currentPointsCount + 1;
        self.respPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != self.kMaxContainerCapacity - 1) {
            self.respPointContainer[workIndex] = self.respPointContainer[workIndex + 1];
            workIndex ++;
        }
        self.respPointContainer[self.kMaxContainerCapacity - 1] = point;
        self.numberOfRespElements = self.kMaxContainerCapacity;
    }
    
    //    printf("当前元素个数:%2d->",self.numberOfRefreshElements);
    //    for (int k = 0; k != kMaxContainerCapacity; ++k) {
    //        printf("(%4.0f,%4.0f)",self.refreshPointContainer[k].x,self.refreshPointContainer[k].y);
    //    }
    //    putchar('\n');
}

-(void)clear{
    self.numberOfHrElements=0;
    self.numberOfSpoElements=0;
    self.numberOfRespElements=0;
//    self.hrPointContainer=nil;
//    self.respPointContainer=nil;
//    self.respPointContainer=nil;
}
@end
