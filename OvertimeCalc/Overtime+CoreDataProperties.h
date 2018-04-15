//
//  Overtime+CoreDataProperties.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 15/04/2018.
//  Copyright © 2018 Dayan Yonnatan. All rights reserved.
//
//

#import "Overtime+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Overtime (CoreDataProperties)

+ (NSFetchRequest<Overtime *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *customPay;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSNumber *hours;
@property (nullable, nonatomic, copy) NSNumber *payrate;

@end

NS_ASSUME_NONNULL_END
