//
//  AppointmentListTableViewCell.h
//  Hospital
//
//  Created by Water Flower on 10/31/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppointmentListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (strong, nonatomic) IBOutlet UILabel *distanceTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end

NS_ASSUME_NONNULL_END
