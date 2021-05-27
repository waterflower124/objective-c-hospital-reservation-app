//
//  Review.h
//  Hospital
//
//  Created by Redixbit on 06/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HCSStarRatingView.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "DejalActivityView.h"

#import "Constants.h"
#import "AppDelegate.h"
#import "Detail.h"

@interface Review : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    __weak IBOutlet UIImageView *imgBack;
    IBOutlet UIView *View_DisplayReview,*View_AddReview;
    IBOutlet UITableView *Review_Table;
    IBOutlet UITextView *txt_addreviw,*txt_displayreview;
    IBOutlet UILabel *Lbl_title,*Lbl_yourExperience,*Lbl_Submit,*Lbl_Cancel;
    BOOL is_addReview;
    NSMutableArray *review_arr;
    IBOutlet UILabel *name_lbl,*Lbl_ok;
    IBOutlet HCSStarRatingView *display_ratting;
    AppDelegate *app;
    
    NSMutableData *receivedData1;
}

@property (strong, nonatomic) IBOutlet HCSStarRatingView *Rating;
@property (nonatomic,retain) NSString *profile_id;
@property (nonatomic,retain) NSString *user_id;
@property (nonatomic,retain) NSString *rating_str;
@property(nonatomic,retain) NSString *AlreadyLogin;
@end
