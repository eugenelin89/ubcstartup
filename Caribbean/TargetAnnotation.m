//
//  TargetAnnotation.m
//  Caribbean
//
//  Created by Eugene Lin on 13-02-01.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "TargetAnnotation.h"

@implementation TargetAnnotation
@synthesize targetDic = _targetDic;

- (CLLocationCoordinate2D)coordinate
{
    NSArray *loc = [self.targetDic objectForKey:@"loc"];
    CLLocationCoordinate2D coord;
    coord.latitude = [[loc objectAtIndex:0] doubleValue];
    coord.longitude = [[loc objectAtIndex:1] doubleValue];
    return coord;
}

-(NSString *)title
{
    return [self.targetDic objectForKey:@"prize"];
}

-(id) initWithTargetDic:(NSDictionary *)targetDic
{
    self = [self init];
    self.targetDic = targetDic;
    return self;
}

@end
