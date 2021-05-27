//
//  RegisterFull.h
//  Hospital
//
//  Created by Water Flower on 9/5/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "Constants.h"
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterFull : UIViewController <UIAlertViewDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    AppDelegate *app;
    IBOutlet UITextField *phonenumberTextView;
    IBOutlet UITextField *emailTextView;
    IBOutlet UITextField *passwordTextView;
    IBOutlet UILabel *maleLabel;
    IBOutlet UILabel *femaleLabel;
    IBOutlet UIButton *maleButton;
    IBOutlet UIButton *femaleButton;
    IBOutlet UIButton *registerButton;
    IBOutlet UILabel *birthdayLabel;
    IBOutlet UIDatePicker *birthdayDatePicker;
    IBOutlet UILabel *registerTitleLabel;
    
}

@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSString *gender;
@property (retain, nonatomic) NSString *phone_number;
@property (retain, nonatomic) NSString *dob;
@end

NS_ASSUME_NONNULL_END
