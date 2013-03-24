//
//  GameDetailViewController.h
//  Caribbean
//
//  Created by Eugene Lin on 13-02-03.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#define MAP_HEIGHT 190
#define EXPIRED @"EXPIRED"
#define ACTIVE @"ACTIVE"
#define STANDBY @"STANDBY"


@interface GameDetailViewController : UIViewController
@property (strong, nonatomic) NSDictionary *targetDic;

@end
