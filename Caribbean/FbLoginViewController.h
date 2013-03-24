//
//  FbLoginViewController.h
//  Caribbean
//
//  Created by Eugene Lin on 13-01-21.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginViewDelegate <NSObject>
-(void)loggedIn;
@end

@interface FbLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) id<loginViewDelegate> delegate;

@end
