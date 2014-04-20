#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import <CoreData/CoreData.h>


#import "Project.h"
#import "Task.h"
#import "Interruption.h"
#import "Cycle.h"


@interface CDDocument : CDVPlugin

@property (nonatomic, strong) CDVInvokedUrlCommand *currentcommand;
@property (nonatomic, strong) UIManagedDocument *tickDatabase;

- (void)sayHello:(CDVInvokedUrlCommand*)command;

- (void)startDatabase:(CDVInvokedUrlCommand*)command;


- (void)getProjects:(CDVInvokedUrlCommand*)command;
- (void)addProject:(CDVInvokedUrlCommand*)command;

- (void)getTasks:(CDVInvokedUrlCommand*)command;

- (void)getCycles:(CDVInvokedUrlCommand*)command;

- (void)getInterruptions:(CDVInvokedUrlCommand*)command;

@end