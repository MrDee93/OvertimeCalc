//
//  DatabaseManager.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 02/11/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "DatabaseManager.h"
#import <CoreData/CoreData.h>


@implementation DatabaseManager


-(instancetype)init {
    if(self = [super init]) {
        self.appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    }
    return self;
}

-(BOOL)removeAllData {
    __block NSError *errorCatcher;
    [self.appDelegate.managedObjectContext performBlockAndWait:^{
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Overtime"];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
        NSArray *allObjects = [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&errorCatcher];
        [allObjects enumerateObjectsUsingBlock:^(Overtime  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.appDelegate.managedObjectContext deleteObject:obj];
        }];
    }];
    if([self.appDelegate.managedObjectContext save:&errorCatcher]) {
        return YES;
    } else {
        // Handle error here.
        return NO;
    }
}


@end
