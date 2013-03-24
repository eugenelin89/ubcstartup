//
//  MapUtility.m
//  Caribbean
//
//  Created by Eugene Lin on 13-02-05.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "MapUtility.h"
#import <MapKit/MapKit.h>


@implementation MapUtility

+(void)setDisplayRegionToCenter:(CLLocationCoordinate2D)center
                     withMapSpan:(MKCoordinateSpan)mapSpan
                          forMap:(MKMapView *)mapView
{
    // Create location coordinate from the location parameter
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = center.latitude;
    zoomLocation.longitude = center.longitude;
    
    // Setup region
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, mapSpan);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    
    // Move map to location
    [mapView setRegion:adjustedRegion animated:YES];
}

+(MKCoordinateRegion)mapDisplayRegionAtCenter:(CLLocationCoordinate2D)center
                                  withMapSpan:(MKCoordinateSpan)mapSpan
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = center.latitude;
    zoomLocation.longitude = center.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, mapSpan);
    return viewRegion;
}

@end
