//
//  List.h
//  Hospital
//
//  Created by Redixbit on 27/07/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "HCSStarRatingView.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "SCLAlertView.h"
#import "DejalActivityView.h"

#import "Detail.h"
#import "Setting.h"
#import "AppDelegate.h"
#import "Speciality.h"
#import "Pharmcy_Detail.h"

@interface List : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    IBOutlet UITableView *record_table,*city_table;
    NSMutableArray *record_array;
    IBOutlet UIButton *neraBy_btn,*city_btn,*AlphabetOrder_btn;
    IBOutlet UIImageView *neraBy_imageview,*city_imageview,*AlphabetOrder_imageview;
    BOOL city_press;
    CLLocationManager *locationManager;
    NSString *current_city;
    CGFloat radius_value;
    BOOL location_press;
    IBOutlet UILabel *title_lbl;
    __weak IBOutlet UIImageView *imgBack;
    AppDelegate *app;
    NSMutableData *receivedData1;
    
        CGFloat tSize;
    
}
@property(nonatomic,retain) NSString *cty_id;
@property(nonatomic,retain) NSString *cty_name;

@property(nonatomic,retain) NSString *list_type;
@property(nonatomic,retain) NSString *speciality_id;
@property(nonatomic,retain) NSString *city_id;
@property(nonatomic,retain) NSString *lat_str;
@property(nonatomic,retain) NSString *long_str;
@property(nonatomic,retain)  IBOutlet UILabel *Lbl_title;
@property(nonatomic,assign) BOOL setting_press;

@end
