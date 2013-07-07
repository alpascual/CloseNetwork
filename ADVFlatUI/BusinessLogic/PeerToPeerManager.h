//
//  PeerToPeerManager.h
//  AroundYou
//
//  Created by Albert Pascual on 6/18/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AroundProtocol.h"
#import "DatabaseUtils.h"

@interface PeerToPeerManager : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>


@property (strong, nonatomic) MCSession * session;
@property (strong, nonatomic) MCPeerID * myPeerId;
@property (strong, nonatomic) MCNearbyServiceBrowser *browser;
@property (strong, nonatomic) MCNearbyServiceAdvertiser * advertiser;
@property (strong, nonatomic) MCBrowserViewController *peerBrowser;
@property (nonatomic) MCSessionState globalState;
@property (strong, nonatomic) id <AroundProtocol> aroundDelegate;


- (MCBrowserViewController*) showViewController;

-(BOOL) sendTextOnly:(NSString *)textToSend;

@end
