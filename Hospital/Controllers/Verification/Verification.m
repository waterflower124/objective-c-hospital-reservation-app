//
//  Verification.m
//  Hospital
//
//  Created by Water Flower on 9/4/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "Verification.h"

@interface Verification ()

@end

@implementation Verification

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.receivedData=[NSMutableData new];
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //set language
    verificationTitleLabel.text = NSLocalizedString(@"Loading_text", @"");
    [_verifyCodeTextView setPlaceholder:NSLocalizedString(@"Loading_text", @"")];
    [verifyButton setTitle:NSLocalizedString(@"Loading_text", @"") forState:UIControlStateNormal];
}

-(IBAction)Btn_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Btn_VerifyCode:(id)sender {
    if(_verifyCodeTextView.text.length > 0) {
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
            [parameters setValue:_verifyCodeTextView.text forKey:@"code"];
            
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
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@phone.php",SERVER_URL]]];
            
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [connection start];
        }
    } else {
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"Reg_verifycode", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
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
    NSLog(@":::::%@", json);

    if([json[@"status"] isEqualToString:@"Failed"]) {
        NSLog(@"Failed");
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"Reg_phoneverifyerror", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    } else {
//        [app Show_Alert:NSLocalizedString(@"Info_tittle", @"") SubTitle:NSLocalizedString(@"Register_Sub", @"") CloseTitle:NSLocalizedString(@"Info_close", @"")];
        
        RegisterFull *registerfull_page=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterFull"];
        registerfull_page.phone_number = _phone_number;
        [self.navigationController pushViewController:registerfull_page animated:YES];
        
    }
}


#pragma mark - UITextField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
