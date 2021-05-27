//
//  Setting.h
//  Hospital
//
//  Created by Redixbit on 10/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "List.h"
#import "AppDelegate.h"

#import "DejalActivityView.h"

@interface Setting : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UITableView *city_table;
    NSMutableArray *city_arr,*cityId_arr;
    CLLocationManager *locationManager;
    IBOutlet UILabel *currentCity_lbl;
    
    __weak IBOutlet UILabel *lblRadius;
    IBOutlet UIButton *order_switchbtn;
    IBOutlet UISlider *radius_slider;
    IBOutlet UILabel *radiusValue_lbl;
    IBOutlet UILabel *order_lbl;
    IBOutlet UILabel *ordering_lbl;
    
    __weak IBOutlet UIButton *btnRedius;
    IBOutlet UILabel *Lbl_currentLocation,*Lbl_Radius,*Lbl_orderby,*title_lbl;
    IBOutlet UIImageView *order_imgview,*radius_imgview;
    CGFloat img_radius,table_radius;
    
    __weak IBOutlet UILabel *lblDistance;
    __weak IBOutlet UIImageView *imgBack;
    NSMutableData *receivedData1;
    NSString *strCity;
    AppDelegate *app;
}
@property (weak, nonatomic) IBOutlet UILabel *lblkm;

@property(nonatomic,retain)NSString *speciality_id;
@property(nonatomic,retain)NSString *lat_str;
@property(nonatomic,retain)NSString *long_str;

@end
