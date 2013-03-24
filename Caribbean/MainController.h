//
//  MainController.h
//  Normandy
//
//  Created by Eugene Lin on 12-12-10.
//  Copyright (c) 2012 Eugene Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MainControllerDelegate<NSObject>
@optional
-(void)myFbFriendsRetrieved:(NSDictionary *)friends;
-(void)myFbInfoRetrieved:(NSDictionary *) me;
@end

@interface MainController : NSObject
+(void)getMyFbFriends:(id<MainControllerDelegate>) sender;
+(void)getMyFbInfo:(id<MainControllerDelegate>)sender;
@end
