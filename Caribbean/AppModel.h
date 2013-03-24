//
//  AppModel.h
//  Caribbean
//
//  Created by Eugene Lin on 13-01-23.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol AppModelDelegate <NSObject>
-(void)receivedTargets:(NSArray *)targets;
@end


@interface AppModel : NSObject
extern NSString *const SignificantLocationChageNotification;
@property (readonly, nonatomic) CLLocationCoordinate2D currentLocation;
+ (id)sharedInstance;
-(void)getTargetsNearCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(int)meters forDelegate:(id<AppModelDelegate>)delegate;
//-(void)playGameWithId:(NSString*)gameId;
@end
