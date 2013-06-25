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

@interface ChatController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource,MCBrowserViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;

@property (strong, nonatomic) PeerToPeerManager *manager;
@property (strong, nonatomic) NSTimer *delaytimer;

@end
