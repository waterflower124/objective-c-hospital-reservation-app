//
//  Appointment.m
//  Hospital
//
//  Created by Redixbit on 06/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "Appointment.h"
#import "SCLAlertView.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "Detail.h"
#import "Constants.h"
@interface Appointment ()
{
    BOOL is24h;
    AppDelegate *app;
    NSString *language;
}
@end
bool isGrantedNotificationAccess;
@implementation Appointment
@synthesize doctor_detail_dict;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden
{
    if(iPhoneVersion == 10)
        return NO;
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    language=[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        NSLog(@"CheRtl2");
//        lbl_note1.textAlignment = NSTextAlignmentLeft;
//         lbl_note2.textAlignment = NSTextAlignmentLeft;
//         lbl_note3.textAlignment = NSTextAlignmentLeft;
        
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
        imgDate.image = [imgDate.image imageFlippedForRightToLeftLayoutDirection];
        imgTime.image = [imgTime.image imageFlippedForRightToLeftLayoutDirection];
        imgMobile.image = [imgMobile.image imageFlippedForRightToLeftLayoutDirection];
            imgDesc.image = [imgDesc.image imageFlippedForRightToLeftLayoutDirection];
         txt_mobile.textAlignment = UITextAlignmentRight;
         txt_desc.textAlignment = UITextAlignmentRight;
        
        }
    isGrantedNotificationAccess = false ;
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter          currentNotificationCenter];
   
    UNAuthorizationOptions options = UNAuthorizationOptionAlert         +UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isGrantedNotificationAccess = granted;
    }];
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _lblNotes.text = NSLocalizedString(@"lblNote", @"");
    lbl_note1.text = NSLocalizedString(@"lbl_note1", @"");
    lbl_note2.text = NSLocalizedString(@"lbl_note2", @"");
    lbl_note3.text = NSLocalizedString(@"lbl_note3", @"");
    
  
    _lblNotes.font = [UIFont fontWithName:releway size:_lblNotes.font.pointSize];
    lbl_note1.font = [UIFont fontWithName:releway size:lbl_note1.font.pointSize];
    lbl_note2.font = [UIFont fontWithName:releway size:lbl_note2.font.pointSize];
    lbl_note3.font = [UIFont fontWithName:releway size:lbl_note3.font.pointSize];
    
   
    
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, book_appointment_btn.frame.origin.y+book_appointment_btn.frame.size.height+20)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    [self Set_Language];
    user_id=[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"];
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    if(is24h==YES)
    {
        [df setDateFormat:@"MM/dd/yyy HH:mm"];
    }
    else
    {
        [df setDateFormat:@"MM/dd/yyy hh:mm"];
    }
    date_lbl.text=[[[df stringFromDate:[NSDate date]]componentsSeparatedByString:@" "]objectAtIndex:0];
    time_lbl.text=[[[df stringFromDate:[NSDate date]]componentsSeparatedByString:@" "]objectAtIndex:1];
    
    receivedData1 = [NSMutableData new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Name"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"mail"]);
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Profile"];
    UIImage* image = [UIImage imageWithData:imageData];
    
    profile_imageview.layer.cornerRadius=profile_imageview.frame.size.height/2;
    profile_imageview.clipsToBounds=YES;
    
    name_lbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"Name"];
    mail_lbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"Mail"];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"]length] > 0) {
        if(image != NULL) {
            [profile_imageview setBackgroundImage:image forState:UIControlStateNormal];
        } else {
            [profile_imageview setBackgroundImage:[UIImage imageNamed:@"profile1.png"] forState:UIControlStateNormal];
        }
    } else {
         [profile_imageview setBackgroundImage:[UIImage imageNamed:@"profile1.png"] forState:UIControlStateNormal];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)validationCheckForPhone
{
    NSString *phoneRegEx = @"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegEx];
    if([phoneTest evaluateWithObject:txt_mobile.text]==YES)
    {
        mobile_check=YES;
    }
    else
    {
        txt_mobile.text =@"";
        txt_mobile.placeholder =NSLocalizedString(@"Appointment_Mobile", @"");
    }
}
#pragma mark Textfield Delegate Method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    date_view.hidden=YES;
    if(self.view.frame.origin.y==0)
    {
//        [self up_view];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==txt_mobile)
    {
        [self validationCheckForPhone];
    }
    else
    {
//        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//        UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
//        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
//        [alert showCustom:self image:nil color:color title:@"Alert" subTitle:@"Invalid Mobile Number" closeButtonTitle:@"Cancel" duration:0.0f];
        mobile_check=NO;
        txt_mobile.text=nil;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//     [self down_view];
    [textField resignFirstResponder];
   
    return YES;
}
#pragma mark Textview DElegate Method
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    date_view.hidden=YES;
    textView.text=nil;
    if(self.view.frame.origin.y==0)
    {
//        [self up_view];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
//        [self down_view];
        if(textView.text.length==0)
        {
            textView.text=@"Description";
        }
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark Button  Click Method
-(IBAction)Btn_date:(id)sender
{
    date_view.hidden=NO;
    date_picker.datePickerMode=UIDatePickerModeDate;
    date_press=YES;
}

-(IBAction)Btn_time:(id)sender
{
    date_view.hidden=NO;
    date_picker.datePickerMode=UIDatePickerModeTime;
    time_press=YES;
}

-(IBAction)Btn_Done:(id)sender
{
    if(date_press==YES)
    {
        date_press=NO;
        date_picker.datePickerMode=UIDatePickerModeDate;
        
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *date1Components = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date_picker.date];
        NSDateComponents *date2Components = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        
        if([[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]]!= NSOrderedAscending)
        {
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            date_lbl.text=[dateFormat stringFromDate:date_picker.date];
            date_check=YES;
        }
//        else
//        {
//            [app Show_Alert:NSLocalizedString(@"Alert_title", @"") SubTitle:[NSString stringWithFormat:@"%@ Or Current Date",NSLocalizedString(@"Appointment_subtitle", @"")] CloseTitle:NSLocalizedString(@"Alert_Close", @"")];
//            date_check=NO;
//        }
        date_view.hidden=YES;
        
    }
    if(time_press==YES)
    {
        time_press=NO;
        date_picker.datePickerMode=UIDatePickerModeTime;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        
        if(is24h==YES)
        {
            [dateFormat setDateFormat:@"HH:mm"];
            [dateFormat1 setDateFormat:@"MM/dd/yyyy HH:mm"];
        }
        else
        {
            [dateFormat setDateFormat:@"hh:mm a"];
            [dateFormat1 setDateFormat:@"MM/dd/yyyy hh:mm a"];
        }
        NSString *time_str=[dateFormat stringFromDate:date_picker.date];
        
        
        
        NSDate *full_date = [dateFormat1 dateFromString:[NSString stringWithFormat:@"%@ %@",date_lbl.text,time_str]];
        
        
        if([full_date compare:[NSDate date]]== NSOrderedDescending)
        {
            time_lbl.text=time_str;
            time_check=YES;
        }
//        else
//        {
//        
//            [app Show_Alert:NSLocalizedString(@"Alert_title", @"") SubTitle:[NSString stringWithFormat:@"%@ Time",NSLocalizedString(@"Appointment_subtitle", @"")] CloseTitle:NSLocalizedString(@"Alert_Close", @"")];
//            time_check=NO;
//            
//        }
        date_view.hidden=YES;
    }
}
-(IBAction)Book_Appointment:(id)sender
{
    if([txt_desc.text isEqualToString:@"Description"]) {
        is_desc_set=NO;
    } else {
        is_desc_set=YES;
    }
    
    [self down_view];
//    NSLog(@"1#%@  2#%@  3#%@  4#%@  5#%@", date_lbl.text, time_lbl.text, txt_mobile.text, user_id, doctor_id);
    NSString *doctor_id = [doctor_detail_dict valueForKey:@"id"];
    if(date_lbl.text.length >0 && time_lbl.text.length >0 && txt_mobile.text.length>0 && is_desc_set==YES && user_id.length>0 && doctor_id.length>0) {
        if([app Check_Connection]) {
            [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
            [self GetData:[NSString stringWithFormat:@"bookapointment.php?user_id=%@&doctor_id=%@&desc=%@&price=%@&offer=%@", user_id, [doctor_detail_dict valueForKey:@"id"], txt_desc.text, [doctor_detail_dict valueForKey:@"price"], [doctor_detail_dict valueForKey:@"offer"]]];

        } else {
            [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
        }
    } else {
        NSString *msg;
        if (date_check==NO) {
            msg=[NSString stringWithFormat:@"%@ %@ Or Current Date", NSLocalizedString(@"Appointment_subtitle", @""),@"Date"];
        } else if (time_check==NO) {
            msg=[[msg stringByAppendingString:@"\n"] stringByAppendingString:[NSString stringWithFormat:@"%@  Time",NSLocalizedString(@"Appointment_subtitle", @"")]];
        } else  if (mobile_check==NO) {
            msg=[[msg stringByAppendingString:@"\n"] stringByAppendingString:NSLocalizedString(@"Appointment_moible", @"")];
        } else if (is_desc_set==NO) {
            msg=[[msg stringByAppendingString:@"\n"] stringByAppendingString:NSLocalizedString(@"Appointment_desc", @"")];
        }
        
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:msg CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    }
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
            NSMutableArray *arr=json;
            NSString *status = [[arr objectAtIndex:0] valueForKey:@"status"];
            if([status isEqualToString: @"Success"]) {
                NSString *booking_code = [[arr objectAtIndex:0] valueForKey:@"booking_confirmation"];
                
                OrderReview *orderreview_page=[self.storyboard instantiateViewControllerWithIdentifier:@"OrderReview"];
                orderreview_page.doctor_detail_dict = doctor_detail_dict;
                orderreview_page.booking_code = booking_code;
                [self.navigationController pushViewController: orderreview_page animated:YES];
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

//-(void)send_mail
//{
//    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
//    [mailComposer setMailComposeDelegate:self];
//
//    if ([MFMailComposeViewController canSendMail])
//    {
//
//        NSString *strNote=[NSString stringWithFormat:@"I Would like to book a appoinment and following is the detail for my request,"];
//        NSString *strName=[NSString stringWithFormat:@"Patient Name: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Name"]];
//        NSString *strMail=[NSString stringWithFormat:@"Mail: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Mail"]];
//        NSString *strContact=[NSString stringWithFormat:@"Mobile Number: %@",txt_mobile.text];
//        NSString *strDate=[NSString stringWithFormat:@"Requested Date: %@",date_lbl.text];
//        NSString *strTime=[NSString stringWithFormat:@"Requested Time: %@",time_lbl.text];
//        NSString *strDesc=[NSString stringWithFormat:@"Requested Time: %@",txt_desc.text];
//        NSString *strReq=[NSString stringWithFormat:@"Please,Verify if the required appointment is confirmed"];
//        NSString *strThnx=[NSString stringWithFormat:@"Thanks!"];
//        NSString *htmlMsg = [NSString stringWithFormat:@"<html><body><p>%@</p><p>%@</p><p>%@</p><p>%@</p><p>%@</p><p>%@</p><p>%@</p><p>%@</p><p>%@</p></body></html>",strNote,strName,strMail,strContact,strDate,strTime,strDesc,strReq,strThnx];
//
//
//
//        [mailComposer setSubject:@"subject"];
//        [mailComposer setMessageBody:htmlMsg isHTML:YES];
//        [mailComposer setToRecipients:@[_EmailId]];
//
//        [self presentViewController:mailComposer animated:YES completion:nil];
//    }
//    //    [self presentModalViewController:mailComposer animated:YES];
//}
//
//- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            NSLog(@"Mail cancelled");
//            break;
//        case MFMailComposeResultSaved:
//            NSLog(@"Mail saved");
//            break;
//        case MFMailComposeResultSent:
//            NSLog(@"Mail sent");
//            break;
//        case MFMailComposeResultFailed:
//            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
//            break;
//        default:
//            break;
//    }
//
//    // Close the Mail Interface
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}


-(NSString *)get_timestamp
{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    
    if(is24h==YES)
    {
        [dateFormat1 setDateFormat:@"MM/dd/yyyy HH:mm"];
    }
    else
    {
        [dateFormat1 setDateFormat:@"MM/dd/yyyy hh:mm a"];
    }
    NSDate *date = [dateFormat1 dateFromString:[NSString stringWithFormat:@"%@ %@",date_lbl.text,time_lbl.text]] ;
    return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]] ;
}
//
//#pragma mark - Retrive Data from Webservice
//-(void)getData:(NSString *)url
//{
//    NSLog(@"URL :: %@",url);
//    NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL,url];
//    StringURL = [StringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//    NSMutableURLRequest *request = nil;
//    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:StringURL]];
//
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [connection start];
//}
//
//#pragma mark - NSURLConnection Delegate Method
//-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
//{
//    [receivedData1 setLength:0];
//}
//
//-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [receivedData1 appendData:data];
//}
//
//-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSLog(@"%@" , error.localizedDescription);
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSError *error;
//    if (receivedData1 != nil)
//    {
//        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:receivedData1 options:NSJSONReadingMutableContainers error:&error];
//        NSLog(@"json : %@, Error :: %@",resultDic,error);
//        if (error == nil)
//        {
//            if([[[resultDic valueForKey:@"status"] objectAtIndex:0] isEqualToString:@"Success"])
//            {
//                [app Show_Alert:NSLocalizedString(@"Book_title", @"") SubTitle:NSLocalizedString(@"Book_Subtitle", @"") CloseTitle:NSLocalizedString(@"Book_close", @"")];
//                txt_desc.text=NSLocalizedString(@"Appointment_Desc",@"");
//                txt_mobile.placeholder=@"Mobile Number";
//                date_check=NO;
//                time_check=NO;
//                mobile_check=NO;
//                is_desc_set=NO;
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }
//        else
//        {
//            [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
//        }
//    }
//    else
//    {
//        NSLog(@"Data not found");
//        [app Show_Alert:@"Failed" SubTitle:@"Failed to retrive data from server" CloseTitle:@"OK"];
//    }
//}

#pragma mark - Extra Method
-(void)up_view
{
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.view.frame=CGRectMake(self.view.frame.origin.x, -215, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished)
     {}];
}
-(void)down_view
{
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished)
     {     }];
}
-(void)Set_Language
{
    title_lbl.text=NSLocalizedString(@"Appointment_Title", @"");
    txt_mobile.placeholder=NSLocalizedString(@"Appointment_Mobile", @"");
    txt_desc.text=NSLocalizedString(@"Appointment_Desc", @"");
    [book_appointment_btn setTitle:NSLocalizedString(@"Appointment_book", @"") forState:UIControlStateNormal];
}
-(IBAction)Btn_back:(id)sender
{
    
    [DejalBezelActivityView removeViewAnimated:YES];
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    if (_AlreadyLogin)
    {
        [navigationArray removeObjectAtIndex: navigationArray.count- (2)];  // You can pass your index here
        self.navigationController.viewControllers = navigationArray;
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
