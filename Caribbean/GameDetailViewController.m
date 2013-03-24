//
//  GameDetailViewController.m
//  Caribbean
//
//  Created by Eugene Lin on 13-02-03.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "GameDetailViewController.h"
#import "AppModel.h"
#import "MapUtility.h"
#import "TargetAnnotation.h"
#import "GamePlayingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FbLoginViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface GameDetailViewController ()<MKMapViewDelegate, UIGestureRecognizerDelegate, GamePlayingViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *gameDescLabel1;
@property (weak, nonatomic) IBOutlet UILabel *gameDescLabel2;
@property (weak, nonatomic) IBOutlet UILabel *gameDescLabel3;
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameEndDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *inProgressLabel;

@property (weak, nonatomic) IBOutlet UIView *fbLoginView;
@property (weak, nonatomic) IBOutlet UILabel *totalPrizesLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayersLabel;
// The tricky part is that the view has 3 states: full map, full detail, split view
// We use the isSplitView to determine if we are at split view mode so we can either expand map or detail
// However, when we're not in split view, there are two possiblities - full map or full detail.
// We use the isFullMap to keep track if we are in full map.
@property (nonatomic) Boolean isSplitView;
@property (nonatomic) Boolean isFullMap;
@property (nonatomic) Boolean isInGame;

@property (strong, nonatomic) NSTimer *blinkTimer;
@end

@implementation GameDetailViewController
@synthesize targetDic = _targetDic;

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
    [super viewDidAppear:animated];
    CLLocationCoordinate2D currentLocation = [[AppModel sharedInstance] currentLocation];
    MKCoordinateRegion region = [MapUtility mapDisplayRegionAtCenter:currentLocation withMapSpan:MKCoordinateSpanMake(MAP_DELTA_LAT,MAP_DELTA_LONG)];
    [self.mapView setRegion:region animated:YES];
    self.mapView.showsUserLocation = YES;
    TargetAnnotation *target = [[TargetAnnotation alloc] initWithTargetDic:self.targetDic];
    [self.mapView addAnnotation:target];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self hideFbLoginViewWithAnimateDuration:0 andDelay:0];
    
    self.inProgressLabel.alpha = 0;

    // layout map view
    [self splitScreen];     
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
	// Do any additional setup after loading the view.

    // Detect tap
    UITapGestureRecognizer *mapTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
    mapTapGesture.numberOfTapsRequired = 1;
    mapTapGesture.delegate = self;
    [self.mapView addGestureRecognizer:mapTapGesture];
    
    UITapGestureRecognizer *detailTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapped:)];
    detailTapGesture.numberOfTapsRequired = 1;
    detailTapGesture.delegate = self;
    [self.detailScrollView addGestureRecognizer:detailTapGesture];
    
    self.toolBar.tintColor = [UIColor colorWithRed:0.0 green:0.35 blue:0.0 alpha:1];
    self.toolBar.alpha = 0.8;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0 green:0.35 blue:0.0 alpha:0.1];
    
    // setting up fbLoginView
    self.fbLoginView.backgroundColor = [UIColor blackColor];
    self.fbLoginView.alpha = 0.7;
    
    
    
    [self loadImages];
    [self loadDescriptions];
    
    // listen to notificaiotns
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((GamePlayingViewController*)[segue destinationViewController]).targetDic = self.targetDic;
    ((GamePlayingViewController*)[segue destinationViewController]).mapRegion = self.mapView.region;
    ((GamePlayingViewController*)[segue destinationViewController]).delegate = self;
}

#pragma mark - Gesture Selectors
-(void)mapTapped:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.isSplitView) //split screen map tapped.  expand.
    {
        [self expandFullMap];
    }
}

-(void)detailTapped:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.isSplitView)
    {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            // expand the frame of detailView to full screen
            self.detailScrollView.frame = self.view.frame;
            
            // move mapView up
            CGRect frame = self.mapView.frame;
            frame.origin.y -= self.detailScrollView.frame.size.height;
            self.mapView.frame = frame;
            
            // Add button to show split screen
            UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Show Map" style:UIBarButtonItemStylePlain target:self action:@selector(splitScreen)];
            self.navigationItem.rightBarButtonItem = button;
            
            self.isSplitView = NO;
            
            // note: why we don't need to set isFullMap to NO? Coz here we are at split view mode and
            // the property already set to NO when we split the view.
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Actions
- (IBAction)playGame:(id)sender
{
    
    // First, make sure we are logged in
    NSLog(@"playGame!  session = %@", FBSession.activeSession);
    if(FBSession.activeSession.state == FBSessionStateOpen){
        // we are logged in.  Do nothing.
        [self playMode];
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
        self.loginButton.enabled = YES;
    }
    
}




- (IBAction)loginButtonClicked:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [appDelegate openSessionWithAllowLoginUI:YES];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self hideFbLoginViewWithAnimateDuration:0.5 andDelay:0];
}


#pragma mark - Private Functions

bool _blinkStatus = NO;
-(void)blinkGameInProgressText
{
    if(_blinkStatus == FALSE){
        self.inProgressLabel.alpha = 1.0;
        _blinkStatus = TRUE;
    }else {
        self.inProgressLabel.alpha = 0.0;
        _blinkStatus = FALSE;
    }
}


-(void)playMode
{
    if(!self.isFullMap)
    {
        // split view or full detail view
        [self expandFullMap];
    }else{
        // no need to do anything
    }
    
    self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(0.5)  target:self selector:@selector(blinkGameInProgressText) userInfo:nil repeats:TRUE];
    _blinkStatus = FALSE;
    [self.blinkTimer fire];
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

-(void)hideFbLoginViewWithAnimateDuration:(float)duration andDelay:(float)delay
{
    [UIView animateWithDuration:duration delay:delay options:0 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= frame.size.height;
        [self.fbLoginView setFrame: frame];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)loggedIn
{
    self.loginButton.enabled = NO;
    [UIView animateWithDuration:0.5 delay:1.0 options:0 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= frame.size.height;
        [self.fbLoginView setFrame: frame];
    } completion:^(BOOL finished) {
        [self playMode];
    }];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self loggedIn];
    } else {
        
    }
}

-(void)expandFullMap
{
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        // Expand the frame of mapView to full screen.
        // No need to touch detail view coz mapView will simply cover it.
        self.mapView.frame = self.view.frame;
        self.isSplitView = NO;
        self.isFullMap = YES;
    } completion:^(BOOL finished) {
        
    }];
    // Add button to show split screen
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Show Description" style:UIBarButtonItemStylePlain target:self action:@selector(splitScreen)];
    self.navigationItem.rightBarButtonItem = button;
}

-(void)splitScreen
{
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        NSLog(@"splitting screen starts!");
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, MAP_HEIGHT);
        [self.mapView setFrame:frame];
        NSLog(@"1. map dimensions: %f", self.mapView.frame.size.height);
        
        frame = self.view.frame;
        frame.origin.y += MAP_HEIGHT;
        frame.size.height -= MAP_HEIGHT;
        [self.detailScrollView setFrame:frame];
        [self.detailScrollView setContentInset:UIEdgeInsetsMake(0, 0, self.toolBar.frame.size.height, 0)];
        self.detailScrollView.contentSize = self.view.frame.size;
        
        self.navigationItem.rightBarButtonItem = nil;
        self.isSplitView = YES;
    
    } completion:^(BOOL finished){
        self.isFullMap = NO;
    }];

}

-(void)loadDescriptions
{
    // Description
    self.gameDescLabel1.text = [self.targetDic objectForKey:@"desc1"];
    self.gameDescLabel2.text = [self.targetDic objectForKey:@"desc2"];
    self.gameDescLabel3.text = [self.targetDic objectForKey:@"desc3"];
    
    // Sponsor Name
    self.businessNameLabel.text = [self.targetDic objectForKey:@"name"];
    
    // Game Status
    NSString *gmtEndDateTime = [self.targetDic objectForKey:@"endDateTime"];
    NSString *gmtStartDateTime = [self.targetDic objectForKey:@"startDateTime"];
    self.gameStatusLabel.text = [self gameStatusForStartsAt:gmtStartDateTime endsAt:gmtEndDateTime];

    // Start or End tIME
    if([self.gameStatusLabel.text isEqualToString:STANDBY]){ // STANDBY, START DATE
        NSString *gameStartsAt = [self convertToLocalDateTimeFromGMT:gmtStartDateTime];
        self.gameEndDateTimeLabel.text = [NSString stringWithFormat:@"Starts: %@", gameStartsAt];
    }else{ // ACTIVE or EXPIRED, End Date
        NSString *gameEndsAt = [self convertToLocalDateTimeFromGMT:gmtEndDateTime];
        self.gameEndDateTimeLabel.text = [NSString stringWithFormat:@"Ends: %@", gameEndsAt];
    }
    
    // Total Prize
    NSNumber *totalPrize = [self.targetDic objectForKey:@"totalPrizes"];
    self.totalPrizesLabel.text = [totalPrize stringValue];
    
    
    // Total Players
    NSNumber *currentPlayers = [self.targetDic objectForKey:@"currentPlayers"];
    self.currentPlayersLabel.text = [currentPlayers stringValue];
}

-(NSString *) convertToLocalDateTimeFromGMT:(NSString *)gmtDateTime
{
    // gmtDateTime in format 2012-07-18T17:30:00.000Z
    // 1. Get the DateTime
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:gmtDateTime];
    
    NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
    [localFormatter setDateStyle:NSDateFormatterLongStyle];
    [localFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeStamp = [localFormatter stringFromDate:date];
    
    return timeStamp;
}

// -1 for expired.  0 for active.  1 for not started yet.
-(NSString *)gameStatusForStartsAt:(NSString *)startTime endsAt:(NSString*)endTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSDate *currentDate = [NSDate date];
    
    NSComparisonResult compareStart = [currentDate compare:startDate]; // descending if curr date > start date
    NSComparisonResult compareEnd = [currentDate compare:endDate];     // ascending if curr date < end date
    
    NSString *result = EXPIRED; // default to expired.
    
    if(compareStart == NSOrderedDescending && compareEnd == NSOrderedAscending) // we're active
    {
        result = ACTIVE;
    }else if(compareStart == NSOrderedSame) // we're active
    {
        result = ACTIVE;
    }
    else if (compareEnd == NSOrderedSame) // consider it expired.
    {
        result = EXPIRED;
    }
    else if(compareStart == NSOrderedAscending) // start date is in the future,
    {
        result = STANDBY;
    }else if(compareEnd == NSOrderedDescending) // end date is in the past, expired
    {
        result = EXPIRED;
    }
    return result;
}

-(void)loadImages
{
    // load images
    NSString *headerImgUrl = [self.targetDic objectForKey:@"headerImg"];
    NSString *brandImgUrl = [self.targetDic objectForKey:@"brandImg"];
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *headerImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:headerImgUrl]];
        NSData *brandImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:brandImgUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            UIImage *headerImage;
            if(headerImageData){
                headerImage = [UIImage imageWithData:headerImageData scale:1];
            }else{
                headerImage = [UIImage imageNamed:@"Flag_of_Canada.png"];
            }
            self.headerImageView.image = headerImage;
            
            UIImage *brandImage;
            if(brandImageData){
                brandImage = [UIImage imageWithData:brandImageData scale:1];
            }else{
                NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
                NSString *iconFileName = [[[[infoDict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"] objectAtIndex:0];
                brandImage = [UIImage imageNamed: iconFileName];
            }
            self.brandImageView.image = brandImage;
            
            
        });
    });
    
}


@end
