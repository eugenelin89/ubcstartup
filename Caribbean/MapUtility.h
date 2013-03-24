//
//  MapUtility.h
//  Caribbean
//
//  Created by Eugene Lin on 13-02-05.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define MAP_DELTA_LAT 0.0312537
#define MAP_DELTA_LONG 0.0274658

@interface MapUtility : NSObject
+(void)setDisplayRegionToCenter:(CLLocationCoordinate2D)center
                    withMapSpan:(MKCoordinateSpan)mapSpan
                         forMap:(MKMapView *)mapView;
+(MKCoordinateRegion)mapDisplayRegionAtCenter:(CLLocationCoordinate2D)center
                                  withMapSpan:(MKCoordinateSpan)mapSpan;
@end
