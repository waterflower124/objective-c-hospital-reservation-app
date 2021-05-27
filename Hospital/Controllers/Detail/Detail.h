//
//  Detail.h
//  Hospital
//
//  Created by Redixbit on 27/07/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import <Twitter/Twitter.h>
#import <CoreLocation/CoreLocation.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>
#import "Constants.h"
#import "HCSStarRatingView.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "SCLAlertView.h"
#import "SQLFile.h"
#import "DejalActivityView.h"

#import "Review.h"
#import "Appointment.h"
#import "AppDelegate.h"
#import "Login.h"

@interface Detail : UIViewController<UIScrollViewDelegate,MFMailComposeViewControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate,MFMessageComposeViewControllerDelegate,FBSDKSharingDelegate>
{
    CGFloat W;
    CGFloat H;
    IBOutlet UIScrollView *main_scroll;
    IBOutlet MKMapView *mymap;
    IBOutlet UILabel *Lbl_title;
    IBOutlet UILabel *Lbl_service,*Lbl_timing,*Lbl_healthcare,*Lbl_Share;
    IBOutlet UILabel *name_lbl,*address_lbl,*ratting_lbl,*distance_lbl,*rate_value,*distance_value,*category_lbl;

    
    __weak IBOutlet UIImageView *imgBack;
    IBOutlet UIImageView *category_imgview,*profile_imgview;
    IBOutlet HCSStarRatingView *ratting_view;
    IBOutlet UILabel *timing_lbl;
    IBOutlet UILabel *txt_service,*txt_healthcare,*txt_about;
    IBOutlet UIButton *fav_btn,*facebook_btn,*twiter_btn,*whatspp_btn;
    IBOutlet UIView *info_view;
    IBOutlet UIImageView *vretical_line_imgview,*line1_imgview,*line2_imgview,*line3_imgview,*line4_imgview;
    IBOutlet UIButton *appointment_btn;
    IBOutlet UIImageView *point1,*point2,*point3;
        
    double lat_val,long_val;
    
    CLLocationManager *locationManager;
    NSString *long_str,*lat_str;
    CGFloat radius_value;
    CGFloat space,space1, labelSpace,vrtclHeight;
    SLComposeViewController *mySLcomposerSheet;
    NSDictionary *res_dict;
    NSMutableData *receivedData1;
    AppDelegate *app;
    IBOutlet UIButton *buynowButton;
}
@property (weak, nonatomic) IBOutlet UIScrollView *subScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalHeight;

@property(nonatomic,retain)NSString *Profile_id;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *expiredateLabel;
@property (strong, nonatomic) IBOutlet UILabel *expirehourLabel;

@property (strong, nonatomic) IBOutlet UIButton *call_btn;
@property (strong, nonatomic) IBOutlet UIButton *map_btn;
@property (strong, nonatomic) IBOutlet UIButton *review_btn;

@end
