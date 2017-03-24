//
//  Faulter.m
//  Grocery Dude
//
//  Created by Dayan Yonnatan on 11/02/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "Faulter.h"

@implementation Faulter


+(void)faultObjectWithID:(NSManagedObjectID *)objectID inContext:(NSManagedObjectContext *)context {
    
    if(!objectID || !context) {
        return;
    }
    
    [context performBlockAndWait:^{
        NSManagedObject *object = [context objectWithID:objectID];
        
        if(object.hasChanges) {
            NSError *error = nil;
            if(![context save:&error]) {
                NSLog(@"ERROR saving: %@", error);
            }
        }
        
        if(!object.isFault) {
            //NSLog(@"Faulting object %@ in context %@", object.objectID, context);
            [context refreshObject:object mergeChanges:NO];
        } else {
            //NSLog(@"Skipped faulting an object that is already a fault");
        }
        
        // Repeat the process if the context has a parent
        if(context.parentContext) {
            [self faultObjectWithID:objectID inContext:context.parentContext];
        }
        
    }];
    
    
    
    
}




@end
