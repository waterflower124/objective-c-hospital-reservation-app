//
//  AppointmentListTableViewCell.m
//  Hospital
//
//  Created by Water Flower on 10/31/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "AppointmentListTableViewCell.h"

@implementation AppointmentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _mainImageView.layer.cornerRadius=5;
    _mainImageView.clipsToBounds=YES;
//    [_mainImageView startLoaderWithTintColor:LoadingColor];
    _mainImageView.layer.borderWidth=1;
    _mainImageView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
