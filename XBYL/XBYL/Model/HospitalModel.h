//
//  HospitalModel.h
//  XBYL
//
//  Created by 罗娇 on 16/1/29.
//  Copyright (c) 2016年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HospitalModel : NSManagedObject

@property (nonatomic, retain) NSString * hosName;
@property (nonatomic, retain) NSString * hosNo;
@property (nonatomic, retain) NSString * hosRight;

@end
