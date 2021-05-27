//
//  HelthcareDetail.h
//  Hospital
//
//  Created by Redixbit on 13/10/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "DejalActivityView.h"

#import "AppDelegate.h"

@interface HelthcareDetail : UIViewController
{
    AppDelegate *app;
    CGFloat radius_value;
}

//Page Properties
@property (nonatomic, retain) NSDictionary *dataDictionary;

//UIScrollView Outlet
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//Profile Image Outlet
@property (weak, nonatomic) IBOutlet UIImageView *profile_imgview;
@property (weak, nonatomic) IBOutlet UIImageView *img_vertical;
@property (weak, nonatomic) IBOutlet UIImageView *img_horizontal;

//UILabel Outlet
@property (weak, nonatomic) IBOutlet UILabel *lbl_planDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_contactDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_websiteDetail;

//UIButton Outlet
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnWebsite;

@property (weak, nonatomic) IBOutlet UIView *info_view;
@end
