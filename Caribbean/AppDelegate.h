//
//  AppDelegate.h
//  Caribbean
//
//  Created by Eugene Lin on 13-01-21.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "IIViewDeckController.h"

#define DATA_KEY_CREATE_TEAM @"CREATE_TEAM" // dataCache key for Create Team Flow
#define DATA_KEY_TEAM_NAME @"TEAM_NAME" // dataCache -> CREATE_TEAM -> TEAM_NAME
#define DATA_KEY_TEAM_MEMBERS @"TEAM_MEMBERS" // dataCache -> CREATE_TEAM -> TEAM_MEMBERS
#define DATA_KEY_TEAM_EXP_IN @"TEAM_EXP_IN"
#define DATA_KEY_TEAM_DESC @"TEAM_DESC"
#define DATA_KEY_FB_FRIENDS @"FB_FRIENDS"
#define DATA_KEY_TEAMS @"TEAMS"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark - Application Runtime Data
@property (strong, nonatomic) NSMutableDictionary *dataCache;

#pragma mark - Facebook
extern NSString *const FBSessionStateChangedNotification;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeSession;

@end
