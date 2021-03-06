//
//  SetupViewController.m
//  Second Date
//
//  Created by Eugene Lin on 13-03-23.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "SetupViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SetupViewController ()

@end

@implementation SetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
        NSLog(@"SetupView Appeared");
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSDictionary *dateDic = [appDelegate.dataCache objectForKey:DATA_KEY_DATE];
    
    
        if(dateDic){
            NSString *datePicUrl = [dateDic objectForKey:@"pic"];
        
            NSURL *nsurl = [NSURL URLWithString:datePicUrl];
        
            [self.dateImageView setImageWithURL:nsurl];
            //self.dateNameLabel.text = [dateDic objectForKey:@"name"];
        }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Get My FB Info
    [MainController getMyFbInfo:self];
    
    // Pre-fetch FB Friends from FB.
    // We know that we gonna need it in the next step.  So improve the experience by fetching it now.
    [MainController getMyFbFriends:self];
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.setupViewController = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Main Controller Delegate
-(void)myFbFriendsRetrieved:(NSDictionary *)friends
{
    NSArray *friendsArray = [friends objectForKey:@"data"];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.dataCache setObject:friendsArray forKey:DATA_KEY_FB_FRIENDS];
}

-(void)myFbInfoRetrieved:(NSDictionary *)me
{
    NSArray *myFbArray = [me objectForKey:@"data"];
    NSString *strUrl = [[myFbArray objectAtIndex:0] objectForKey:@"pic"];
    NSString *myName = [[myFbArray objectAtIndex:0] objectForKey:@"name"];
    NSURL *nUrl = [NSURL URLWithString:strUrl];
    [self.myProfileImageView setImageWithURL:nUrl];
    self.myNameLabel.text = myName;
}

@end
