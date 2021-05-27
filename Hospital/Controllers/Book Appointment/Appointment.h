//
//  Appointment.h
//  Hospital
//
//  Created by Redixbit on 06/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <MessageUI/MessageUI.h>
#import "OrderReview.h"

@interface Appointment : UIViewController<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UIDatePicker *date_picker;
    IBOutlet UIView *date_view;
    BOOL date_press,time_press;
    IBOutlet UILabel *date_lbl,*time_lbl;
    IBOutlet UITextField *txt_mobile;
    IBOutlet UITextView *txt_desc;
    BOOL is_desc_set;
    NSString *user_id;
    IBOutlet UILabel *title_lbl;
    IBOutlet UILabel *lbl_note1;
    IBOutlet UILabel *lbl_note2;
    IBOutlet UILabel *lbl_note3;
    IBOutlet UILabel *lbl_1;
    IBOutlet UILabel *lbl_2;
    IBOutlet UILabel *lbl_3;
    IBOutlet UIButton *book_appointment_btn;
    IBOutlet UILabel *name_lbl,*mail_lbl;
    IBOutlet UIButton *profile_imageview;
    BOOL date_check,time_check,mobile_check;
    
    NSMutableData *receivedData1;
    
    __weak IBOutlet UIImageView *imgDate;
     __weak IBOutlet UIImageView *imgTime;
    __weak IBOutlet UIImageView *imgMobile;
    __weak IBOutlet UIImageView *imgDesc;
    __weak IBOutlet UIImageView *imgBack;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) NSString *EmailId;

@property (weak, nonatomic) IBOutlet UILabel *lblNotes;

@property(nonatomic,retain) NSString *doctor_id;
@property(nonatomic,retain) NSString *AlreadyLogin;
@property(nonatomic,retain) NSDictionary *doctor_detail_dict;


@end
