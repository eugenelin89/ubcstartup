//
//  ViewController.m
//  Caribbean
//
//  Created by Eugene Lin on 13-01-21.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AppModel.h"
#import "TargetViewCell.h"
#import "MapViewCell.h"
#import "TargetAnnotation.h"
#import "GameDetailViewController.h"
#import "MapUtility.h"

@interface ViewController ()<UIActionSheetDelegate, AppModelDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeMapButton;
@property (nonatomic) Boolean isFullMap;
@property (strong, nonatomic) NSArray *targets; // array of dics for each target
@property (strong, nonatomic) NSArray *annotations;
@property (weak, nonatomic) IBOutlet UIView *fbLoginView;

@end

@implementation ViewController
@synthesize isFullMap = _isFullMap;
@synthesize targets = _targets;
@synthesize annotations = _annotations;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"ViewController viewDidLoad");    
    CLLocationCoordinate2D currentLocation = [[AppModel sharedInstance] currentLocation];
    NSLog(@"(viewDidLoad) centered at %f, %f",currentLocation.latitude, currentLocation.longitude);

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(significantLocationChanged)
     name:SignificantLocationChageNotification
     object:nil];
    
    // create the map
    CGRect mapframe = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, MAP_CELL_HEIGHT);
    self.mapView = [[MKMapView alloc] initWithFrame:mapframe];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0 green:0.35 blue:0.0 alpha:0.1];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"ViewController viewDidAppear");
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self hideFbLoginViewWithAnimateDuration:0 andDelay:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[TargetAnnotation class]]){
        NSLog(@"sent from annotation");
        ((GameDetailViewController *)segue.destinationViewController).targetDic = ((TargetAnnotation*)sender).targetDic;
    }else if([sender isKindOfClass:[UITableView class]]){
        NSLog(@"sent from table view");
        UITableView *tableView = (UITableView *)sender;
        int index = [tableView indexPathForSelectedRow].row - 1;
        ((GameDetailViewController *)segue.destinationViewController).targetDic = [self.targets objectAtIndex:index];
    }
}

#pragma mark - Table View Data Source and Delegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.targets.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row == 0){
        // this is the map
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"MapView"];
        if(!cell){
            cell = [[MapViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MapView"];
        }
        if(cell.contentView.subviews.count == 0 || ![[cell.contentView.subviews objectAtIndex:0] isKindOfClass:[MKMapView class]])
            [cell.contentView addSubview:self.mapView];
    }else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"TargetView"];
        if(!cell){
            cell = [[TargetViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TargetView"];
        }
        //NSString *temp = [NSString stringWithFormat:@"section: %d, row: %d", indexPath.section, indexPath.row];
        //cell.textLabel.text = temp;
        NSDictionary *targetDic = [self.targets objectAtIndex:indexPath.row-1];
        ((TargetViewCell *)cell).targetTextLabel.text = [targetDic objectForKey:@"title"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell Clicked, section = %d, row = %d", indexPath.section, indexPath.row);
    if(indexPath.row == 0){
        [self resizeMap:YES];
    }else{
        [self.mapView selectAnnotation:[self.annotations objectAtIndex:indexPath.row - 1]  animated:YES];
        [self performSegueWithIdentifier:@"GameDetailSegue" sender:tableView];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if(indexPath.row == 0){
        // map
        if(self.isFullMap){
            //height = [[UIScreen mainScreen] bounds].size.height;
            height = self.view.frame.size.height;
        }else{
            height = MAP_CELL_HEIGHT;
        }
         
    }else{
        height = self.tableView.rowHeight;
    }
    return height;
}

#pragma mark - MapView Delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"TargetAnnotation"];
    if(!aView)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TargetAnnotation"];
        
    }
    
    aView.canShowCallout = YES;
    aView.enabled = YES;
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return aView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"annotation callout tapped");
    TargetAnnotation *anno = view.annotation;
    [self performSegueWithIdentifier:@"GameDetailSegue" sender:anno];
}

#pragma mark - ActionSheet Delegate
/// not used
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == [actionSheet destructiveButtonIndex]){
        NSLog(@"Logging Out!");
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate closeSession];
    }
}

#pragma mark - AppModel Delegate
-(void)receivedTargets:(NSArray *)targets
{
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    NSMutableArray *mutableTargets = [[NSMutableArray alloc] initWithCapacity:targets.count];
    for(NSDictionary *dic in targets){
        double dist = [self distFromCurrentLocation:[self convertToCLLocation:[dic objectForKey:@"loc"]]];
        NSMutableDictionary *mutableDic = [dic mutableCopy];
        [mutableDic setObject:[NSString stringWithFormat:@"%f",dist] forKey:@"dist"];
        [mutableTargets addObject:mutableDic];
    }
    
    
    NSArray *sortedArray = [mutableTargets sortedArrayUsingComparator:^NSComparisonResult(id dic1, id dic2){
        if([[dic1 objectForKey:@"dist"] doubleValue] < [[dic2 objectForKey:@"dist"] doubleValue])
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    // Doing the annotations array here so it's the same order as the sorted array of dicts.
    NSMutableArray *mutableAnnotations = [[NSMutableArray alloc] initWithCapacity:targets.count];
    for(NSDictionary *dic in sortedArray){
        TargetAnnotation *target = [[TargetAnnotation alloc] initWithTargetDic:dic];
        [mutableAnnotations addObject:target];
    }
    [self.mapView addAnnotations:mutableAnnotations];

    self.annotations = mutableAnnotations;
    self.targets = sortedArray;
    
    [self.tableView reloadData];
    
    NSLog(@"Sorted Targets: %@", self.targets);

}

-(CLLocation *)convertToCLLocation:(NSArray *)coordArray
{
    double lat = [[coordArray objectAtIndex:0] doubleValue];
    double lg = [[coordArray objectAtIndex:1] doubleValue];
    return [[CLLocation alloc]initWithLatitude:lat longitude:lg];
}

-(double)distFromCurrentLocation:(CLLocation *)coord
{
    CLLocationCoordinate2D currentLocation = [[AppModel sharedInstance] currentLocation];
    CLLocation *currLog = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    return [currLog distanceFromLocation:coord];
}


#pragma mark - IBActions


- (IBAction)setupButtonClicked:(id)sender
{
    if(FBSession.activeSession.state == FBSessionStateOpen){
        // we are logged in.  Do nothing.
    }
    else if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"playGame!  FBSessionStateCreatedTokenLoaded");
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:NO];
    }else {
        // We don't know whether we logged in.  So we will just ask the user to do a log in.
        NSLog(@"state not equal to toekn loaded, displaying login");
        
        // Dropdown fbLoginView
        [self dropdownFbLoginView];
        //self.loginButton.enabled = YES;
    }
}

// not used anymore
- (IBAction)menuButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (IBAction)mapCloseButtonClicked:(id)sender
{
    [self resizeMap:NO];
}

#pragma mark - Private Helpers

-(void)significantLocationChanged
{
    NSLog(@"significantLocationChange notification detected");
    CLLocationCoordinate2D currentLocation = [[AppModel sharedInstance] currentLocation];
    [MapUtility setDisplayRegionToCenter:currentLocation withMapSpan:MKCoordinateSpanMake(MAP_DELTA_LAT,MAP_DELTA_LONG) forMap:self.mapView];
    
    // we need to update the targets now we have a significant location change
    [[AppModel sharedInstance] getTargetsNearCoordinate:currentLocation withRadius:1000 forDelegate:self];
    
}



-(void)closeMap
{
    [self resizeMap:NO];
}

-(void)resizeMap:(Boolean)fullSize
{
    CGRect mapFrame;
    if(fullSize){
        //mapFrame = [[UIScreen mainScreen] bounds];
        mapFrame = [self.view bounds];
        
        // Add the close button
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeMap)];
        self.navigationItem.rightBarButtonItem = button;
        
                
    }else{
        mapFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, MAP_CELL_HEIGHT);
        // Remove close button
        self.navigationItem.rightBarButtonItem = nil;
    }
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        
        [self.tableView beginUpdates];
        
        [self.mapView setFrame:mapFrame];
        
        self.tableView.scrollEnabled = !fullSize;
        self.isFullMap = fullSize;
        
        [self.tableView endUpdates];
        
    }completion:^(BOOL finished){
        
    }];
}

-(void)hideFbLoginViewWithAnimateDuration:(float)duration andDelay:(float)delay
{
    [UIView animateWithDuration:duration delay:delay options:0 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= frame.size.height;
        [self.fbLoginView setFrame: frame];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dropdownFbLoginView
{
    // Dropdown fbLoginView
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        
        CGRect frame = self.fbLoginView.frame;
        frame.origin.y = 0;
        [self.fbLoginView setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
}

@end
