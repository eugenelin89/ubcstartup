//
//  GamePlayingViewController.m
//  Caribbean
//
//  Created by Eugene Lin on 13-03-04.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "GamePlayingViewController.h"
#import "AppModel.h"
#import "TargetAnnotation.h"


@interface GamePlayingViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@end

@implementation GamePlayingViewController

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
    //CLLocationCoordinate2D currentLocation = [[AppModel sharedInstance] currentLocation];
    //MKCoordinateRegion region = [MapUtility mapDisplayRegionAtCenter:currentLocation withMapSpan:MKCoordinateSpanMake(MAP_DELTA_LAT,MAP_DELTA_LONG)];
    [self.mapView setRegion:self.mapRegion animated:NO];
    
    self.mapView.showsUserLocation = YES;
    TargetAnnotation *target = [[TargetAnnotation alloc] initWithTargetDic:self.targetDic];
    [self.mapView addAnnotation:target];
    
    self.navBar.tintColor = [UIColor colorWithRed:0.0 green:0.35 blue:0.0 alpha:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelGame:(id)sender
{
    [self.delegate cancelGame];
    //[[self presentingViewController] dismissViewControllerAnimated:NO completion:^{}];
}

@end
