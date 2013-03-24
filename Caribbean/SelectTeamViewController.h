//
//  SelectTeamViewController.h
//  Normandy
//
//  Created by Eugene Lin on 12-12-10.
//  Copyright (c) 2012 Eugene Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTeamViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *friendSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *friendSearchTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButtun;

@end
