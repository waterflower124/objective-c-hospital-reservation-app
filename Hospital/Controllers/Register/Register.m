//
//  Register.m
//  Hospital
//
//  Created by Redixbit on 06/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "Register.h"
#import "OrderMedicine.h"
#import "ViewController.h"
@interface Register ()
{
    NSString *language;
    NSString *InstanceID;
      NSString *docEmail,*email;
}

@end

@implementation Register
@synthesize page_name,profile_id;


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
    InstanceID = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"Reg_ID"];
    
//    if ([language isEqualToString:country]) {
//        NSLog(@"CheRtl2");
//
//
//        _imgBack.image = [_imgBack.image imageFlippedForRightToLeftLayoutDirection];
//
//    } else {
//         NSLog(@"CheRtl");
//    }
    
    self.receivedData=[NSMutableData new];
     
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    email = [[NSUserDefaults standardUserDefaults]
             stringForKey:@"Email"];
    
    // set language
    regphoneTitleLabel.text = NSLocalizedString(@"register_title", @"");
    [txt_phonenumber setPlaceholder:NSLocalizedString(@"phonenumber_placeholder", @"")];
    termsagreeLabel.text = NSLocalizedString(@"termsagree_label", @"");
    [registerButton setTitle:NSLocalizedString(@"register_button", @"") forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Image Picker Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    profile_imageview.image = chosenImage;
    image_check=YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - UITextField Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished)
     {
     }];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if(self.view.frame.size.width==768)
//    {
//       keyboard_height=264;
//    }
//    else{
//       keyboard_height=215;
//    }
//    if(textField.frame.origin.y+textField.frame.size.height>self.view.frame.size.height-keyboard_height)
//    {
//        [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//
//            self.view.frame=CGRectMake(self.view.frame.origin.x, -keyboard_height, self.view.frame.size.width, self.view.frame.size.height);
//
//        } completion:^(BOOL finished)
//         {
//
//
//         }];
//    }
    return YES;
}


-(IBAction)Btn_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)Btn_Close:(id)sender
{
    image_check=NO;
    profile_imageview.image=[UIImage imageNamed:@"profile.png"];
}
-(IBAction)Btn_Register:(id)sender
{
    
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished)
     {
     }];
       
    if(!termsSwitch.isOn) {
        
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"Reg_terms", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
        return;
    }
    if(txt_phonenumber.text.length>0) {
        if([app Check_Connection])
        {
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
            
            [parameters setValue:txt_phonenumber.text forKey:@"phone"];
            
//            [parameters setValue:@"012345687978945452132154" forKey:@"reg_id"];
            NSLog(@"Check parameters %@,%@,Iphone,%@,%@",txt_usename.text,txt_email.text,txt_password.text,InstanceID);
            // add params (all params are strings)
            for (NSString *param in parameters) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
//            NSString *FileParamConstant = @"file";
//
//            NSData *imageData = UIImageJPEGRepresentation(profile_imageview.image, 1);
//
//            //Assuming data is not nil we add this to the multipart form
//            if (imageData)
//            {
//                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:imageData];
//                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//            }
            
            //Close off the request with the boundary
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // setting the body of the post to the request
            [request setHTTPBody:body];
            
            // set URL
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@phone.php",SERVER_URL]]];
            
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [connection start];
        }
        else
        {
            [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
        }
    }
    else
    {
        NSString *msg;
        if(txt_phonenumber.text.length==0)
        {
            msg=NSLocalizedString(@"Reg_phonenumber", @"");
        }
        
        NSLog(@"%@",msg);
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:msg CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
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
    NSString *responseString = [[NSString alloc] initWithData:(NSData *)self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"ggggg::%@", responseString);
    if([responseString integerValue] == 1) {
        Verification *verification_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Verification"];
        verification_page.phone_number = txt_phonenumber.text;
        [self.navigationController pushViewController:verification_page animated:YES];
    } else if([responseString integerValue] == 2) {
        RegisterFull *registerfull_page=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterFull"];
        registerfull_page.phone_number = txt_phonenumber.text;
        [self.navigationController pushViewController:registerfull_page animated:YES];
    } else if([responseString integerValue] == 3) {
        Login *login_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        
        [self.navigationController pushViewController:login_page animated:YES];
    } else if([responseString integerValue] == 4) {
       Verification *verification_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Verification"];
       verification_page.phone_number = txt_phonenumber.text;
       [self.navigationController pushViewController:verification_page animated:YES];
    } else {
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"Reg_phoneverifyerror", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    }
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"%@",[[[json valueForKey:@"UserDetail"]valueForKey:@"id"]objectAtIndex:0]);
//    NSLog(@"%@",[[[json valueForKey:@"UserDetail"]valueForKey:@"username"]objectAtIndex:0]);
//    NSLog(@"%@",[[[json valueForKey:@"UserDetail"]valueForKey:@"email"]objectAtIndex:0]);
//
//    if([[[json valueForKey:@"status"] objectAtIndex:0] isEqualToString:@"Success"])
//    {
//        [app Show_Alert:NSLocalizedString(@"Info_tittle", @"") SubTitle:NSLocalizedString(@"Register_Sub", @"") CloseTitle:NSLocalizedString(@"Info_close", @"")];
//
//        profile_imageview.image=[UIImage imageNamed:@"profile.png"];
//
//        [[NSUserDefaults standardUserDefaults]setObject:[[[json valueForKey:@"UserDetail"]valueForKey:@"username"]objectAtIndex:0] forKey:@"Name"];
//        [[NSUserDefaults standardUserDefaults]setObject:[[[json valueForKey:@"UserDetail"]valueForKey:@"id"]objectAtIndex:0] forKey:@"User_id"];
//        [[NSUserDefaults standardUserDefaults]setObject:[[[json valueForKey:@"UserDetail"]valueForKey:@"email"]objectAtIndex:0] forKey:@"Mail"];
//
//
//        NSString *imgName= [[[json valueForKey:@"UserDetail"]valueForKey:@"image"] objectAtIndex:0];
//        NSString *imageUrl =[NSString stringWithFormat:@"%@%@",image_Url,imgName];
//        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
//        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"Profile"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//
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
//    }
//    else
//    {
//        NSLog(@"Failed");
//    }
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


@end
