//
//  Login.h
//  Hospital
//
//  Created by Redixbit on 06/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

#import "Reachability.h"
#import "DejalActivityView.h"

#import "Register.h"
#import "AppDelegate.h"
#import "Review.h"
#import "Appointment.h"
#import "ForgotPassword.h"

@interface Login : UIViewController<UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate>
{
    IBOutlet UITextField *txt_username,*txt_password;
    AppDelegate *app;
    NSMutableData *receivedData1;
    IBOutlet UILabel *logintitleLabel;
    IBOutlet UIButton *signinButton;
    IBOutlet UILabel *havenotaccountLabel;
    IBOutlet UIButton *createaccountButton;
    IBOutlet UIButton *forgotButton;
    
    
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *viewProgress;
@property (weak, nonatomic) IBOutlet UIImageView *edtEmail;
@property (weak, nonatomic) IBOutlet UIImageView *edtPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgFb;
@property (weak, nonatomic) IBOutlet UIImageView *imageBack;
@property (weak, nonatomic) IBOutlet UILabel *lblFb;

@property(nonatomic,retain)NSString *profile_id;
@property(nonatomic,retain)NSString *page_name;
@property(nonatomic,retain)NSString *doctor_id;
@property(nonatomic,retain)NSString *EmailId;
@end
