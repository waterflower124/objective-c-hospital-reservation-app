//
//  ViewController.h
//  Hospital
//
//  Created by Redixbit on 04/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "Constants.h"
#import "SCLAlertView.h"

#import "AppDelegate.h"
#import "Speciality.h"
#import "Favorite.h"
#import "Setting.h"
#import "About.h"
#import "Login.h"
#import "List.h"
#import "HelthcarePlan.h"
#import "KIImagePager.h"
#import "Language.h"
#import "PrivacyPolicy.h"
#import "TermsOfUse.h"
#import "AppointmentList.h"

@interface ViewController : UIViewController<MFMessageComposeViewControllerDelegate>
{
    AppDelegate *app;
    
    IBOutlet UILabel *Lbl_doctor,*Lbl_pharmacies,*Lbl_hospital,*Lbl_title1,*Lbl_title2,*doctor_subtitle_lbl,*pharmacies_subtitle_lbl,*hospital_subtitle_lbl;
    IBOutlet UIView *view_more;
    IBOutlet UILabel *Lbl_home,*Lbl_Favorite,*Lbl_Aboutus,*Lbl_Social_Sharing,*Lbl_Setting,*Lbl_Profile,*Lbl_Name, *Lbl_Category, *Lbl_Privacy, *Lbl_Terms, *Lbl_Appointment;
    IBOutlet UIImageView *userProfile_imageview;
    IBOutlet UIButton *more_btn;
    CGRect OldFrame;
    IBOutlet UIButton *userProfile_image;
    IBOutlet UIButton *signin_btn,*logout_btn;
     CGFloat X;
    BOOL isMenu;
    NSString *isFalse;
    NSString *strResponse;
    NSMutableArray *city_arr,*cityId_arr;
    NSMutableArray *mainlist_arr, *banner_arr, *banner_id_arr;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *profileLabel;
    
    
    
}

@property (retain, nonatomic) NSURLConnection *connection1;
@property (retain, nonatomic) NSMutableData *receivedData1;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;


@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIImageView *btnDoctor;
@property (weak, nonatomic) IBOutlet UIImageView *btnPharmacies;
@property (weak, nonatomic) IBOutlet UIImageView *btnHostpitals;

@property (weak, nonatomic) IBOutlet UIImageView *sidemenu_img;
@property (weak, nonatomic) IBOutlet UIImageView *imghome;

@property (weak, nonatomic) IBOutlet UIImageView *imgFav;
@property (weak, nonatomic) IBOutlet UIImageView *imgAppointment;
@property (weak, nonatomic) IBOutlet UIImageView *imgAbout;
@property (weak, nonatomic) IBOutlet UIImageView *imgSocail;
@property (weak, nonatomic) IBOutlet UIImageView *imgsetting;
@property (weak, nonatomic) IBOutlet UIImageView *imaLogout;
@property (weak, nonatomic) IBOutlet UIImageView *imgCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imgPrivacy;
@property (weak, nonatomic) IBOutlet UIImageView *imgTerms;

@property (strong, nonatomic) IBOutlet UITableView *mainlistTableView;
@property (strong, nonatomic) IBOutlet KIImagePager *slideUIView;

@end

