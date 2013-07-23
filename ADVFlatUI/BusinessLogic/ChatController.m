//
//  ChatController.m
//  AroundYou
//
//  Created by Al Pascual on 6/24/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ChatController.h"

@interface ChatController ()

@end

@implementation ChatController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"Messages";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey:@"name"] != nil )
        self.myUsername = [defaults objectForKey:@"name"];
    else
    {
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Profile missing"
                                        withMessage:@"Set your profile before using messages."
                                           withType:TSMessageNotificationTypeError];
        return;
    }
    
    /*self.messages = [[NSMutableArray alloc] initWithObjects:
                     @"Testing some messages here.",
                     @"This work is based on Sam Soffes' SSMessagesViewController.",
                     @"This is a complete re-write and refactoring.",
                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
                     nil];
    
    self.timestamps = [[NSMutableArray alloc] initWithObjects:
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate date],
                       nil];*/
    
    /*self.messages = [[NSMutableArray alloc] init];
    self.timestamps = [[NSMutableArray alloc] init];
    self.usernames = [[NSMutableArray alloc] init];*/
    //TODO maybe restore the previous session?
    
    self.databaseUtils = [[DatabaseUtils alloc] init];
    self.allMessages = [self.databaseUtils getAllMessages];
    /*for (Messages *message in self.allMessages) {
        [self.messages addObject:message.msg];
        [self.timestamps addObject:message.timestamp];
        [self.usernames addObject:message.username];
    }*/
    
    self.manager = [[PeerToPeerManager alloc] init];
    self.manager.aroundDelegate = self;
    
    self.delaytimer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:
                       @selector(delayManager:) userInfo:nil repeats:NO];
}

- (void)delayManager:(NSTimer *)timer
{
    [timer invalidate];
    timer = nil;
    
    [self.manager showViewController];    
    self.manager.peerBrowser.delegate = self;
    [self presentViewController:self.manager.peerBrowser animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.messages.count;
    return self.allMessages.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{    
    NSString *toSend = [[NSString alloc] initWithFormat:@"!%@,%@", self.myUsername, text];
    
    BOOL bReturn = [self.manager sendTextOnly:toSend];
    
    if ( bReturn == YES) {
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Message Sent"
                                        withMessage:@"Message was sent to the connected people."
                                           withType:TSMessageNotificationTypeSuccess];
        
        [JSMessageSoundEffect playMessageSentSound];
        
        [self.databaseUtils addMessages:self.myUsername msg:text];
        self.allMessages = [self.databaseUtils getAllMessages];
        
        [self finishSend];
    }
    else
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Message Failed"
                                        withMessage:@"Message failed to be sent."
                                           withType:TSMessageNotificationTypeError];
        
    //ACTION: Send this message if connected
    
    
    //[self.messages addObject:text];
    
    //[self.timestamps addObject:[NSDate date]];
    
    //if((self.messages.count - 1) % 2)
        
    /*else
        [JSMessageSoundEffect playMessageReceivedSound];*/
    
    
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Messages * message = [self.allMessages objectAtIndex:indexPath.row];
    if ( [message.username isEqualToString:self.myUsername])
        return JSBubbleMessageStyleIncomingDefault;
    
    return JSBubbleMessageStyleOutgoingDefault;
    // TODO, check who send it and send the correct flag
    //return (indexPath.row % 2) ? JSBubbleMessageStyleIncomingDefault : JSBubbleMessageStyleOutgoingDefault;
}

- (JSMessagesViewTimestampPolicy)timestampPolicyForMessagesView
{
    return JSMessagesViewTimestampPolicyAll;
}

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // custom implementation here, if using `JSMessagesViewTimestampPolicyCustom`
    return [self shouldHaveTimestampForRowAtIndexPath:indexPath];
}

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Messages * message = [self.allMessages objectAtIndex:indexPath.row];
    
    NSString *field = [[NSString alloc] initWithFormat:@"%@ : %@", message.username, message.msg];
    return field;
    
    //return message.msg;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Messages * message = [self.allMessages objectAtIndex:indexPath.row];    
    return message.timestamp;
}

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"all invited peer %@ with info %@", peerID, info);
    return YES;
}


// Add it into the database
- (void) chatArrived:(NSString*) rawMessage
{
    if ( [rawMessage characterAtIndex:0] == '!') {
        
        NSArray *list = [rawMessage componentsSeparatedByString:@","];
        
        // Glab username
        NSString *theUsername = [list objectAtIndex:0];
        theUsername = [theUsername substringFromIndex:1];
        
        //Grab message
        NSMutableString *theText = [[NSMutableString alloc] init];
        for (int i=1; i<list.count; i++) {
            [theText appendString:[list objectAtIndex:i]];
        }
        
        [self.databaseUtils addMessages:theUsername msg:theText];
        self.allMessages = [self.databaseUtils getAllMessages];
        
        [self.tableView reloadData];
    }
}

- (void) profileArrived:(NSString*) rawMessage
{
    //NSString *profileToSend = [[NSString alloc] initWithFormat:@"@%@,%@,%@,%@,%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"email"], [defaults objectForKey:@"phone"], [defaults objectForKey:@"twitter"], [defaults objectForKey:@"bio"] ];
    
    if ( [rawMessage characterAtIndex:0] == '@') {
        NSArray *list = [rawMessage componentsSeparatedByString:@","];
        if ( list.count > 4) {
            NSString *cleanName = [list objectAtIndex:0];
            cleanName = [cleanName substringFromIndex:1];
            
            self.lastName = cleanName;
            
            NSMutableArray *profilesWithThatName = [self.databaseUtils getProfileByName:cleanName];
            if ( profilesWithThatName.count == 0) {
                // Now is save to insert
                [self.databaseUtils addProfile:cleanName withTwitter:[list objectAtIndex:3] andPhone:[list objectAtIndex:2] emailAddress:[list objectAtIndex:1] image:nil];
            }
        }
    }
}

- (void) pictureArrived:(NSData*) rawMessage
{
    [self.databaseUtils addPictureForUsername:self.lastName withPicture:rawMessage];
}

@end
