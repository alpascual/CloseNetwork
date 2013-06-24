//
//  ChatController.h
//  AroundYou
//
//  Created by Al Pascual on 6/24/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"


@interface ChatController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;

@end
