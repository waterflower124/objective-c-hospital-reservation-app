//
//  Login.m
//  Hospital
//
//  Created by Redixbit on 06/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "Login.h"
#import "OrderMedicine.h"
#import "ViewController.h"
#define kSuccessTitle @"Success"
#define kSubtitle  @"Login Success"

@interface Login (){
    NSString *docEmail,*email;
     NSString *language;
}
@end

@implementation Login
@synthesize page_name,profile_id,EmailId;

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
//    if ([language isEqualToString:country]) {
//        NSLog(@"CheRtl2");
//        _edtEmail.image = [_edtEmail.image imageFlippedForRightToLeftLayoutDirection];
//        _edtPassword.image = [_edtPassword.image imageFlippedForRightToLeftLayoutDirection];
////        _imgFb.image = [_imgFb.image imageFlippedForRightToLeftLayoutDirection];
//        _imageBack.image = [_imageBack.image imageFlippedForRightToLeftLayoutDirection];
//        	txt_username.textAlignment = UITextAlignmentRight;
////            txt_password.textAlignment = UITextAlignmentRight;
//
//    }
//    else
//    {
//        NSLog(@"CheRtl");
//    }
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    receivedData1 = [NSMutableData new];
    docEmail = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"docEmail"];
    docEmail = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"docEmail"];
    email = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"Email"];
    _viewProgress.hidden=YES;
    
    // set language
    logintitleLabel.text = NSLocalizedString(@"login_title", @"");
    [txt_username setPlaceholder:NSLocalizedString(@"username_placeholder", @"")];
    [txt_password setPlaceholder:NSLocalizedString(@"password_placeholder", @"")];
    [signinButton setTitle:NSLocalizedString(@"signin_button", @"") forState:UIControlStateNormal];
    [havenotaccountLabel setText:NSLocalizedString(@"havenotaccount_label", @"")];
    [createaccountButton setTitle:NSLocalizedString(@"createaccount_button", @"") forState:UIControlStateNormal];
    [forgotButton setTitle:NSLocalizedString(@"forgot_button", @"") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentSignInViewController:(UIViewController *)viewController
{
    [[self navigationController] pushViewController:viewController animated:YES];
}

#pragma mark - Google  Helper methods
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    if (error)
    {
        NSLog(@"Status: Authentication error: %@", error);
        return;
    }
    [self reportAuthStatus];
    
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    if (error)
    {
        NSLog(@"Status: Failed to disconnect: %@", error);
    }
    else
    {
        NSLog(@"Status: Disconnected");
        
    }
    [self reportAuthStatus];
    
}

- (void)reportAuthStatus
{
    GIDGoogleUser *googleUser = [[GIDSignIn sharedInstance] currentUser];
    if (googleUser.authentication)
    {
        NSLog(@"Status: Authenticated");
    }
    else
    {
        // To authenticate, use Google+ sign-in button.
        NSLog(@"Status: Not authenticated");
    }
    [self refreshUserInfo];
}

// Update the interface elements containing user data to reflect the
// currently signed in user.
- (void)refreshUserInfo
{
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil)
    {
        return;
    }
 
    
    NSLog(@"email :%@",[GIDSignIn sharedInstance].currentUser.profile.email);
    NSLog(@"name :%@",[GIDSignIn sharedInstance].currentUser.profile.name);

    NSString *Guser_name = [GIDSignIn sharedInstance].currentUser.profile.name;
    NSString *Guser_email = [GIDSignIn sharedInstance].currentUser.profile.email;
    NSString *Guser_image = [[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:100].absoluteString;
    
    if ([Guser_name isEqualToString:@""] && [Guser_email isEqualToString:@""])
    {
        
    }
    else
    {
        if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
        {
            NSLog(@"%@",[[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:100].absoluteString);
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:100].absoluteString]];
            UIImage *image = [UIImage imageWithData:data];
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"Profile"];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:Guser_name forKey:@"Name"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSString *original_url=[NSString stringWithFormat:@"userlogin.php?logintype=Google&email=%@&name=%@&image=%@&reg_id=%@&platform=Iphone",Guser_email,Guser_name,Guser_image,app.stringToken];
        [self getData:original_url];
    }
}

- (IBAction)Forgot_Password:(id)sender {
    ForgotPassword *forgotpassword_page=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPassword"];
//    Register_page.page_name=page_name;
//    Register_page.profile_id=profile_id;
//    Register_page.strEmail=docEmail;
    [self.navigationController pushViewController:forgotpassword_page animated:YES];
}


//#pragma mark - Login method
//-(IBAction)Login_Facbook:(id)sender
//{
//    if(![app Check_Connection])
//    {
//        [DejalBezelActivityView removeViewAnimated:YES];
//        [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"", @"Warning Alert closeButtonTitle")];
//    }
//    else
//    {
//        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//
//        [login logInWithReadPermissions:@[@"public_profile",@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
//         {
//
//            if (error)
//            {
//                NSLog(@"Process error");
//            }
//            else if (result.isCancelled)
//            {
//                NSLog(@"Cancelled");
//            }
//            else
//            {
//                 [DejalBezelActivityView removeViewAnimated:YES];
//                NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//                [parameters setValue:@"id,name,email,picture" forKey:@"fields"];
//
//                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
//                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                              id result, NSError *error) {
//                     NSString *Fuser_name= [result valueForKey:@"name"];
//                     NSString *Fuser_email= [result valueForKey:@"email"];
//
//                     NSString *Fuser_image=[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[result valueForKey:@"id"]];
//
//                     NSString *original_url=[NSString stringWithFormat:@"userlogin.php?logintype=Facebook&email=%@&name=%@&image=%@&reg_id=%@&platform=Iphone",Fuser_email,Fuser_name,Fuser_image,app.stringToken];
//
//                     [self getData:original_url];
//
//                     [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
//
//                 }];
//            }
//        }];
//    }
//
//}


//-(IBAction)Login_Google:(id)sender
//{
//
//    if(![app Check_Connection])
//    {
//        [DejalBezelActivityView removeViewAnimated:YES];
//        [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"", @"Warning Alert closeButtonTitle")];
//    }
//    else
//    {
//        [GIDSignInButton class];
//
//        GIDSignIn *signIn = [GIDSignIn sharedInstance];
//        signIn.shouldFetchBasicProfile = YES;
//        signIn.delegate = self;
//        signIn.uiDelegate = self;
//        [[GIDSignIn sharedInstance]signIn];
//    }
//}
-(IBAction)Btn_Login:(id)sender
{
    [txt_password resignFirstResponder];
    [txt_username resignFirstResponder];
    if(txt_password.text.length>0 && txt_username.text>0)
    {
        NSString *original_url=[NSString stringWithFormat:@"userlogin.php?username=%@&password=%@",txt_username.text,txt_password.text];
        [self getData:original_url];

     
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
    }
    else
    {
        NSString *msg;
        if(txt_username.text.length==0)
        {
            msg=NSLocalizedString(@"Reg_username", @"");
        }
        if(txt_password.text.length==0)
        {
            msg=[[msg stringByAppendingString:@"\n"] stringByAppendingString:NSLocalizedString(@"Reg_password", @"")];
        }
        [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:msg CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    }
}

#pragma mark - Registerpage method
-(IBAction)Btn_Signup:(id)sender
{
    Register *Register_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Register"];
    Register_page.page_name=page_name;
    Register_page.profile_id=profile_id;
    Register_page.strEmail=docEmail;
    [self.navigationController pushViewController:Register_page animated:YES];
    
}

#pragma mark - Retrive data from webservice
-(void)getData:(NSString *)url
{
    NSLog(@"URL :: %@",url);
    NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL,url];
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
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:receivedData1 options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"json : %@, Error :: %@",resultDic,error);
        
        if (error == nil)
        {
            if([[[resultDic valueForKey:@"status"]objectAtIndex:0] isEqualToString:@"Success"])
            {
                
                NSString *imgName= [[[resultDic valueForKey:@"User_info"]valueForKey:@"image"] objectAtIndex:0];
                NSString *imageUrl =[NSString stringWithFormat:@"%@%@",image_Url,imgName];
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
                [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"Profile"];

                [[NSUserDefaults standardUserDefaults]setObject:[[[resultDic valueForKey:@"User_info"]valueForKey:@"username"] objectAtIndex:0] forKey:@"Name"];
                
                [[NSUserDefaults standardUserDefaults]setObject:[[[resultDic valueForKey:@"User_info"]valueForKey:@"id"] objectAtIndex:0] forKey:@"User_id"];
                [[NSUserDefaults standardUserDefaults]setObject:[[[resultDic valueForKey:@"User_info"]valueForKey:@"email"] objectAtIndex:0] forKey:@"Mail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if([page_name isEqualToString:NSLocalizedString(@"Review_Title", @"")])
                {
                    Review *review_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Review"];
                    review_page.user_id=[[[resultDic valueForKey:@"User_info"]valueForKey:@"id"] objectAtIndex:0];
                    review_page.profile_id=self.profile_id;
                     review_page.AlreadyLogin=@"Login";
                    [self.navigationController pushViewController:review_page animated:YES];
                }
                else if([page_name isEqualToString:NSLocalizedString(@"Appointment_Title", @"")])

                {
                    Appointment *appointment_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Appointment"];
                    appointment_page.doctor_id=profile_id;
                    appointment_page.EmailId=email;
                    appointment_page.AlreadyLogin=@"Login";
                    [self.navigationController pushViewController:appointment_page animated:YES];
                }
                else if([page_name isEqualToString:NSLocalizedString(@"OrderTitle", @"")])

                {
                    
                    OrderMedicine  *OrderMedicine=[self.storyboard instantiateViewControllerWithIdentifier:@"OrderMedicine"];
                    OrderMedicine.AlreadyLogin=@"Login";
                    OrderMedicine.EmailId = docEmail;
                    [self.navigationController pushViewController:OrderMedicine animated:YES];
                }

                else
                {
                     ViewController *ViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];

                    [self.navigationController pushViewController:ViewController animated:YES];

                }
                
                [txt_username setText:nil];
                [txt_password setText:nil];
            }
            else
            {
                [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"LoginAlert_subtitle", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
            }
            
            [DejalBezelActivityView removeViewAnimated:YES];

        }
        else
        {
            [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
        }
    }
    else
    {
        NSLog(@"Data not found");
        [app Show_Alert:@"Failed" SubTitle:@"Failed to retrive data from server" CloseTitle:@"OK"];
    }
    
}

#pragma mark - UITextField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)Btn_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
@end
