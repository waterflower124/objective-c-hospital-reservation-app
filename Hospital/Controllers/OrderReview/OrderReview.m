//
//  OrderReview.m
//  Hospital
//
//  Created by Water Flower on 10/28/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "OrderReview.h"

@interface OrderReview () {
    AppDelegate *app;
    NSString *language;
}
@end

@implementation OrderReview
@synthesize doctor_detail_dict, booking_code, paymentDetailArr;


- (void)viewDidLoad {
    [super viewDidLoad];

    
    language=[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
    }
    
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    titleLabel.text = NSLocalizedString(@"OrderReviewTitle", @"");
    offernameTitleLabel.text = NSLocalizedString(@"OfferName", @"");
    customernameTitleLabel.text = NSLocalizedString(@"CustomerName", @"");
    bookcodeTitleLabel.text = NSLocalizedString(@"BookCode", @"");
    centernameTitleLabel.text = NSLocalizedString(@"CenterName", @"");
    emailTitleLabel.text = NSLocalizedString(@"EmailAddress", @"");
    offerpriceTitleLabel.text = NSLocalizedString(@"OfferPrice", @"");
    paymentTitleLabel.text = NSLocalizedString(@"ConfirmationPayment", @"");
    remainingTitleLabel.text = NSLocalizedString(@"Remaining", @"");
    mobileTitleLabel.text = NSLocalizedString(@"MobileNumber", @"");
    notefirstLabel.text = NSLocalizedString(@"NoteFirst", @"");
    notesecondLabel.text = NSLocalizedString(@"NoteSecond", @"");
    notethirdLabel.text = NSLocalizedString(@"NoteThird", @"");
    
    NSLog(@"json : %@", doctor_detail_dict);
    NSLog(@"ddd:::%@", booking_code);

    receivedData1 = [NSMutableData new];
    
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"];
    if([app Check_Connection]) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
        [self GetData:[NSString stringWithFormat:@"prepare.php?user_id=%@&code=%@", user_id, booking_code]];

    } else {
        [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
    }
}

-(IBAction)Btn_Back:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Btn_ProceedPayment:(id)sender {

    
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Resources" withExtension:@"bundle"]];
    
    PTFWInitialSetupViewController *view = [[PTFWInitialSetupViewController alloc]
                                            initWithBundle:bundle
                                            andWithViewFrame:self.view.frame
                                            andWithAmount:[[[paymentDetailArr objectAtIndex:0] valueForKey:@"payment_amount"] floatValue]
                                            andWithCustomerTitle:[[paymentDetailArr objectAtIndex:0] valueForKey:@"offer_name"]
                                            andWithCurrencyCode:@"SAR"
                                            andWithTaxAmount:0
                                            andWithSDKLanguage:@"en"
                                            andWithShippingAddress:@"Dammam - Alrawdah District"
                                            andWithShippingCity:@"Riyadh"
                                            andWithShippingCountry:@"SAU"
                                            andWithShippingState:@"Riyadh"
                                            andWithShippingZIPCode:@"00966"
                                            andWithBillingAddress:@"Dammam - Alrawdah District"
                                            andWithBillingCity:@"Dammam"
                                            andWithBillingCountry:@"SAU"
                                            andWithBillingState:@"Dammam"
                                            andWithBillingZIPCode:@"00966"
                                            andWithOrderID:booking_code
                                            andWithPhoneNumber:[[paymentDetailArr objectAtIndex:0] valueForKey:@"mobile"]
                                            andWithCustomerEmail:[[paymentDetailArr objectAtIndex:0] valueForKey:@"email"]
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
        
        if(responseCode == 100) {
            AppointmentList *appointmentlist_page=[self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentList"];

            [self.navigationController pushViewController:appointmentlist_page animated:YES];
        } else {
            [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert Payment", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
        }
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

#pragma mark - Retirve Data From Webservice
-(void)GetData:(NSString *)url
{
    NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
    NSLog(@"URL :: %@",StringURL);
    StringURL = [StringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = nil;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:StringURL]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark - NSURLConnection Delegate Method
-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData1 setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData1 appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@" , error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    if (receivedData1 != nil)
    {
        NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:receivedData1 options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"json : %@, Error :: %@",json,error);
        if (error == nil)
        {
            paymentDetailArr = json;
            NSString *status = [[paymentDetailArr objectAtIndex:0] valueForKey:@"status"];
            if([status isEqualToString: @"Success"]) {
                [offernameContentsLabel setText:[[paymentDetailArr objectAtIndex:0] valueForKey:@"offer_name"]];
                [customernameContentsLabel setText:[[paymentDetailArr objectAtIndex:0] valueForKey:@"customer_name"]];
                [bookcodeContentsLabel setText:[[paymentDetailArr objectAtIndex:0] valueForKey:@"code"]];
                [centernameContentsLabel setText:[[paymentDetailArr objectAtIndex:0] valueForKey:@"center"]];
                [emailContentsLabel setText:[[paymentDetailArr objectAtIndex:0] valueForKey:@"email"]];
                [offerpriceContentsLabel setText:[[paymentDetailArr objectAtIndex:0] valueForKey:@"offer_amount"]];
                [paymentContentsLabel setText:[[paymentDetailArr objectAtIndex:0] valueForKey:@"payment_amount"]];
                float offer_price = [[[paymentDetailArr objectAtIndex:0] valueForKey:@"offer_amount"] floatValue];
                float payment_price = [[[paymentDetailArr objectAtIndex:0] valueForKey:@"payment_amount"] floatValue];
                [remainingContentsLabel setText:[NSString stringWithFormat:@"%f", offer_price - payment_price]];
                [mobileContentsLabel setText:[[paymentDetailArr objectAtIndex:0] valueForKey:@"mobile"]];
            } else {
                [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
            }
            
        } else {
            [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
        }
    } else {
        NSLog(@"Data not found");
        [app Show_Alert:@"Failed" SubTitle:@"Failed to retrive data from server" CloseTitle:@"OK"];
    }
    [DejalBezelActivityView removeViewAnimated:YES];
}

@end
