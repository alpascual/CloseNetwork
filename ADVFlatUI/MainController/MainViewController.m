//
//  MainViewController.m
//  ADVFlatUI
//
//  Created by Tope on 03/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "MainViewController.h"
#import "MainSideViewController.h"
#import "ControllerInfo.h"
#import "StoryboardInfo.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>


@interface MainViewController ()

@property (nonatomic, strong) NSArray* storyboards;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;

@end

@implementation MainViewController

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
	
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.layout.minimumInteritemSpacing = 10;
    self.layout.minimumLineSpacing = 10;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

    UIColor* darkColor = [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:0.8f];
    self.collectionView.backgroundColor = darkColor;

    
    ControllerInfo* profile3 = [[ControllerInfo alloc] initWithName:@"Your Profile" andControllerId:@"ProfileController3"];
    
    StoryboardInfo* profileStoryboard = [[StoryboardInfo alloc] initWithName:@"Main Menu" andStoryboardId:@"ProfileStoryboard"];
    profileStoryboard.controllers = @[profile3];
    
    ControllerInfo* feed1 = [[ControllerInfo alloc] initWithName:@"Who is around you?" andControllerId:@"FeedController1"];
    
    ControllerInfo* settings1 = [[ControllerInfo alloc] initWithName:@"Settings" andControllerId:@"SettingsController1"];
    
    StoryboardInfo* feedStoryboard = [[StoryboardInfo alloc] initWithName:@"" andStoryboardId:@"FeedStoryboard"];
    feedStoryboard.controllers = @[feed1];
    
    StoryboardInfo* settingsStoryboard = [[StoryboardInfo alloc] initWithName:@"" andStoryboardId:@"SettingsStoryboard"];
    settingsStoryboard.controllers = @[settings1];//, settings2];
    
    self.storyboards = @[profileStoryboard, feedStoryboard, settingsStoryboard];
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    self.swipeGesture.numberOfTouchesRequired = 1;
    self.swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
}

- (void)swipedScreen:(UISwipeGestureRecognizer*)gesture {
    
    UIView* view = gesture.view;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.75;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    [view removeFromSuperview];
    [view removeGestureRecognizer:self.swipeGesture];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    StoryboardInfo* storyboardInfo = self.storyboards[section];
    return storyboardInfo.controllers.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.storyboards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    StoryboardInfo* storyboardInfo = self.storyboards[indexPath.section];
    
    ControllerInfo* controllerInfo = storyboardInfo.controllers[indexPath.row];
    
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    label.text = controllerInfo.name;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView* headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        UILabel* label = (UILabel*)[headerView viewWithTag:1];
        
        StoryboardInfo* storyboardInfo = self.storyboards[indexPath.section];
        label.text = [storyboardInfo.name uppercaseString];
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18.0f];
        label.textColor = [UIColor whiteColor];
        
        reusableview = headerView;
    }
    
    
    return reusableview;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    StoryboardInfo* storyboardInfo = self.storyboards[indexPath.section];
    
    ControllerInfo* controllerInfo = storyboardInfo.controllers[indexPath.row];
    
    self.currentViewController = [self getControllerFromStoryboardInfo:storyboardInfo andControllerInfo:controllerInfo];
    
    UIViewController* controller = self.currentViewController;
    controller.view.frame = CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height);
    
    
    [controller.view addGestureRecognizer:self.swipeGesture];
    
    CGFloat yOffset = [controller isKindOfClass:[UINavigationController class]] ? -20 : 0;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];

    hud.labelText = @"Swipe right to dismiss";
    
    controller.view.frame = CGRectMake(320, yOffset, controller.view.frame.size.width, controller.view.frame.size.height);
    [self.view addSubview:controller.view];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         controller.view.frame = CGRectMake(0, yOffset, controller.view.frame.size.width, controller.view.frame.size.height);
                        
                     }
                     completion:^(BOOL finished){
                         
                         [MBProgressHUD hideHUDForView:controller.view animated:YES];
                         
                     }];
}

-(UIViewController*)getControllerFromStoryboardInfo:(StoryboardInfo*)storyboardInfo andControllerInfo:(ControllerInfo*)controllerInfo {
    
    if([storyboardInfo.name rangeOfString:@"Sidebar"].location == NSNotFound){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardInfo.storyboardId bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:controllerInfo.controllerId];
    }
    else{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardInfo.storyboardId bundle:nil];
        MainSideViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"MainSideViewController"];
        controller.controllerId = controllerInfo.controllerId;
        
        return controller;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
