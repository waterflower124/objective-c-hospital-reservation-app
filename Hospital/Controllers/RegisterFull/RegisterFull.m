//
//  RegisterFull.m
//  Hospital
//
//  Created by Water Flower on 9/5/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "RegisterFull.h"

@interface RegisterFull ()

@end

@implementation RegisterFull

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.receivedData=[NSMutableData new];
    self.gender = @"male";
    self.dob = @"";
    [maleButton setBackgroundImage:[UIImage imageNamed:@"check_filled.png"] forState:UIControlStateNormal];
    [femaleButton setBackgroundImage:[UIImage imageNamed:@"uncheck_filled.png"] forState:UIControlStateNormal];
    
    phonenumberTextView.text = self.phone_number;
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    // set language
    registerTitleLabel.text = NSLocalizedString(@"register_title", @"");
    [registerButton setTitle:NSLocalizedString(@"register_button", @"") forState:UIControlStateNormal];
    [emailTextView setPlaceholder:NSLocalizedString(@"email_placeholder", @"")];
    [passwordTextView setPlaceholder:NSLocalizedString(@"password_placeholder", @"")];
    maleLabel.text = NSLocalizedString(@"male_label", @"");
    femaleLabel.text = NSLocalizedString(@"female_label", @"");
    birthdayLabel.text = NSLocalizedString(@"birthday_label", @"");
    
}

-(IBAction)Btn_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)maleButtonAction:(id)sender {
    self.gender = @"male";
    [maleButton setBackgroundImage:[UIImage imageNamed:@"check_filled.png"] forState:UIControlStateNormal];
    [femaleButton setBackgroundImage:[UIImage imageNamed:@"uncheck_filled.png"] forState:UIControlStateNormal];

}

- (IBAction)femaleButtonAction:(id)sender {
    self.gender = @"female";
    [maleButton setBackgroundImage:[UIImage imageNamed:@"uncheck_filled.png"] forState:UIControlStateNormal];
    [femaleButton setBackgroundImage:[UIImage imageNamed:@"check_filled.png"] forState:UIControlStateNormal];
}

- (IBAction)birthdayDatePickerChanged:(id)sender {
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy/MM/dd"];
    self.dob = [formate stringFromDate:birthdayDatePicker.date];
    NSLog(@"yyyyyyyyyyy%@", self.dob);
}

- (IBAction)registerButtonAction:(id)sender {
    
    if(![self validateEmailWithString:emailTextView.text]) {
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"valid_email_error", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
        return;
    }
    if(passwordTextView.text.length == 0) {
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"password_empty", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
        return;
    }
    if(self.dob.length == 0) {
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"dob_empty", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
        return;
    }
    
    if([app Check_Connection]) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
        //create request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        //Set Params
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        
        //Create boundary, it can be anything
        NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setValue:_phone_number forKey:@"phone"];
        [parameters setValue:_phone_number forKey:@"username"];
        [parameters setValue:self.dob forKey:@"dob"];
        [parameters setValue:self.gender forKey:@"gender"];
        [parameters setValue:emailTextView.text forKey:@"email"];
        [parameters setValue:passwordTextView.text forKey:@"password"];
        NSString *firebaseToken=[[NSUserDefaults standardUserDefaults] stringForKey:@"Token"];
        if(firebaseToken != NULL && firebaseToken.length >  0) {
            [parameters setValue:firebaseToken forKey:@"reg_id"];
        } else {
            [parameters setValue:@"1234567890123456789" forKey:@"reg_id"];
        }
        [parameters setValue:@"ios" forKey:@"platform"];
        NSLog(@"dddddd:%@", firebaseToken);
        
//            [parameters setValue:@"012345687978945452132154" forKey:@"reg_id"];
        // add params (all params are strings)
        for (NSString *param in parameters) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
               
        //Close off the request with the boundary
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the request
        [request setHTTPBody:body];
        
        // set URL
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@userregister.php",SERVER_URL]]];
        
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
    }
    
}

#pragma mark Connection Delegte Method
-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    [DejalBezelActivityView removeViewAnimated:YES];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
    
    if([[[json valueForKey:@"status"] objectAtIndex:0] isEqualToString:@"Success"])
    {
        [app Show_Alert:NSLocalizedString(@"Info_tittle", @"") SubTitle:NSLocalizedString(@"Register_Sub", @"") CloseTitle:NSLocalizedString(@"Info_close", @"")];

        [[NSUserDefaults standardUserDefaults]setObject:[[[json valueForKey:@"UserDetail"]valueForKey:@"username"]objectAtIndex:0] forKey:@"Name"];
        [[NSUserDefaults standardUserDefaults]setObject:[[[json valueForKey:@"UserDetail"]valueForKey:@"id"]objectAtIndex:0] forKey:@"User_id"];
        [[NSUserDefaults standardUserDefaults]setObject:[[[json valueForKey:@"UserDetail"]valueForKey:@"email"]objectAtIndex:0] forKey:@"Mail"];

        ViewController  *ViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];

        [self.navigationController pushViewController:ViewController animated:YES];
        
        
//        if([page_name isEqualToString:NSLocalizedString(@"Review_Title", @"")])
//        {
//            Review *review_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Review"];
//            review_page.user_id=[[[json valueForKey:@"UserDetail"]valueForKey:@"id"]objectAtIndex:0];
//            review_page.profile_id=self.profile_id;
//            [self.navigationController pushViewController:review_page animated:YES];
//        }
//        else if([page_name isEqualToString:NSLocalizedString(@"Appointment_Title", @"")])
//
//        {
//            Appointment *appointment_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Appointment"];
//            appointment_page.doctor_id=profile_id;
//            appointment_page.EmailId = email;
//            [self.navigationController pushViewController:appointment_page animated:YES];
//        }
//        else if([page_name isEqualToString:NSLocalizedString(@"OrderTitle", @"")])
//
//        {
//            OrderMedicine  *OrderMedicine=[self.storyboard instantiateViewControllerWithIdentifier:@"OrderMedicine"];
//            OrderMedicine.EmailId = _strEmail;
//            [self.navigationController pushViewController:OrderMedicine animated:YES];
//        }
//        else
//        {
//            ViewController  *ViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//
//            [self.navigationController pushViewController:ViewController animated:YES];
//            //            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
    }
    else
    {
        NSLog(@"Failed");
    }
}

- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - UITextField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
