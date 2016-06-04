//
//  Overtime+CoreDataProperties.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 02/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Overtime.h"

NS_ASSUME_NONNULL_BEGIN

@interface Overtime (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *hours;

@end

NS_ASSUME_NONNULL_END
