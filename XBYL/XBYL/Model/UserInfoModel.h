//
//  UserInfoModel.h
//  XBYL
//
//  Created by 罗娇 on 16/1/29.
//  Copyright (c) 2016年 罗娇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfoModel : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * pwd;

@end
