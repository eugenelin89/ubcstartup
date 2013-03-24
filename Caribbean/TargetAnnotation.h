//
//  TargetAnnotation.h
//  Caribbean
//
//  Created by Eugene Lin on 13-02-01.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TargetAnnotation : NSObject<MKAnnotation>
@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) NSString *title;
@property (strong, nonatomic) NSDictionary *targetDic;
-(id) initWithTargetDic:(NSDictionary *)targetDic;
@end
