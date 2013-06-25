//
//  ChatController.h
//  AroundYou
//
//  Created by Al Pascual on 6/24/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "PeerToPeerManager.h"
#import "DatabaseUtils.h"
#import "TSMessage.h"

@interface ChatController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource,MCBrowserViewControllerDelegate>

/*@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) NSMutableArray *usernames;*/
@property (strong, nonatomic) NSArray *allMessages;

@property (strong, nonatomic) PeerToPeerManager *manager;
@property (strong, nonatomic) NSTimer *delaytimer;
@property (strong, nonatomic) NSString *myUsername;

@end
