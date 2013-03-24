//
//  SetupViewController.h
//  Second Date
//
//  Created by Eugene Lin on 13-03-23.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

@interface SetupViewController : UIViewController<MainControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myProfileImageView;

@end
