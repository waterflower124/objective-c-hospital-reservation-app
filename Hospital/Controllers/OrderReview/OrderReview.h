//
//  OrderReview.h
//  Hospital
//
//  Created by Water Flower on 10/28/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SCLAlertView.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "Payment.h"
#import <paytabs-iOS/paytabs_iOS.h>
#import "AppointmentList.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderReview : UIViewController {
    
    IBOutlet UIImageView *imgBack;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *offernameTitleLabel;
    IBOutlet UILabel *offernameContentsLabel;
    IBOutlet UILabel *customernameTitleLabel;
    IBOutlet UILabel *customernameContentsLabel;
    IBOutlet UILabel *bookcodeTitleLabel;
    IBOutlet UILabel *bookcodeContentsLabel;
    IBOutlet UILabel *centernameTitleLabel;
    IBOutlet UILabel *centernameContentsLabel;
    IBOutlet UILabel *emailTitleLabel;
    IBOutlet UILabel *emailContentsLabel;
    IBOutlet UILabel *offerpriceTitleLabel;
    IBOutlet UILabel *offerpriceContentsLabel;
    IBOutlet UILabel *paymentTitleLabel;
    IBOutlet UILabel *paymentContentsLabel;
    IBOutlet UILabel *remainingTitleLabel;
    IBOutlet UILabel *remainingContentsLabel;
    IBOutlet UILabel *mobileTitleLabel;
    IBOutlet UILabel *mobileContentsLabel;
    IBOutlet UILabel *notefirstLabel;
    IBOutlet UILabel *notesecondLabel;
    IBOutlet UILabel *notethirdLabel;
    
    NSMutableData *receivedData1;
    
}

- (IBAction)Btn_ProceedPayment:(id)sender;

@property(nonatomic,retain) NSDictionary *doctor_detail_dict;
@property(nonatomic,retain) NSString *booking_code;
@property(nonatomic,retain) NSMutableArray *paymentDetailArr;

@end

NS_ASSUME_NONNULL_END
