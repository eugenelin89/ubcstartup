//
//  FbFriendCell.h
//  Normandy
//
//  Created by Eugene Lin on 12-12-10.
//  Copyright (c) 2012 Eugene Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FbFriendCellDelegate <NSObject>

-(void) friendAddedOrRemoved;

@end

@interface FbFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *AddFriendLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView; // view containing other UI elements, act as a background.
@property (weak, nonatomic) IBOutlet UIImageView *FriendImageView;
@property (weak, nonatomic) IBOutlet UILabel *FriendNameLabel;
@property (weak, nonatomic) id<FbFriendCellDelegate> delegate;

// Don't confuse the two below.
// teamDic is ref to the dataCache.  When user adds friend to team, we add here.
// fbFriendDic is the FB user's info for this cell.
@property (weak, nonatomic) NSMutableDictionary *teamDic;
@property (strong, nonatomic) NSDictionary *fbFriendDic;

-(void)refreshCell;
-(void)addOrDeleteFriend;
@end
