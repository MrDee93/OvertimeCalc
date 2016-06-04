//
//  Faulter.h
//  Grocery Dude
//
//  Created by Dayan Yonnatan on 11/02/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Faulter : NSObject

+(void)faultObjectWithID:(NSManagedObjectID*)objectID inContext:(NSManagedObjectContext*)context;

@end
