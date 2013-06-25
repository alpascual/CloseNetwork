//
//  PeerToPeerManager.h
//  AroundYou
//
//  Created by Albert Pascual on 6/18/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface PeerToPeerManager : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

//@property (nonatomic,strong) MCPeerPickerViewController *peer;
@property (strong, nonatomic) MCSession * session;
@property (strong, nonatomic) MCPeerID * myPeerId;
@property (strong, nonatomic) MCNearbyServiceBrowser *browser;
@property (strong, nonatomic) MCNearbyServiceAdvertiser * advertiser;
@property (strong, nonatomic) MCBrowserViewController *peerBrowser;

- (MCBrowserViewController*) showViewController;

-(BOOL) sendTextOnly:(NSString *)textToSend;

@end
