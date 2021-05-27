//
//  ForgotPassword.m
//  Hospital
//
//  Created by Water Flower on 9/4/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "ForgotPassword.h"

@interface ForgotPassword ()

@end

@implementation ForgotPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.receivedData=[NSMutableData new];
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    forgottitleLabel.text = NSLocalizedString(@"forgot_title", @"");
    [_phoneTextField setPlaceholder:NSLocalizedString(@"phonenumber_placeholder", @"")];
    [sendnewButton setTitle:NSLocalizedString(@"sendnewpassword_button", @"") forState:UIControlStateNormal];

}

-(IBAction)Btn_back:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendNewPasswordButtonAction:(id)sender {
    if(_phoneTextField.text.length > 0) {
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
            
            [parameters setValue:_phoneTextField.text forKey:@"phone"];
            
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
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@forgot.php",SERVER_URL]]];
            
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [connection start];
        }
        else
        {
            [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
        }
    } else {
       
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"Reg_phonenumber", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
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
        //  password is gerated and send it to sms shortly
        [app Show_Alert:NSLocalizedString(@"Info_tittle", @"") SubTitle:NSLocalizedString(@"Reg_passchanged", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    } else if([responseString integerValue] == 2) {
        // no existing user
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"Reg_nouser", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    } else if([responseString integerValue] == 3) {
        //show message complete register and go to register page
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"Reg_complete", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
        
//        Login *login_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
//
//        [self.navigationController pushViewController:login_page animated:YES];
    } else if([responseString integerValue] == 4) {
        // phone number is empty
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"Reg_phonenumber", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    } else {
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"Reg_phoneverifyerror", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    }

}

#pragma mark - UITextField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
