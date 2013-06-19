//
//  PeerToPeerManager.m
//  AroundYou
//
//  Created by Albert Pascual on 6/18/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "PeerToPeerManager.h"

@implementation PeerToPeerManager


- (void) showViewController
{
    //self.peer = [[MCPeerPickerViewController alloc] init];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    NSUUID * uuid = [NSUUID UUID];    
    
    self.myPeerId = [[MCPeerID alloc] initWithDisplayName:[uuid UUIDString]];    
    NSString *serviceType=@"aroundme";     
    
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.myPeerId serviceType:serviceType];    
    self.browser.delegate=self;        
    
    self.session = [[MCSession alloc] initWithPeer:self.myPeerId securityIdentity:nil encryptionPreference:MCEncryptionNone];
    
    self.session.delegate = self;     
    
    NSLog(@"ViewController :: viewDidLoad (Starting Browse)");
    
    [self.browser startBrowsingForPeers];
}
@end
