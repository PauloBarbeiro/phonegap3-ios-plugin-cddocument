//
//  Cycle.h
//  CordovaLib
//
//  Created by Paulo Ferreira on 18/04/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Cycle : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * relax;
@property (nonatomic, retain) Task *task;

@end
