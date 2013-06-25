//
//  Profiles.h
//  AroundYou
//
//  Created by Al Pascual on 6/25/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profiles : NSManagedObject

@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone;

@end
