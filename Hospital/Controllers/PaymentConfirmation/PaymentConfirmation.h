//
//  PaymentConfirmation.h
//  Hospital
//
//  Created by Water Flower on 11/1/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SCLAlertView.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentConfirmation : UIViewController {
    
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
    IBOutlet UIImageView *QRCodeImageView;
    
    
    NSMutableData *receivedData1;
    
}
@property(nonatomic,retain) NSString *profile_id;
@property(nonatomic,retain) NSMutableArray *appointment_detail_dict;
@property(nonatomic,retain) NSString *barcode;
@property(nonatomic,retain) NSString *latitude, *longitude;

@end

NS_ASSUME_NONNULL_END
