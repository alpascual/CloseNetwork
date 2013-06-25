//
//  Messages.h
//  AroundYou
//
//  Created by Al Pascual on 6/25/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Messages : NSManagedObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * msg;

@end
