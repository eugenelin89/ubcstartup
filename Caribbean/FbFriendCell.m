//
//  FbFriendCell.m
//  Normandy
//
//  Created by Eugene Lin on 12-12-10.
//  Copyright (c) 2012 Eugene Lin. All rights reserved.
//

#import "FbFriendCell.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ALPHA 0.8

@implementation FbFriendCell
@synthesize dateDic = _dateDic;
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
    // check to see if this guy already has a date
    // check the DATE in Data Cache
    // Silly code... clean up later...
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dateDic = [appDelegate.dataCache objectForKey:DATA_KEY_DATE];
    
    if(dateDic){
        // user has a date.  Is it me?
        NSNumber *dateFbId = [dateDic objectForKey:@"id"];
        NSNumber *myFbId = [self.fbFriendDic objectForKey:@"id"];
        if(dateFbId.intValue == myFbId.intValue){
            //If it's me.  They should be able to remove me.
            [self updateCellForMemberRemove];
        }else{
            [self updateCellForFriendAdd];
        }
    }else{
        [self updateCellForFriendAdd];
    }
}

#pragma mark - Private Methods


-(void)addOrDeleteFriend
{
    NSString *friendFbDic = [self.fbFriendDic objectForKey:@"id"];
    

    // check the DATE in Data Cache
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dateDic = [appDelegate.dataCache objectForKey:DATA_KEY_DATE];
    
    if(!dateDic){
        // user doesn't have a date, add me to it!
        [appDelegate.dataCache setObject:self.fbFriendDic forKey:DATA_KEY_DATE];
        [self updateCellForMemberRemove];
        
    }else{
        // user has a date.  Is it me?
        NSNumber *dateFbId = [dateDic objectForKey:@"id"];
        NSNumber *myFbId = [self.fbFriendDic objectForKey:@"id"];
        if(dateFbId.intValue == myFbId.intValue){
            //If it's me, it means I need to remove myself!
            [appDelegate.dataCache removeObjectForKey:DATA_KEY_DATE];
            [self updateCellForFriendAdd];
        }
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
