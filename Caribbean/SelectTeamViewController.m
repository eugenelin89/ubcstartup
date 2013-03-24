//
//  SelectTeamViewController.m
//  Normandy
//
//  Created by Eugene Lin on 12-12-10.
//  Copyright (c) 2012 Eugene Lin. All rights reserved.
//

#import "SelectTeamViewController.h"
#import "MainController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FbFriendCell.h"
#import "AppDelegate.h"

@interface SelectTeamViewController ()<MainControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, FbFriendCellDelegate>
@property (strong, nonatomic) NSArray *friends; // All FB friends
@property (strong, nonatomic) NSMutableArray *displayFriends;
@property (weak, nonatomic) NSMutableDictionary *teamDic; // ref to dataCache -> createTeamDic -> teamDic

@end

@implementation SelectTeamViewController
@synthesize friends = _friends;
@synthesize teamDic = _teamDic;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // GET FB Friends
    self.nextButtun.enabled = NO;
    
    self.friendSearchBar.tintColor = [UIColor blackColor];
    //self.friendSearchBar.alpha = 0.7;
    
    // reference to the AppDelegate's data cache
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // create a data cache for adding friends
    NSMutableDictionary *createTeamDic = [appDelegate.dataCache objectForKey:DATA_KEY_CREATE_TEAM];
    if(createTeamDic){
        if(![createTeamDic objectForKey:DATA_KEY_TEAM_MEMBERS]){
             [createTeamDic setObject:[[NSMutableDictionary alloc] init] forKey:DATA_KEY_TEAM_MEMBERS];
        }
        self.teamDic = [createTeamDic objectForKey:DATA_KEY_TEAM_MEMBERS];
    }else{
        // There is a bug!  What do we do?!
    }
    
    // populate friends and displayFriends array
    self.friends = [appDelegate.dataCache objectForKey: DATA_KEY_FB_FRIENDS];

    if(self.friends){
        self.displayFriends = [self.friends mutableCopy];
    }else{
        [MainController getMyFbFriends:self];
        // friends and displayFriends will get initialized when FB gets back to us.
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.friendSearchTableView reloadData];
    if(self.teamDic.count){
        self.nextButtun.enabled = YES;
    }else{
        self.nextButtun.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)myFbFriendsRetrieved:(NSDictionary *)friends
{
    self.friends = [friends objectForKey:@"data"];
    self.displayFriends = [self.friends mutableCopy];
    [self.friendSearchTableView reloadData];
}

- (void)viewDidUnload {
    [self setFriendSearchBar:nil];
    [self setFriendSearchTableView:nil];
    [self setNextButtun:nil];
    [super viewDidUnload];
}

#pragma mark - Table View Data Source and Delegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FbFriendCell *cell = [self.friendSearchTableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    if(!cell){
        cell = [[FbFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
    }
    
    
    NSDictionary *friendDic = [self.displayFriends objectAtIndex:indexPath.row];
    cell.fbFriendDic = friendDic;
    cell.teamDic = self.teamDic; // set ref to friendsDic so can add friend in the cell
    cell.delegate = self;
    [cell refreshCell];
    return cell;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
        [self.friendSearchBar resignFirstResponder];    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.friendSearchBar resignFirstResponder];
    FbFriendCell *selectedCell = (FbFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    [selectedCell addOrDeleteFriend];
}

#pragma mark - Search Bar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.displayFriends removeAllObjects];
    if(searchText.length == 0){
        [self.displayFriends addObjectsFromArray:self.friends];
    }else{
        for(NSDictionary *friendDic in self.friends){
            NSString *friendName = [friendDic objectForKey:@"name"];
            NSRange r = [friendName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound){
                [self.displayFriends addObject:friendDic];
            }
        }
    }
    [self.friendSearchTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.friendSearchBar resignFirstResponder];
}

#pragma mark - FbFriendCellDelegate
-(void)friendAddedOrRemoved
{
    if(self.teamDic.count){
        self.nextButtun.enabled = YES;
    }else{
        self.nextButtun.enabled = NO;
    }
}

@end
