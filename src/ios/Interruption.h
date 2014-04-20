//
//  Interruption.h
//  CordovaLib
//
//  Created by Paulo Ferreira on 18/04/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Interruption : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * nature;
@property (nonatomic, retain) Task *task;

@end
