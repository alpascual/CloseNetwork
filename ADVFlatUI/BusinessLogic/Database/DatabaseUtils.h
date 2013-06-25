//
//  DatabaseUtils.h
//  UnfollowersStats
//
//  Created by Al Pascual on 4/29/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Messages.h"
#import "Profiles.h"

@interface DatabaseUtils : NSObject

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSString *)applicationDocumentsDirectory;

- (NSArray *) getAllProfiles;
- (NSArray *) getAllMessages;
- (NSArray *) getAnything:(NSString*)entityForName;

- (void) addMessages:(NSString*)username msg:(NSString*)message;
- (void) addProfile:(NSString*)username withTwitter:(NSString*)twitter andPhone:(NSString*)phone emailAddress:(NSString*)email image:(NSData*)picture;

@end
