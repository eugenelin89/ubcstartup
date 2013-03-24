//
//  TargetViewCell.m
//  Caribbean
//
//  Created by Eugene Lin on 13-01-28.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "TargetViewCell.h"

@implementation TargetViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.text = @"TARGET";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
