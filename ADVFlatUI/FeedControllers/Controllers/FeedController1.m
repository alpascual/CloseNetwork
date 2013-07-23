//
//  FeedController1.m
//  ADVFlatUI
//
//  Created by Tope on 03/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FeedController1.h"
#import "FeedCell1.h"

@interface FeedController1 ()

@end

@implementation FeedController1

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
	
    NSString* boldFontName = @"GillSans-Bold";
   // self edgesForExtendedLayout ExtendedEdgesForLayout

    [self styleNavigationBarWithFontName:boldFontName];
    
    self.title = @"Around you";
    
    self.manager = [[PeerToPeerManager alloc] init];
    self.manager.aroundDelegate = self;
    
    self.databaseUtils = [[DatabaseUtils alloc] init];
    
    self.delaytimer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:
                       @selector(delayManager:) userInfo:nil repeats:NO];
    
    // create the database source around here?
    
    self.feedTableView.dataSource = self;
    
    self.feedTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.feedTableView.separatorColor = [UIColor clearColor];
    
}

- (void)delayManager:(NSTimer *)timer
{
    [timer invalidate];
    timer = nil;
    
    // Maybe does not need to show people around you at all
    [self.manager showViewController];
    self.manager.peerBrowser.delegate = self;
    [self presentViewController:self.manager.peerBrowser animated:YES completion:nil];
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

// Picker controller delegate
// Notifies the delegate, when the user presses start or when all invited peers have either accepted or rejected invitations.
/*- (void)peerPickerViewController:(MCPeerPickerViewController *)picker didConnectPeers:(NSArray *)peerIDs
{
    NSLog(@"all invited peers %@", peerIDs);
    //self.airDropArray = peerIDs;
    // Build the array
    
    [self.feedTableView reloadData];
}*/

// Notifies delegate that the user cancelled the picker.
/*- (void)peerPickerViewControllerWasCancelled:(MCPeerPickerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Notifies delegate that a peer was found; discoveryInfo can be used to determine whether the peer should be presented to the user, and the delegate should return a YES if the peer should be presented; this method is optional, if not implemented every nearby peer will be presented to the user.
- (BOOL)peerPickerViewController:(MCPeerPickerViewController *)picker shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    return YES;
}*/



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.allProfiles = [self.databaseUtils getAllProfiles];
    
    return self.allProfiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedCell1* cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell1"];
    
    Profiles *tempProfile = [self.allProfiles objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = tempProfile.name;
    cell.updateLabel.text = tempProfile.twitter;
    cell.likeCountLabel.text = tempProfile.email;
    cell.commentCountLabel.text = tempProfile.phone;
    cell.picImageView.image = [UIImage imageWithData:tempProfile.picture];
    
    
    /*if(indexPath.row % 2){
        cell.nameLabel.text = @"Laura Leamington";
        cell.updateLabel.text = @"This is a pic I took while on holiday on Wales. The weather played along nicely which doesn't happen often";

        cell.dateLabel.text = @"1 hr ago";
        cell.likeCountLabel.text = @"293";
        cell.commentCountLabel.text = @"55";
        cell.picImageView.image = [UIImage imageNamed:@"feed-armchair.jpg"];
    }
    else{
        cell.nameLabel.text = @"John Keynetown";
        cell.updateLabel.text = @"On the trip to San Fransisco, the Golden gate bridge looked really magnificent. This is a city I would love to visit very often. Hope we get to do it again soon";
        
        cell.dateLabel.text = @"1 hr ago";
        cell.likeCountLabel.text = @"134";
        cell.commentCountLabel.text = @"21";
        cell.picImageView.image = [UIImage imageNamed:@"feed-bridge.jpg"];
    }
    */
    
    return cell;
}

-(void)styleNavigationBarWithFontName:(NSString*)navigationTitleFont{
    
    
    CGSize size = CGSizeMake(320, 44);
    UIColor* color = [UIColor colorWithRed:65.0/255 green:75.0/255 blue:89.0/255 alpha:1.0];
    
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UINavigationBar* navAppearance = [UINavigationBar appearance];
    
    [navAppearance setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [navAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor whiteColor], UITextAttributeTextColor,
                                           [UIFont fontWithName:navigationTitleFont size:18.0f], UITextAttributeFont,
                                           nil]];
    
    UIImageView* searchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    searchView.frame = CGRectMake(0, 0, 20, 20);
    
    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchView];
    
    self.navigationItem.rightBarButtonItem = searchItem;
    
    
    UIImageView* menuView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu.png"]];
    menuView.frame = CGRectMake(0, 0, 28, 20);
    
    UIBarButtonItem* menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuView];
    
    self.navigationItem.leftBarButtonItem = menuItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
}

- (void) pictureArrived:(NSData*) rawMessage
{
    [self.databaseUtils addPictureForUsername:self.lastName withPicture:rawMessage];
}

@end
