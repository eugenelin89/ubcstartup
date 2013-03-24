//
//  BaseViewController.m
//  Caribbean
//
//  Created by Eugene Lin on 13-01-21.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "BaseViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "FbLoginViewController.h"

@interface BaseViewController ()<loginViewDelegate>

@end

@implementation BaseViewController

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
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    // For some reason, the call to openSessionWithAllowLoginUI:NO if called
    // in viewDidAppear, it will first log out and then log in.  But called
    // in the viewDidLoad, if already logged in we will received sessionChanged.
    // If not logged in, we will receive nothing.  That's why we put it here
    // instead of viewDidAppear, so we won't log ourselves out.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    if (FBSession.activeSession.isOpen) {
        
    } else {
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (FBSession.activeSession.isOpen) {
        
    } else {
        // If not logged in, we need to segue to the logging in view.
        
        // DISPLAY LOGIN VIEW MODALLY.
        // #TODO: Refactor and exract the code
        [self displayLogin];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loggedIn
{
    NSLog(@"loggedIn gets called...");
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
    } else {
        // DISPLAY LOGIN VIEW MODALLY.
        [self displayLogin];
    }
}

#pragma mark - Helper Mehtods
-(void)displayLogin
{
    FbLoginViewController *fbLVC = [[FbLoginViewController alloc] initWithNibName:@"FbLoginViewController" bundle:nil];
    fbLVC.delegate = self;
    [self presentViewController:fbLVC animated:YES completion:^(void){}];
    
}

-(void)fbLogout
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closeSession];
}


@end
