//
//  MapViewCell.m
//  Caribbean
//
//  Created by Eugene Lin on 13-01-28.
//  Copyright (c) 2013 Eugene Lin. All rights reserved.
//

#import "MapViewCell.h"

@implementation MapViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self sizeToFit];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
