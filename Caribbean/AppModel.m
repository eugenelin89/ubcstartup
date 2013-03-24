//
//  AppModel.m
//  Caribbean
//
//  Created by Eugene Lin on 13-01-23.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "AppModel.h"
#import "DummyData.h"

@interface AppModel()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation AppModel
@synthesize currentLocation = _currentLocation;

NSString *const SignificantLocationChageNotification = @"com.eugenicode.Caribbean:SignificantLocationChangeNotification";

-(void)getTargetsNearCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(int)meters forDelegate:(id<AppModelDelegate>)delegate
{
    
    NSError *error;
    
    NSLog(@"JSON Object:\n%@", DUMMY_TARGETS_JSON);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[DUMMY_TARGETS_JSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    //[delegate receivedTargets:[dic objectForKey:@"data"]];
    
    
    /*
    dispatch_queue_t downloadQueue = dispatch_queue_create("remote server",NULL);
    dispatch_async(downloadQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate receivedTargets:[dic objectForKey:@"data"]];
        });
        
    });
    */
    
    int64_t delayInSeconds = 1.0; // simulate network delay
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [delegate receivedTargets:[dic objectForKey:@"data"]];
    });
    
    
}

#pragma mark - Location Manager Delegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"User Location Updated: %f, %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    _currentLocation = self.locationManager.location.coordinate;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SignificantLocationChageNotification
     object:manager];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"Location Service Failed: %@", error);
    if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied) {
        // The user denied your app access to location information.
        NSLog(@"Error: User denied app for location service");
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"location service authorization switched to AUTHORIZED");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"location service authorization switched to DENIED");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"location service authorization switched to UNDETERINED");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"location service authorization switched to RESTRICTED");
        default:
            break;
    }
}


#pragma mark - Helper Methods
- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    NSLog(@"Starting significant change updates...");
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    bool enabled = [CLLocationManager locationServicesEnabled];
    if(enabled)
        [self.locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark - Initialization Methods
- (id)init
{
	self = [super init];
	if (self != nil) {
        [self startSignificantChangeUpdates];
	}
    
	return self;
}

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


@end
