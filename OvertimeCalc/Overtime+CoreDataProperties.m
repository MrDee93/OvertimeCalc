//
//  Overtime+CoreDataProperties.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 15/04/2018.
//  Copyright © 2018 Dayan Yonnatan. All rights reserved.
//
//

#import "Overtime+CoreDataProperties.h"

@implementation Overtime (CoreDataProperties)

+ (NSFetchRequest<Overtime *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Overtime"];
}

@dynamic customPay;
@dynamic date;
@dynamic hours;
@dynamic payrate;

@end
