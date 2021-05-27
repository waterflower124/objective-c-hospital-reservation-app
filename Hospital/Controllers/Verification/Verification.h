//
//  Verification.h
//  Hospital
//
//  Created by Water Flower on 9/4/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "Constants.h"
#import "RegisterFull.h"

NS_ASSUME_NONNULL_BEGIN

@interface Verification : UIViewController <UIAlertViewDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    AppDelegate *app;
    
    IBOutlet UILabel *verificationTitleLabel;
    IBOutlet UIButton *verifyButton;
    
}
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTextView;

@property (nonatomic,retain) NSString *phone_number;
@property (retain, nonatomic) NSURLConnection *connection1;
@property (retain, nonatomic) NSMutableData *receivedData;

@end

NS_ASSUME_NONNULL_END
