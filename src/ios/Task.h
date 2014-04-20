//
//  Task.h
//  CordovaLib
//
//  Created by Paulo Ferreira on 18/04/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cycle, Interruption, Project;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSNumber * indexPath;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * prediction;
@property (nonatomic, retain) NSNumber * today;
@property (nonatomic, retain) NSNumber * todayIndexPath;
@property (nonatomic, retain) NSNumber * unplanned;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *cycles;
@property (nonatomic, retain) NSSet *interruptions;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addCyclesObject:(Cycle *)value;
- (void)removeCyclesObject:(Cycle *)value;
- (void)addCycles:(NSSet *)values;
- (void)removeCycles:(NSSet *)values;

- (void)addInterruptionsObject:(Interruption *)value;
- (void)removeInterruptionsObject:(Interruption *)value;
- (void)addInterruptions:(NSSet *)values;
- (void)removeInterruptions:(NSSet *)values;

@end
