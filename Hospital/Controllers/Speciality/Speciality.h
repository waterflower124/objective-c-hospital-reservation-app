//
//  Speciality.h
//  Hospital
//
//  Created by Redixbit on 01/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "List.h"
#import "AppDelegate.h"

#import "Constants.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "SCLAlertView.h"
#import "DejalActivityView.h"
#import "SpecialityTableViewCell.h"

@interface Speciality : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
    __weak IBOutlet UIImageView *imgBack;
    NSMutableArray *img_arr,*speciality_arr,*id_arr;
    IBOutlet UILabel *Lbl_title;
    IBOutlet UICollectionView *speciality_collectionview;
    NSMutableData *receivedData1;
    IBOutlet UITableView *speciality_tableview;
}

@property(nonatomic,retain) NSString *category_id;
@property(nonatomic,retain) NSString *city_id;
@property(nonatomic,retain) NSString *City_name;
@property (retain, nonatomic) NSURLConnection *connection;

@end
