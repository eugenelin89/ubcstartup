//
//  GamePlayingViewController.h
//  Caribbean
//
//  Created by Eugene Lin on 13-03-04.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MapUtility.h"

@protocol GamePlayingViewControllerDelegate
-(void) cancelGame;
@end

@interface GamePlayingViewController : UIViewController
@property (strong, nonatomic) NSDictionary *targetDic;
@property (nonatomic) MKCoordinateRegion mapRegion;
@property (weak, nonatomic) id<GamePlayingViewControllerDelegate> delegate;
@end
