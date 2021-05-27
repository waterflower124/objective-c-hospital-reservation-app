//
//  AppointmentList.m
//  Hospital
//
//  Created by Water Flower on 10/31/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "AppointmentList.h"

@interface AppointmentList () {
    AppDelegate *app;
    NSString *language, *user_id;
}

@end

@implementation AppointmentList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    language=[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
    }
    
    appointmentTableView.delegate = self;
    appointmentTableView.dataSource = self;
    
    receivedData1 = [NSMutableData new];
    
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"];
    
    record_array=[[NSMutableArray alloc]init];
    [pendingLineImageView setHidden:NO];
    [expiredLineImageView setHidden:YES];
    listType = @"pending";
    
    [self Get_Data];
    
    titleLabel.text = NSLocalizedString(@"Appointment_Title", @"");
}

-(IBAction)Btn_Back:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pendingButtonAction:(id)sender {
    if(![listType isEqualToString:@"pending"]) {
        [pendingLineImageView setHidden:NO];
        [expiredLineImageView setHidden:YES];
        listType = @"pending";
        [record_array removeAllObjects];
        [appointmentTableView reloadData];
        [self Get_Data];
    }
}

- (IBAction)expiredButtonAction:(id)sender {
    if(![listType isEqualToString:@"expired"]) {
        [pendingLineImageView setHidden:YES];
        [expiredLineImageView setHidden:NO];
        listType = @"expired";
        [record_array removeAllObjects];
        [appointmentTableView reloadData];
        [self Get_Data];
    }
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [record_array count];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentConfirmation *paymentconfirmation_page=[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentConfirmation"];
    paymentconfirmation_page.profile_id = [[record_array objectAtIndex:indexPath.row] valueForKey:@"id"];
    paymentconfirmation_page.barcode = [[record_array objectAtIndex:indexPath.row] valueForKey:@"barcode"];
    [self.navigationController pushViewController: paymentconfirmation_page animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    AppointmentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appointmenttableviewcell"];
    
    NSDictionary *temp=[record_array objectAtIndex:indexPath.row];
    
    NSString *Str_image_name = [NSString stringWithFormat:@"%@",[temp objectForKey:@"icon"]];
    Str_image_name = [Str_image_name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *url1= [image_Url stringByAppendingString:Str_image_name];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"home_page_cell_img"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [cell.mainImageView updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        [cell.mainImageView reveal];
    }];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",[temp objectForKey:@"name"]];
    NSMutableAttributedString* sevice_text = [[self getAttributeString:[temp valueForKey:@"services"]] mutableCopy];
    cell.descLabel.attributedText=sevice_text;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%0.2f %@",[[temp valueForKey:@"distance"] floatValue],NSLocalizedString(@"km", @"")];
    cell.ratingLabel.text = [NSString stringWithFormat:@"%0.1f",[[temp valueForKey:@"ratting"] floatValue]];
    cell.ratingView.value = [cell.ratingLabel.text floatValue];
    cell.ratingView.maximumValue = 5;
    cell.ratingView.minimumValue = 0;
    cell.ratingView.spacing = 1;
    cell.ratingView.allowsHalfStars =YES;
    cell.ratingView.accurateHalfStars =YES;
    cell.ratingView.emptyStarImage = [UIImage imageNamed:@"unfill_rate.png"];
    cell.ratingView.filledStarImage = [UIImage imageNamed:@"fill_rate.png"];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSAttributedString *)getAttributeString:(NSString *)str
{
    NSAttributedString *attributedString = [[NSAttributedString alloc]
        initWithData: [str dataUsingEncoding:NSUnicodeStringEncoding]
        options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
        documentAttributes: nil
        error: nil ];
    return attributedString;
}

#pragma mark Call Web Service Method
-(void)Get_Data {
    if([app Check_Connection])
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
        NSString *string;
        
        if([listType isEqualToString:@"pending"]) {
            string = [NSString stringWithFormat:@"getappointments.php?user_id=%@&type=pending&lang=%@", user_id, language];
        } else {
            string = [NSString stringWithFormat:@"getappointments.php?user_id=%@&type=completed&lang=%@", user_id, language];
        }
      
        string = [NSString stringWithFormat:@"%@%@",SERVER_URL, string];
        NSLog(@"URL :: %@",string);
        string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSMutableURLRequest *request = nil;
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
    else
    {
        [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
    }
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
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:receivedData1 options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"json : %@, Error :: %@",resultDic,error);
        if (error == nil) {
            if([[[resultDic valueForKey:@"status"]objectAtIndex:0] isEqualToString:@"Success"]) {
                record_array=[[resultDic valueForKey:@"List_profile"] objectAtIndex:0];
                [appointmentTableView reloadData];
                NSLog(@"%@",resultDic);
                NSLog(@"record array length::%lu", (unsigned long)record_array.count);
                
            } else {
                [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
                
            }
        } else {
            [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
        }
        [DejalBezelActivityView removeViewAnimated:YES];
    } else {
        NSLog(@"Data not found");
        [app Show_Alert:@"Failed" SubTitle:@"Failed to retrive data from server" CloseTitle:@"OK"];
        [DejalBezelActivityView removeViewAnimated:YES];
    }
}



@end
