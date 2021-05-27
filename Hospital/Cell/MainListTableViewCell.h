//
//  MainListTableViewCell.h
//  Hospital
//
//  Created by Water Flower on 9/3/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;

@end

NS_ASSUME_NONNULL_END
