//
//  Favorite.h
//  Hospital
//
//  Created by Redixbit on 11/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Favorite : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UITableView *fav_table;
    CLLocationManager *locationManager;
    NSMutableArray *arr_favourity;
    NSMutableArray *section_arr,*doc_arr,*hospital_arr,*pharmacies_arr,*title_arr;
    IBOutlet UILabel *title_lbl;
    CGFloat fontsize;
    
    __weak IBOutlet UIImageView *imgBack;
}
@end
