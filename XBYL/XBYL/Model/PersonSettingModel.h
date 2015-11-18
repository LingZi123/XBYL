//
//  PersonSettingModel.h
//  
//
//  Created by 罗娇 on 15/9/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonSettingModel : NSManagedObject

@property (nonatomic, retain) NSString * shuzhangyaupvalue;
@property (nonatomic, retain) NSString * huxidownvalue;
@property (nonatomic, retain) NSString * xueyangdownvalue;
@property (nonatomic, retain) NSString * xueyangupvalue;
@property (nonatomic, retain) NSString * shousuoyadownvalue;
@property (nonatomic, retain) NSString * shuzhangyadownvalue;
@property (nonatomic, retain) NSString * shousuoyaupvalue;
@property (nonatomic, retain) NSString * huxiupvalue;
@property (nonatomic, retain) NSString * xinlvdownvalue;
@property (nonatomic, retain) NSString * xinlvupvalue;
@property (nonatomic, retain) NSString * mailvdownvalue;
@property (nonatomic, retain) NSString * mailvupvalue;
@property (nonatomic, retain) NSString * patientNo;

@end
