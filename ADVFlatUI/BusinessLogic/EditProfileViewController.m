//
//  EditProfileViewController.m
//  AroundYou
//
//  Created by Al Pascual on 6/20/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

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
	
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    
    self.nameLabel.textColor =  mainColor;
    self.nameLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    
    self.emailLabel.textColor =  mainColor;
    self.emailLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    
    self.bioLabel.textColor =  mainColor;
    self.bioLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    
    self.twitterLabel.textColor =  mainColor;
    self.twitterLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    
    self.phoneLabel.textColor =  mainColor;
    self.phoneLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender
{
    
}

@end
