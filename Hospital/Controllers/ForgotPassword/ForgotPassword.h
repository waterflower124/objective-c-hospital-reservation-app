//
//  ForgotPassword.h
//  Hospital
//
//  Created by Water Flower on 9/4/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForgotPassword : UIViewController <UIAlertViewDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    AppDelegate *app;
    
    IBOutlet UILabel *forgottitleLabel;
    IBOutlet UIButton *sendnewButton;
    
}

@property (retain, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;

@end

NS_ASSUME_NONNULL_END
