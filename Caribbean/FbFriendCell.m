//
//  FbFriendCell.m
//  Normandy
//
//  Created by Eugene Lin on 12-12-10.
//  Copyright (c) 2012 Eugene Lin. All rights reserved.
//

#import "FbFriendCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ALPHA 0.8

@implementation FbFriendCell
@synthesize teamDic = _teamDic;
@synthesize fbFriendDic = _fbFriendDic;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)awakeFromNib
{
    self.AddFriendLabel.alpha = ALPHA;
    self.FriendNameLabel.alpha = ALPHA;
    
    //UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addOrDeleteFriend)];
    //tapR.numberOfTapsRequired = 1;
    //[self.AddFriendLabel addGestureRecognizer:tapR];
    //[self.containerView addGestureRecognizer:tapR];
    self.AddFriendLabel.userInteractionEnabled = YES;
}

-(void)refreshCell
{
    self.FriendNameLabel.text = [self.fbFriendDic objectForKey:@"name"];
    NSString *url = [self.fbFriendDic objectForKey:@"pic_square"];
    NSURL *nUrl = [NSURL URLWithString:url];
    [self.FriendImageView setImageWithURL:nUrl];
    // check to see if this guy already in the team
    NSString *memberFbId = [self.teamDic objectForKey:[self.fbFriendDic objectForKey:@"id"]];
    if(memberFbId){
        [self updateCellForMemberRemove];
    }else{
        [self updateCellForFriendAdd];
    }
}

#pragma mark - Private Methods
-(void)addOrDeleteFriend
{
    NSString *friendFbDic = [self.fbFriendDic objectForKey:@"id"];
    
    
    
    if([self.teamDic objectForKey:friendFbDic]) // is this friend already in the team?
    {
        // 1. Remove Friend
        [self.teamDic removeObjectForKey:friendFbDic];
        // 2. Configure cell so user may add the friend to team again
        [self updateCellForFriendAdd];

    }else{
        // 1. Add Friend
        [self.teamDic setObject:self.fbFriendDic forKey:friendFbDic];
        // 2. Configure cell so user may remove the friend from team later
        [self updateCellForMemberRemove];
    }
    [self.delegate friendAddedOrRemoved];
}

// Update the cell so it is configured to allow user to add friend to team
-(void)updateCellForFriendAdd
{
    self.AddFriendLabel.text = @"+";
    self.AddFriendLabel.textColor = [UIColor whiteColor];
    self.AddFriendLabel.alpha = ALPHA;
    [self.AddFriendLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    self.containerView.backgroundColor = [UIColor darkGrayColor];
}

// Update the cell so it is configured to allow user to remove member from team
-(void)updateCellForMemberRemove
{
    self.AddFriendLabel.text = @"Remove";
    self.AddFriendLabel.textColor = [UIColor redColor];
    self.AddFriendLabel.alpha = 1;
    [self.AddFriendLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
    self.containerView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
