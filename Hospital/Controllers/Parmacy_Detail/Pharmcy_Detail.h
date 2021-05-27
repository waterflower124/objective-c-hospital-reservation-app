//
//  Pharmcy_Detail.h
//  Hospital
//
//  Created by Redixbit on 22/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Twitter/Twitter.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "SCLAlertView.h"
#import "Constants.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "SQLFile.h"
#import "DejalActivityView.h"
#import "HCSStarRatingView.h"

#import "Review.h"
#import "Appointment.h"
#import "AppDelegate.h"
#import "Login.h"

@interface Pharmcy_Detail : UIViewController<UIScrollViewDelegate,MFMailComposeViewControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MFMessageComposeViewControllerDelegate, FBSDKSharingDelegate>
{
    IBOutlet UIScrollView *main_scroll;
    CGFloat W;
    CGFloat H;
    IBOutlet MKMapView *mymap;
    IBOutlet UILabel *Lbl_title;
    IBOutlet UILabel *Lbl_service,*Lbl_timing,*Lbl_healthcare,*Lbl_Share;
    IBOutlet UILabel *name_lbl,*address_lbl,*ratting_lbl,*distance_lbl,*rate_value,*distance_value,*category_lbl;
    IBOutlet UIImageView *category_imgview,*profile_imgview;
    IBOutlet HCSStarRatingView *ratting_view;
    IBOutlet UILabel *timing_lbl;
    IBOutlet UILabel *txt_service,*txt_healthcare,*txt_about;
    IBOutlet UIView *info_view;
    IBOutlet UIImageView *vretical_line_imgview;
    IBOutlet UIImageView *line1_imgview,*line2_imgview,*line3_imgview;
    IBOutlet UIImageView *point1,*point2;
    IBOutlet UIButton *fav_btn,*facebook_btn,*twiter_btn,*whatspp_btn;
    IBOutlet UIView *recipe_view;
    IBOutlet UIView *hospital_bottomview;
    
    __weak IBOutlet UIImageView *imgBack;
    double lat_val,long_val;
    SLComposeViewController *mySLcomposerSheet;
    CLLocationManager *locationManager;
    NSString *long_str,*lat_str;
    CGFloat radius_value;
    UIImage *recipe_image;
    CGFloat space, labelSpace,space1,vrtclHeight;
    NSDictionary *res_dict;
    AppDelegate *app;
    NSMutableData *receivedData1;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalHeight;

@property(nonatomic, retain) NSString *Profile_id;
@property(nonatomic, retain) NSString *type;
@end
