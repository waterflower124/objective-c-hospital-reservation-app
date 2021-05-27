//
//  MainListTableViewCell.m
//  Hospital
//
//  Created by Water Flower on 9/3/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "MainListTableViewCell.h"

@implementation MainListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [_containView.layer setCornerRadius:10.0f];
    [_containView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_containView.layer setBorderWidth:0.2f];
    [_containView.layer setShadowColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor];
    [_containView.layer setShadowOpacity:0.3];
    [_containView.layer setShadowRadius:5.0];
    [_containView.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
