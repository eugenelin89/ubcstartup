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


@interface ConfirmDateViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *dateImageView;

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
