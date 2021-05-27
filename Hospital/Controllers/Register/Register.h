//
//  Register.h
//  Hospital
//
//  Created by Redixbit on 06/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DejalActivityView.h"
#import "Constants.h"

#import "AppDelegate.h"
#import "Review.h"
#import "Appointment.h"
#import "Verification.h"
#import "Login.h"
#import "RegisterFull.h"

@interface Register : UIViewController<UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    IBOutlet UIImageView *profile_imageview;
    IBOutlet UITextField *txt_usename,*txt_email,*txt_password,*txt_regId;
    IBOutlet UIButton *Close_btn;
    BOOL *email_check,image_check;
    CGFloat keyboard_height;
    AppDelegate *app;
    IBOutlet UITextField *txt_phonenumber;
    IBOutlet UISwitch *termsSwitch;
    IBOutlet UILabel *regphoneTitleLabel;
    IBOutlet UILabel *termsagreeLabel;
    IBOutlet UIButton *registerButton;
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *lblSelect;

@property (weak, nonatomic) IBOutlet UILabel *lblTake;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgPassWord;
@property (weak, nonatomic) IBOutlet UIImageView *imgTake;
@property (weak, nonatomic) IBOutlet UIImageView *imgselect;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;

@property (retain, nonatomic) NSURLConnection *connection1;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSString *page_name;
@property (retain, nonatomic) NSString *profile_id;
@property (retain, nonatomic) NSString *strEmail;
@end
