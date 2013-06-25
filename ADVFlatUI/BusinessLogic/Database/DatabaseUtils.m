//
//  DatabaseUtils.m
//  UnfollowersStats
//
//  Created by Al Pascual on 4/29/13.
//
//

#import "DatabaseUtils.h"

@implementation DatabaseUtils

- (id)init
{
    self = [super init];
    if ( self != nil) {
        NSPersistentStoreCoordinator *check = [self persistentStoreCoordinator];
        NSLog(@"Async persistent check %@", check);
    }
    
    return self;
}


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        _managedObjectContext = [NSManagedObjectContext new];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}



/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // assign the PSC to our app delegate ivar before adding the persistent store in the background
    // this leverages a behavior in Core Data where you can create NSManagedObjectContext and fetch requests
    // even if the PSC has no stores.  Fetch requests return empty arrays until the persistent store is added
    // so it's possible to bring up the UI and then fill in the results later
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    
    // prep the store path and bundle stuff here since NSBundle isn't totally thread safe
    NSPersistentStoreCoordinator* psc = _persistentStoreCoordinator;
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"History.sqlite"];
    
    // do this asynchronously since if this is the first time this particular device is syncing with preexisting
    // iCloud content it may take a long long time to download
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    // this needs to match the entitlements and provisioning profile
    //@"PW6XKXEGA2.com.alpascualCloudPro.Run"
    NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
    if (cloudURL) {
        NSLog(@"iCloud access at %@", cloudURL);
        // TODO: Load document...
        
        NSString* coreDataCloudContent = [[cloudURL path] stringByAppendingPathComponent:@"run_v3"];
        cloudURL = [NSURL fileURLWithPath:coreDataCloudContent];
        
        //  The API to turn on Core Data iCloud support here.
        NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@"com.alpascualcloud.run.3", NSPersistentStoreUbiquitousContentNameKey, cloudURL, NSPersistentStoreUbiquitousContentURLKey, [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,nil];
        
        NSError *error = nil;
        
        //[psc lock];
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible
             * The schema for the persistent store is incompatible with current managed object model
             Check the error message to determine what the actual problem was.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        //[psc unlock];
    }
    
    else {
        NSLog(@"No iCloud access");
        
        _persistentStoreCoordinator = nil;
        _persistentStoreCoordinator = [self persistentStoreCoordinatorNoCloud];
    }
    
    
    // tell the UI on the main thread we finally added the store and then
    // post a custom notification to make your views do whatever they need to such as tell their
    // NSFetchedResultsController to -performFetch again now there is a real store
    /*dispatch_async(dispatch_get_main_queue(), ^{
     NSLog(@"asynchronously added persistent store!");
     [[NSNotificationCenter defaultCenter] postNotificationName:@"RefetchAllDatabaseData" object:self userInfo:nil];
     });*/
    // });
    
    return _persistentStoreCoordinator;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorNoCloud {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"History.sqlite"];
	//
	// Set up the store.
	// For the sake of illustration, provide a pre-populated default store.
    //
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"History" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
    
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		//
		// Replace this implementation with code to handle the error appropriately.
        
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
        
		// Typical reasons for an error here includ e:
		//  The persistent store is not accessible
		//  The schema for the persistent store is incompatible with current managed object model
		// Check the error message to determine what the actual problem was.
        
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
    
    return _persistentStoreCoordinator;
}

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (NSArray *) getAllProfiles
{
    return [self getAnything:@"Profiles"];
}

- (NSArray *) getAllMessages
{
    return [self getAnything:@"Messages"];
}

-(NSArray *) getAnything:(NSString*)entityForName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityForName inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesSubentities:NO];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

/*
- (NSArray *) getAllFollowers {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"LastList" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesSubentities:NO];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;   
}


- (void) deleteAllFollowers:(NSArray *) followers {
    
    for (LastList *follower in followers) {
        [self.managedObjectContext deleteObject:follower];
        
    }
    [self.managedObjectContext save:nil];
}

- (void) addAllFollowers:(NSArray *) followers {
    
   for (NSString *username in followers)
   {
    
       LastList *oneList = [NSEntityDescription
                            insertNewObjectForEntityForName:@"LastList"
                            inManagedObjectContext:self.managedObjectContext];
       
       [oneList setUsername:username];
       
       NSError *error;
       if (![self.managedObjectContext save:&error]) {
           NSLog(@"Whoops, couldn't save user: %@", [error localizedDescription]);
    }
   }
    
}

- (void) addFollowersToHistory:(NSArray*) history
{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    
    for (NSString *username in history)
    {
        History *his = [NSEntityDescription
                        insertNewObjectForEntityForName:@"History"
                        inManagedObjectContext:self.managedObjectContext];
        
        [his setUsername:username];
        [his setWhen:dateString];
        [his setWhendate:currDate];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save history user: %@", [error localizedDescription]);
        }
    }
}

-(void) addCountHistory:(NSNumber*)totalCount
{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    
    HistoryCount *count = [NSEntityDescription
                            insertNewObjectForEntityForName:@"HistoryCount"
                            inManagedObjectContext:self.managedObjectContext];
    
    [count setCount:totalCount];
    [count setWhen:dateString];
    [count setWhendate:currDate];
}*/

/*- (NSArray *) getHistory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"History" inManagedObjectContext:self.managedObjectContext];
    
    
    // Sort using the timeStamp property..
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"whendate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}*/

/*- (NSMutableArray *) getHistoryFollowers:(NSString *) uniqueId {
    
    TODO
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Points" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uniqueId == %@", uniqueId]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return [[NSMutableArray alloc] initWithArray:fetchedObjects];
}*/

@end
