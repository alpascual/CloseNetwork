//
//  PeerToPeerManager.m
//  AroundYou
//
//  Created by Albert Pascual on 6/18/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "PeerToPeerManager.h"

@implementation PeerToPeerManager


- (MCBrowserViewController*) showViewController
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
    
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerId discoveryInfo:nil serviceType:@"aroundme"];
    
    self.advertiser.delegate = self;
    
    [self.advertiser startAdvertisingPeer];
    
    
    //self.peer = [[MCPeerPickerViewController alloc] initWithBrowser:self.browser session:self.session];
    self.peerBrowser = [[MCBrowserViewController alloc] initWithBrowser:self.browser session:self.session];
    
    return self.peerBrowser;
      
}




#pragma mark - MCSessionDelegate

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"MCSessionDelegate :: didStartReceivingResourceWithName :: Received Resource %@ from %@",resourceName,peerID);
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"MCSessionDelegate :: didFinishReceivingResourceWithName :: Received Resource %@ from %@ with URL %@",resourceName,peerID, localURL);
}


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCSessionDelegate :: didReceiveData :: Received %@ from %@",[data description],peerID);
    
    //ACTION: Message received here
    // TODO: Create a delegate to receive messages
    NSString * message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Received Message" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
    
}

- (void)session:(MCSession *)session didReceiveResourceAtURL:(NSURL *)resourceURL fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCSessionDelegate :: didReceiveResourceAtURL :: Received Resource %@ from %@",[resourceURL description],peerID);
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCSessionDelegate :: didReceiveStream :: Received Stream %@ from %@",[stream description],peerID);
    
    
    
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    NSLog(@"MCSessionDelegate :: didChangeState :: PeerId %@ changed to state %d",peerID,state);
    
    
    
    if (state == MCSessionStateConnected && self.session) {
        
        NSError *error;
        
        // ACTION: Send messages here as broadcast!!!
        // TODO:  create a method to send messages
        [self.session sendData:[@"HELLO" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withMode:MCSessionSendDataReliable error:&error];
        
    }
    
}



- (BOOL)session:(MCSession *)session shouldAcceptCertificate:(SecCertificateRef)peerCert forPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCPickerViewControllerDelegate :: shouldAcceptCertificate from peerID :: %@",peerID);
    
    return TRUE;
    
}



#pragma mark - MCNearbyServiceAdvertiserDelegate



- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    
    NSLog(@"MCNearbyServiceAdvertiserDelegate :: didNotStartAdvertisingPeer :: %@",error);
    
}



- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler {
    
    NSLog(@"MCNearbyServiceAdvertiserDelegate :: didReceiveInvitationFromPeer :: peerId :: %@",peerID);
    
    invitationHandler(TRUE,self.session);
    
    
    
}



#pragma mark - MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    
    NSLog(@"MCNearbyServiceABrowserDelegate :: didNotStartBrowsingForPeers :: error :: %@",error);
    
    
    
}



- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    NSLog(@"MCNearbyServiceABrowserDelegate :: foundPeer :: PeerID : %@ :: DiscoveryInfo : %@",peerID,info.description);
    
    
    
    [self.browser invitePeer:peerID toSession:self.session withContext:[@"message here" dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
    
}



- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCNearbyServiceABrowserDelegate :: lostPeer :: PeerID : %@",peerID);
    
    
    
}


@end
