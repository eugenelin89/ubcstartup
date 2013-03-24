//
//  MainController.m
//  Normandy
//
//  Created by Eugene Lin on 12-12-10.
//  Copyright (c) 2012 Eugene Lin. All rights reserved.
//

#import "MainController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"


@implementation MainController

+(void)getMyFbFriends:(id<MainControllerDelegate>) sender
{
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:NO];
    }
    
    
    if(FBSession.activeSession.isOpen)
    {
        NSString *query = @"SELECT id, name, pic_square FROM profile where id in ( SELECT uid2 FROM friend WHERE uid1 = me()) order by name";
        NSDictionary *queryParam =
        [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
        
        [FBRequestConnection startWithGraphPath:@"fql" parameters:queryParam HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(error){
                // handle error
            }else{
                if([sender respondsToSelector:@selector(myFbFriendsRetrieved:)]){
                    [sender myFbFriendsRetrieved:result];
                }
            }
        }];
    }
}

@end
