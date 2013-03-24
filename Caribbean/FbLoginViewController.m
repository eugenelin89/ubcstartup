//
//  FbLoginViewController.m
//  Caribbean
//
//  Created by Eugene Lin on 13-01-21.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "FbLoginViewController.h"
#import "AppDelegate.h"

@interface FbLoginViewController ()
@end

@implementation FbLoginViewController
@synthesize delegate = _delegate;
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
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    
    
    
    if(FBSession.activeSession.isOpen){
        // don't disable the login button so we won't ever get stuck here
        // not like it's gonna happen... but just in case...
    }else{
        self.loginButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)authButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [appDelegate openSessionWithAllowLoginUI:YES];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.delegate loggedIn];
    } else {
        
    }
}

@end
