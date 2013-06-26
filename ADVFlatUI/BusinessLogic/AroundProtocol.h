//
//  AroundProtocol.h
//  AroundYou
//
//  Created by Albert Pascual on 6/25/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AroundProtocol <NSObject>

@optional

- (void) chatArrived:(NSString*) rawMessage;

@end
