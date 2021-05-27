//
//  PaymentConfirmation.m
//  Hospital
//
//  Created by Water Flower on 11/1/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "PaymentConfirmation.h"

@interface PaymentConfirmation () {
    AppDelegate *app;
    NSString *language;
}

@end

@implementation PaymentConfirmation
@synthesize profile_id, appointment_detail_dict, barcode, latitude, longitude;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    language=[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
    }
    
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    titleLabel.text = NSLocalizedString(@"PaymentConfirmation_Title", @"");
    offernameTitleLabel.text = NSLocalizedString(@"OfferName", @"");
    customernameTitleLabel.text = NSLocalizedString(@"CustomerName", @"");
    bookcodeTitleLabel.text = NSLocalizedString(@"BookCode", @"");
    centernameTitleLabel.text = NSLocalizedString(@"CenterName", @"");
    emailTitleLabel.text = NSLocalizedString(@"EmailAddress", @"");
    offerpriceTitleLabel.text = NSLocalizedString(@"OfferPrice", @"");
    paymentTitleLabel.text = NSLocalizedString(@"ConfirmationPayment", @"");
    remainingTitleLabel.text = NSLocalizedString(@"Remaining", @"");
    mobileTitleLabel.text = NSLocalizedString(@"MobileNumber", @"");
    
    receivedData1 = [NSMutableData new];

    if([app Check_Connection]) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
        [self GetData:[NSString stringWithFormat:@"getofferdetails.php?profileid=%@", profile_id]];

    } else {
        [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
    }
}

-(IBAction)Btn_Back:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
   
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)navigationCenterAction:(id)sender
{
    NSString* addr = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%@,%@", latitude, longitude];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:addr];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
             NSLog(@"Opened url");
        }
    }];
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
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData1 options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"json : %@, Error :: %@",json,error);
        if (error == nil) {
            appointment_detail_dict = [json valueForKey:@"data"];
            
            [offernameContentsLabel setText:[[appointment_detail_dict objectAtIndex:0] valueForKey:@"name"]];
            [customernameContentsLabel setText:[[appointment_detail_dict objectAtIndex:0] valueForKey:@"customer"]];
            [bookcodeContentsLabel setText:[[appointment_detail_dict objectAtIndex:0] valueForKey:@"code"]];
            [centernameContentsLabel setText:[[appointment_detail_dict objectAtIndex:0] valueForKey:@"center"]];
            [emailContentsLabel setText:[[appointment_detail_dict objectAtIndex:0] valueForKey:@"email"]];
            [offerpriceContentsLabel setText:[[appointment_detail_dict objectAtIndex:0] valueForKey:@"offer"]];
            [paymentContentsLabel setText:[[appointment_detail_dict objectAtIndex:0] valueForKey:@"price"]];
            [remainingContentsLabel setText:[NSString stringWithFormat:@"%@", [[appointment_detail_dict objectAtIndex:0] valueForKey:@"remaining"]]];
            [mobileContentsLabel setText:[[appointment_detail_dict objectAtIndex:0] valueForKey:@"phone"]];
            
            [QRCodeImageView startLoaderWithTintColor:LoadingColor];
            NSString *image_url = [NSString stringWithFormat:@"%@tmp/%@.png",image_Url, barcode];
            [QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"home_page_cell_img"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                [QRCodeImageView updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [QRCodeImageView reveal];
            }];
            
            latitude = [[appointment_detail_dict objectAtIndex:0] valueForKey:@"lat"];
            longitude = [[appointment_detail_dict objectAtIndex:0] valueForKey:@"lon"];
            
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
