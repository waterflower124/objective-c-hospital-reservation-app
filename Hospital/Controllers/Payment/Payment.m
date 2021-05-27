//
//  Payment.m
//  Hospital
//
//  Created by Water Flower on 10/29/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "Payment.h"

@interface Payment () {
    AppDelegate *app;
    NSString *language;
}

@end

@implementation Payment

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
    language=[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
    }
    
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [mmTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [yyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cvvTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    paymentFormView.layer.masksToBounds = NO;
    paymentFormView.layer.cornerRadius = 10;
    paymentFormView.layer.borderWidth = 1.0f;
    paymentFormView.layer.borderColor = [UIColor blackColor].CGColor;
    
    cardnameTextField.layer.masksToBounds = NO;
    cardnameTextField.layer.cornerRadius = 5;
    cardnameTextField.layer.borderWidth = 1.0f;
    cardnameTextField.layer.borderColor = [UIColor grayColor].CGColor;
    
    cardnumberTextField.layer.masksToBounds = NO;
    cardnumberTextField.layer.cornerRadius = 5;
    cardnumberTextField.layer.borderWidth = 1.0f;
    cardnumberTextField.layer.borderColor = [UIColor grayColor].CGColor;
    
    mmTextField.layer.masksToBounds = NO;
    mmTextField.layer.cornerRadius = 5;
    mmTextField.layer.borderWidth = 1.0f;
    mmTextField.layer.borderColor = [UIColor grayColor].CGColor;
    
    yyTextField.layer.masksToBounds = NO;
    yyTextField.layer.cornerRadius = 5;
    yyTextField.layer.borderWidth = 1.0f;
    yyTextField.layer.borderColor = [UIColor grayColor].CGColor;
    
    cvvTextField.layer.masksToBounds = NO;
    cvvTextField.layer.cornerRadius = 5;
    cvvTextField.layer.borderWidth = 1.0f;
    cvvTextField.layer.borderColor = [UIColor grayColor].CGColor;
    
    mmTextField.delegate = self;
    yyTextField.delegate = self;
    cvvTextField.delegate = self;
    
    
//    float shadowSize = 10.0f;
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(paymentFormView.frame.origin.x - shadowSize / 2, paymentFormView.frame.origin.y - shadowSize / 2, paymentFormView.frame.size.width + shadowSize, paymentFormView.frame.size.height + shadowSize)];
//
//    paymentFormView.layer.shadowColor = [UIColor blackColor].CGColor;
//    paymentFormView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    paymentFormView.layer.shadowOpacity = 0.8f;
//    paymentFormView.layer.shadowPath = shadowPath.CGPath;
    
    titleLabel.text = NSLocalizedString(@"PaymentTitle", @"");
}


-(void)dismissKeyboard
{
    [cardnameTextField resignFirstResponder];
    [cardnumberTextField resignFirstResponder];
    [mmTextField resignFirstResponder];
    [yyTextField resignFirstResponder];
    [cvvTextField resignFirstResponder];
}


#pragma mark - back button
-(IBAction)Btn_Back:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
   
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - text change function
-(void)textFieldDidChange :(UITextField *) textField{
    if(textField == mmTextField) {
        if(textField.text.length >= 2) {
            [yyTextField becomeFirstResponder];
        }
    } else if(textField == yyTextField) {
        if(textField.text.length >= 2) {
            [cvvTextField becomeFirstResponder];
        }
    } else if(textField == cvvTextField) {
        
    }
}

#pragma mark - payment function
- (IBAction)paymentButton:(id)sender {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Resources" withExtension:@"bundle"]];
    
    PTFWInitialSetupViewController *view = [[PTFWInitialSetupViewController alloc]
                                            initWithBundle:bundle
                                            andWithViewFrame:self.view.frame
                                            andWithAmount:6.0
                                            andWithCustomerTitle:@"Paytabs Sample App"
                                            andWithCurrencyCode:@"SAR"
                                            andWithTaxAmount:0
                                            andWithSDKLanguage:@"en"
                                            andWithShippingAddress:@"test test"
                                            andWithShippingCity:@"Juffair"
                                            andWithShippingCountry:@"BHR"
                                            andWithShippingState:@"Manama"
                                            andWithShippingZIPCode:@"00966"
                                            andWithBillingAddress:@"test test"
                                            andWithBillingCity:@"Juffair"
                                            andWithBillingCountry:@"BHR"
                                            andWithBillingState:@"Manama"
                                            andWithBillingZIPCode:@"00966"
                                            andWithOrderID:@"12345"
                                            andWithPhoneNumber:@"+97333109781"
                                            andWithCustomerEmail:@"waterflower12591@gmail.com"
                                            andIsTokenization:NO
                                            andIsPreAuth:NO
                                            andWithMerchantEmail:@"payments@medbooking.app"
                                            andWithMerchantSecretKey:@"MYX6BOLkxl43WnxplSr8CGVLgB48DRGpQDwsrhMZDR3AeAZAtrI68ESogWxTOdjFQP7i7UiLLml0XlArNjxVXqkemR7b5rRVgYeo"
                                            andWithAssigneeCode:@"SDK"
                                            andWithThemeColor: [self colorWithHexString:@"#2474bc" alpha:1]
                                            andIsThemeColorLight:YES];
    
    view.didReceiveBackButtonCallback = ^{
        UIViewController *rootViewController = [[[[UIApplication sharedApplication]delegate] window] rootViewController];
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    };
    
    view.didStartPreparePaymentPage = ^{
        // Start Prepare Payment Page
        // Show loading indicator
    };
    
    view.didFinishPreparePaymentPage = ^{
        // Finish Prepare Payment Page
        // Stop loading indicator
    };
    
    view.didReceiveFinishTransactionCallback = ^(int responseCode, NSString * _Nonnull result, int transactionID, NSString * _Nonnull tokenizedCustomerEmail, NSString * _Nonnull tokenizedCustomerPassword, NSString * _Nonnull token, BOOL transactionState) {
        NSLog(@"Response Code: %i", responseCode);
        NSLog(@"Response Result: %@", result);
        
        // In Case you are using tokenization
        NSLog(@"Tokenization Cutomer Email: %@", tokenizedCustomerEmail);
        NSLog(@"Tokenization Customer Password: %@", tokenizedCustomerPassword);
        NSLog(@"TOkenization Token: %@", token);
    };
    
    [self presentViewController:view animated:true completion:nil];
}

- (UIColor *)colorWithHexString:(NSString *)str_HEX  alpha:(CGFloat)alpha_range{
    int red = 0;
    int green = 0;
    int blue = 0;
    sscanf([str_HEX UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    return  [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha_range];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if(textField == mmTextField) {
//        if(textField.text.length >= 2) {
//            [yyTextField becomeFirstResponder];
//        }
//    } else if(textField == yyTextField) {
//        if(textField.text.length >= 2) {
//            [cvvTextField becomeFirstResponder];
//        }
//    } else if(textField == cvvTextField) {
//
//    }
//    return YES;
//}



@end
