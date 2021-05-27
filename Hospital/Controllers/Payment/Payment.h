//
//  Payment.h
//  Hospital
//
//  Created by Water Flower on 10/29/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SCLAlertView.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "AppDelegate.h"
#import <paytabs-iOS/paytabs_iOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface Payment : UIViewController <UITextFieldDelegate> {
    
    IBOutlet UIImageView *imgBack;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIView *paymentFormView;
    
    IBOutlet UILabel *priceLabel;
    
    IBOutlet UILabel *cardnameLabel;
    IBOutlet UITextField *cardnameTextField;
    IBOutlet UILabel *cardnumberLabel;
    IBOutlet UITextField *cardnumberTextField;
    
    IBOutlet UILabel *expirydateLabel;
    IBOutlet UILabel *cvvLabel;
    IBOutlet UITextField *mmTextField;
    IBOutlet UITextField *yyTextField;
    IBOutlet UITextField *cvvTextField;
    
    IBOutlet UIButton *payButton;
}

- (IBAction)paymentButton:(id)sender;

@end

NS_ASSUME_NONNULL_END
