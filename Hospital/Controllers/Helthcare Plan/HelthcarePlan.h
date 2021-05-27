//
//  HelthcarePlan.h
//  Hospital
//
//  Created by Redixbit on 12/10/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "DejalActivityView.h"

#import "Setting.h"
#import "AppDelegate.h"
#import "HelthcareDetail.h"

@interface HelthcarePlan : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSMutableData *receivedData1;
    AppDelegate *app;
    NSMutableArray *record_array;
    CGFloat radius_value;
    NSString *city_name;
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UITableView *tbl_helth;

@end
