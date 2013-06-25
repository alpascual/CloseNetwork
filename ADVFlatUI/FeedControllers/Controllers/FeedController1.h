//
//  FeedController1.h
//  ADVFlatUI
//
//  Created by Tope on 03/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeerToPeerManager.h"

@interface FeedController1 : UIViewController <UITableViewDataSource,MCBrowserViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView* feedTableView;
@property (nonatomic, strong) PeerToPeerManager *manager;
@property (nonatomic, strong) NSTimer *delaytimer;
@property (nonatomic, strong) NSMutableArray *airDropArray;

@end
