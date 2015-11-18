//
//  HospitalModel.h
//  
//
//  Created by 罗娇 on 15/8/30.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HospitalModel : NSManagedObject

@property (nonatomic, retain) NSString * hosNo;
@property (nonatomic, retain) NSString * hosRight;
@property (nonatomic, retain) NSString * hosName;

@end
