//
//  ConfirmDateViewController.m
//  Second Date
//
//  Created by Eugene Lin on 13-03-24.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "ConfirmDateViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SetupViewController.h"


@interface ConfirmDateViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *dateImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateNameLabel;

@end

@implementation ConfirmDateViewController

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
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *dateDic = [appDelegate.dataCache objectForKey:DATA_KEY_DATE];
    NSString *datePicUrl = [dateDic objectForKey:@"pic"];
    
    NSURL *nUrl = [NSURL URLWithString:datePicUrl];
    [self.dateImageView setImageWithURL:nUrl];
    self.dateNameLabel.text = [dateDic objectForKey:@"name"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmButtonClicked:(id)sender
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIViewController *setupViewController = appDelegate.setupViewController;
    if(setupViewController)
    {
        [self.navigationController popToViewController:setupViewController animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
