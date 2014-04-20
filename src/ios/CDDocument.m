#import "CDDocument.h"
#import <Cordova/CDV.h>

@implementation CDDocument


#pragma mark - JS EVENTS
//
// JS EVENTS
//
- (void)sayHello:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Hello - that's your plugin :)"];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startDatabase:(CDVInvokedUrlCommand*)command{
    //[self useDocument:command];
    self.currentcommand = command;
    
    if(!self.tickDatabase){
        NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Pomotask Database"];
        self.tickDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }//*/
    
}


//
// NATIVE FUNCTIONS
//


#pragma mark - BASE FUNCTIONS

-(void) setTickDatabase:(UIManagedDocument *)tickDatabase{
    if(_tickDatabase != tickDatabase){
        _tickDatabase = tickDatabase;
        [self useDocument: self.currentcommand];
    }
}

/* Inicia o uso do documento ::
 :: se o arquivo não aberto, ele é aberto
 :: se estiver fechado, ele é aberto     */
-(void)useDocument:(CDVInvokedUrlCommand*)command{
    //CDVPluginResult* pluginResult = nil;
    //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"UseDocument TRigged"];
    
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
    
    if( ![[NSFileManager defaultManager] fileExistsAtPath:[self.tickDatabase.fileURL path]] ){
        [self.tickDatabase saveToURL:self.tickDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"DB Created"];
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            
            [self saveInitialDataAtDatabase];

            
        }];
    }
    else if(self.tickDatabase.documentState==UIDocumentStateClosed){
        [self.tickDatabase openWithCompletionHandler:^(BOOL success) {
            
            
            if(success==NO){
                //NSLog(@"Abriu o db? %d", success);
                //abort();
                
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"DB ERROR at open"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                
            }
            else{
            
                [self saveInitialDataAtDatabase];
                
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"DB Opened"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                
            }
        
        }];
    }//*/
}

- (void)saveInitialDataAtDatabase{
    
    /* Creates Personal Project at frist Load the App */
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    request.predicate = [NSPredicate predicateWithFormat:@"name like 'Personal'"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [self.tickDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
    if(error){
        abort();
    }
    else if ([matches count]==0 || matches==nil) {
        Project * project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.tickDatabase.managedObjectContext];
        project.name = @"Personal";
        project.done = @NO;
        project.archived = @NO;
        project.creation_date = [NSDate date];
        project.indexPath = [NSNumber numberWithInt:0];
        [self.tickDatabase saveToURL:self.tickDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
    }

}


#pragma mark - REQUESTS FUNCTIONS

- (void)getProjects:(CDVInvokedUrlCommand*)command{
    self.currentcommand = command;
    
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"indexPath" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [self.tickDatabase.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *preResults = [[NSMutableArray alloc] init];
    
    //NSLog(@"Matches array: %@", [matches description]);
    
    
    [matches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Project * proj = (Project *) obj;
        NSNumber *indextPath = [NSNumber numberWithInteger:idx];
        //NSArray *item = [NSArray arrayWithObjects:proj.indexPath, proj.name, nil];
        //NSDictionary *item = [NSDictionary dictionaryWithObject:proj.name forKey:proj.indexPath.stringValue];
        NSDictionary *item = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:indextPath.stringValue, proj.name, nil] forKeys:[NSArray arrayWithObjects:@"id", @"name", nil]];
        [preResults addObject:item];
    }];
    
    //NSLog(@"preResults array: %@", [preResults description]);
    
    //CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:preResults];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:preResults];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.currentcommand.callbackId];
    
    /*
    if(error != nil){
        //NSLog(@"ERROR: %@", [error description]);
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"DB Opened"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    else if([matches count]>0){
        //NSLog(@"Last Object: %@", [matches lastObject]);
        if( [[matches lastObject] isMemberOfClass:[Project class]] ){
            Project *p = [matches lastObject];
            NSNumber * returnValue = [NSNumber numberWithInt: (p.indexPath.intValue + 1)];
            //NSLog(@"Proximo index: %@",returnValue);
            return returnValue;
        }
        
        //[context updatedObjects:]
        //project.name = name;
    }
    else{
        //NSLog(@"Non Previous objects. Return 0");
        return [NSNumber numberWithInt:0];
    }//*/
    
}

- (void)addProject:(CDVInvokedUrlCommand*)command{
    //NSLog(@"ADD PROJECT");
    self.currentcommand = command;
    NSString* name = [command.arguments objectAtIndex:0];
    //NSLog(@"ARG Name: %@", name);
    
    //do not allow creation of project with name Personal
    NSString *testName = [name lowercaseString];
    if( [[testName lowercaseString] isEqualToString:@"personal"] ){
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:[NSArray arrayWithObject:@"0"]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.currentcommand.callbackId];
    }
    else{
    
        //NSLog(@"Project Category:");
        //NSLog(@"Project name: %@", name);
        //NSLog(@"Context: %@", [context description]);
    
        Project *project = nil;
    
        //check if there is another project with this name
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
        NSError *error = nil;
        NSArray *matches = [self.tickDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
        //NSLog(@"Matches: %@", [matches description]);
    
        if (!matches || [matches count]>1) {
            //error
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:[NSArray arrayWithObject:@"0"]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.currentcommand.callbackId];
        }
        else if ([matches count]==0){
            //NSLog(@"new project inserted in DB");
            //NSNumber *idPath = [Project getLastProjectIndexPathInManagedObjectContext:context];
        
            //if( [idPath isEqualToNumber:[NSNumber numberWithInt:-1]]){
            //    NSLog(@"Error in finding IndexPath");
            //    return nil;
            //}
        
        
            project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.tickDatabase.managedObjectContext];
            project.name = name;
            project.done = @NO;
            project.archived = @NO;
            project.creation_date = [NSDate date];
            //project.indexPath = idPath;
            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:[NSArray arrayWithObject:@"1"]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.currentcommand.callbackId];
            
        }
        else{
            NSLog(@"There is another project with the same name. What to do??");
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:[NSArray arrayWithObject:@"NO"]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.currentcommand.callbackId];
        }
    }

}



- (void)getTasks:(CDVInvokedUrlCommand*)command{}

- (void)getCycles:(CDVInvokedUrlCommand*)command{}

- (void)getInterruptions:(CDVInvokedUrlCommand*)command{}





@end