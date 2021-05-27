//
//  OrderMedicine.h
//  Hospital
//
//  Created by Kiran Padhiyar on 27/01/18.
//  Copyright © 2018 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface OrderMedicine : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UIButton *orderMedicine_btn;
    IBOutlet UIButton *profile_imageview;
    IBOutlet UILabel *name_lbl;
    IBOutlet UILabel *mail_lbl;
    IBOutlet UITextField *txt_mobile;
    IBOutlet UITextView *txt_desc;
   
    IBOutlet UILabel *lbl_Note;
    
    IBOutlet UILabel *lbl_note1;
    IBOutlet UILabel *lbl_note2;
    IBOutlet UILabel *lbl_note3;
    
    __weak IBOutlet UIImageView *imgDesc;
    __weak IBOutlet UIImageView *imgBack;
    __weak IBOutlet UIImageView *imgMobile;
    IBOutlet UILabel *lbl_1;
    IBOutlet UILabel *lbl_2;
    IBOutlet UILabel *lbl_3;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *select_Image;
@property(nonatomic, retain) NSString *EmailId;
@property(nonatomic,retain) NSString *AlreadyLogin;

@end
