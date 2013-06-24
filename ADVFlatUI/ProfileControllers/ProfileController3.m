//
//  ProfileController3.m
//  ADVFlatUI
//
//  Created by Tope on 31/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ProfileController3.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileController3 ()

@end

@implementation ProfileController3

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
	
    [self setLabels];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setLabels];
}

- (void) setLabels
{
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* imageBorderColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.4f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
      
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    self.nameLabel.textColor =  mainColor;
    self.nameLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    self.nameLabel.text = [defaults objectForKey:@"name"];
    
    self.usernameLabel.textColor =  mainColor;
    self.usernameLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.usernameLabel.text = [[NSString alloc] initWithFormat:@"@%@", [defaults objectForKey:@"twitter"] ];
    
    UIFont* countLabelFont = [UIFont fontWithName:boldItalicFontName size:20.0f];
    UIColor* countColor = mainColor;
    
    self.followerCountLabel.textColor =  countColor;
    self.followerCountLabel.font =  countLabelFont;
    self.followerCountLabel.text = [defaults objectForKey:@"email"];
    
    self.followingCountLabel.textColor =  countColor;
    self.followingCountLabel.font =  countLabelFont;
    self.followingCountLabel.text = [defaults objectForKey:@"phone"];
    
    self.updateCountLabel.textColor =  countColor;
    self.updateCountLabel.font =  countLabelFont;
    self.updateCountLabel.text = @"20k";
    
    UIFont* socialFont = [UIFont fontWithName:boldItalicFontName size:10.0f];
    
    self.followerLabel.textColor =  mainColor;
    self.followerLabel.font =  socialFont;
    self.followerLabel.text = @"EMAIL";
    
    self.followingLabel.textColor =  mainColor;
    self.followingLabel.font =  socialFont;
    self.followingLabel.text = @"PHONE";
    
    self.updateLabel.textColor =  mainColor;
    self.updateLabel.font =  socialFont;
    self.updateLabel.text = @"UPDATES";
    
    self.bioLabel.textColor =  mainColor;
    self.bioLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.bioLabel.text =  [defaults objectForKey:@"bio"];
    
    
    //TODO, let the user click the image to change it
    // change that for the twitter image
    if ( [defaults objectForKey:@"profile_Image"] != nil) {
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_Image"];        
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }
    else {
        //self.profileImageView.image = [UIImage imageNamed:@"profile.jpg"];
        // Show cool alert TSMessage to click to set their image
        
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Image not set"
                                        withMessage:@"Click the image circle to upload your picture."
                                           withType:TSMessageNotificationTypeWarning];
        
    }
    
    
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.cornerRadius = 55.0f;
    self.profileImageView.layer.borderColor = imageBorderColor.CGColor;
    
    //Set a tap on the image
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(clickEventOnImage:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [tapRecognizer setDelegate:self];
    //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
    self.profileImageView.userInteractionEnabled = YES;
    [self.profileImageView addGestureRecognizer:tapRecognizer];
    
    self.bioContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bioContainer.layer.borderWidth = 4.0f;
    self.bioContainer.layer.cornerRadius = 5.0f;
    
    [self addDividerToView:self.scrollView atLocation:230];
    [self addDividerToView:self.scrollView atLocation:300];
    [self addDividerToView:self.scrollView atLocation:370];
    
    self.scrollView.contentSize = CGSizeMake(320, 590);
    self.scrollView.backgroundColor = [UIColor whiteColor];
}


-(void) clickEventOnImage:(id) sender
{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
                didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"returned from library");
    
    self.profileImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:UIImagePNGRepresentation(self.profileImageView.image) forKey:@"profile_Image"];
    [defaults synchronize];
   
}

-(void)styleFriendProfileImage:(UIImageView*)imageView withImageNamed:(NSString*)imageName andColor:(UIColor*)color{
    
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 4.0f;
    imageView.layer.borderColor = color.CGColor;
    imageView.layer.cornerRadius = 35.0f;
}

-(void)addDividerToView:(UIView*)view atLocation:(CGFloat)location{
    
    UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(20, location, 280, 1)];
    divider.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.7f];
    [view addSubview:divider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editPressed:(id)sender
{
    [self performSegueWithIdentifier:@"editSegue" sender:self];
}

@end
