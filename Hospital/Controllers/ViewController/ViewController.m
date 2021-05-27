//
//  ViewController.m
//  Hospital
//
//  Created by Redixbit on 04/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "Utility.h"
#import "MBProgressHUD.h"
#import "../../Cell/MainListTableViewCell.h"

@interface ViewController ()<GADInterstitialDelegate, KIImagePagerDataSource, KIImagePagerDelegate>
{
    NSString *language;
    NSString *InstanceID;
    NSUInteger slideUIIndex;
}
@property (strong, nonatomic) GADInterstitial *interstitial;

@end

@implementation ViewController
@synthesize mainlistTableView;

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
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Name"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Mail"]);
    
    [self set_Language];
    
    city_arr=[[NSMutableArray alloc]init];
    cityId_arr=[[NSMutableArray alloc]init];
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
//    [self.view addGestureRecognizer:singleTap];
//    [singleTap setCancelsTouchesInView:NO];
    view_more.frame  = CGRectMake(0, 0, view_more.frame.size.width,self.view.frame.size.height);
    OldFrame = view_more.frame;
    isMenu = NO;
    
    CALayer *frontViewLayer = self.viewMain.layer;
    frontViewLayer.shadowColor = [[UIColor blackColor] CGColor];
    frontViewLayer.shadowOpacity =  1.0f;
    frontViewLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    frontViewLayer.shadowRadius = 10.0f;
    
    self.mainlistTableView.delegate = self;
    [self.mainlistTableView setAllowsSelection:YES];
    
    banner_arr = [[NSMutableArray alloc] init];
    [self GetMainList:@"latest.php"];
    [self GetMainBanner:@"banners.php"];
    
    self.slideUIView.imageCounterDisabled = true;
    slideUIIndex = -1;

}

- (void)imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index {
    NSLog(@"banner array %@", banner_arr);
    NSLog(@"banner array index %lu", index);
    if(banner_id_arr != NULL && banner_id_arr.count > 0) {
        Detail *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        detail_page.Profile_id=[[banner_id_arr objectAtIndex:index] valueForKey:@"id"];
        detail_page.type=NSLocalizedString(@"Favorite_Doctor",@"");
        [self.navigationController pushViewController:detail_page animated:YES];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    InstanceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"Reg_ID"];
    
    NSLog(@"CheckInstanceID %@",InstanceID);
    NSString *object =  [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"OneTime"];
    
    NSString *strCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"City_Name"];
//    if (strCity.length > 0) {
//        NSLog(@"CITY FOUND : %@",strCity);
//    }else{
//        [self GetData:@"city.php"];
//    }
    
    
    
    if(object != nil){
      
        NSLog(@"Done");
    } else {
        [self registerUser];
    }
    [self SetName_Image];
    [self createAndLoadInterstitial];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
    [super viewDidDisappear:YES];
    if (isMenu)
    {
        view_more.frame = OldFrame;
        [self Left_slide];
    }
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)languageButtonAction:(id)sender {
    Language *language_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Language"];
    [self.navigationController pushViewController:language_page animated:YES];
}

- (IBAction)settingButtonAction:(id)sender {
    Setting *setting_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    [self.navigationController pushViewController:setting_page animated:YES];
//    [self gotoNextViewcontroller:setting_page];
}

#pragma mark - UITapGesture Method
-(void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    if (isMenu)
    {
        [self Left_slide];
    }
}

#pragma mark - SET LANGUAGE

-(void)set_Language
{
//    language = [[NSLocale preferredLanguages] firstObject];
    language = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
//    [[NSUserDefaults standardUserDefaults] setObject:language forKey:DEFAULTS_KEY_LANGUAGE_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        NSLog(@"CheRtl2");
        _btnDoctor.image = [_btnDoctor.image imageFlippedForRightToLeftLayoutDirection];
        _btnPharmacies.image = [_btnPharmacies.image imageFlippedForRightToLeftLayoutDirection];
        _btnHostpitals.image = [_btnHostpitals.image imageFlippedForRightToLeftLayoutDirection];
        _sidemenu_img.image = [_sidemenu_img.image imageFlippedForRightToLeftLayoutDirection];
        _imghome.image=[_imghome.image imageFlippedForRightToLeftLayoutDirection];
        _imgCategory.image=[_imgCategory.image imageFlippedForRightToLeftLayoutDirection];
        _imgFav.image = [_imgFav.image imageFlippedForRightToLeftLayoutDirection];
        _imgAppointment.image = [_imgAppointment.image imageFlippedForRightToLeftLayoutDirection];
        _imgAbout.image = [_imgAbout.image imageFlippedForRightToLeftLayoutDirection];
        _imgSocail.image = [_imgSocail.image imageFlippedForRightToLeftLayoutDirection];
        _imgsetting.image = [_imgsetting.image imageFlippedForRightToLeftLayoutDirection];
        _imgPrivacy.image = [_imgPrivacy.image imageFlippedForRightToLeftLayoutDirection];
        _imaLogout.image=[_imaLogout.image imageFlippedForRightToLeftLayoutDirection];
        signin_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    else
    {
        NSLog(@"CheRtl");
    }
    
    [doctor_subtitle_lbl setFont:[UIFont fontWithName:releway size:doctor_subtitle_lbl.font.pointSize]];
    [pharmacies_subtitle_lbl setFont:[UIFont fontWithName:releway size:pharmacies_subtitle_lbl.font.pointSize]];
    [hospital_subtitle_lbl setFont:[UIFont fontWithName:releway size:hospital_subtitle_lbl.font.pointSize]];
    Lbl_doctor.text=NSLocalizedString(@"Home_Doctor", @"");
    Lbl_pharmacies.text=NSLocalizedString(@"Home_Pharmacies", @"");
    Lbl_hospital.text=NSLocalizedString(@"Home_Hospital", @"");
    Lbl_home.text=NSLocalizedString(@"Sidebar_Home", @"");
    Lbl_Category.text=NSLocalizedString(@"Sidebar_Category", @"");
    Lbl_Favorite.text=NSLocalizedString(@"Sidebar_Fav", @"");
    Lbl_Appointment.text=NSLocalizedString(@"Sidebar_Appointments", @"");
    Lbl_Aboutus.text=NSLocalizedString(@"Sidebar_About", @"");
    Lbl_Social_Sharing.text=NSLocalizedString(@"Sidebar_Social", @"");
    Lbl_Setting.text=NSLocalizedString(@"Sidebar_Setting", @"");
    Lbl_Privacy.text=NSLocalizedString(@"Sidebar_Privacy", @"");
    Lbl_Terms.text=NSLocalizedString(@"Sidebar_Terms", @"");
    Lbl_Name.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"Name"];
    Lbl_Profile.text=NSLocalizedString(@"Sidebar_profile", @"");
    doctor_subtitle_lbl.text=NSLocalizedString(@"Home_Doctor_Subtitle", @"");
    pharmacies_subtitle_lbl.text=NSLocalizedString(@"Home_Pharmacies_Subtitle", @"");
    hospital_subtitle_lbl.text=NSLocalizedString(@"Home_Hospital_Subtitle", @"");
    
    titleLabel.text = NSLocalizedString(@"home_title", @"");
    profileLabel.text = NSLocalizedString(@"profile_label", @"");
    [signin_btn setTitle:NSLocalizedString(@"signin_button", @"") forState:UIControlStateNormal];
}

#pragma  mark - Animation for Sidebar

// Move Slider Right Side

-(void)Right_slide
{
    isMenu = YES;
    if ([language isEqualToString:country]) {
    view_more.transform = CGAffineTransformMakeTranslation(50, 0);

    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view_more.transform = CGAffineTransformMakeTranslation(0, 0);
        self.viewMain.frame=CGRectMake(-(self.viewMain.frame.origin.x+view_more.frame.size.width-5), self.viewMain.frame.origin.y, self.viewMain.frame.size.width, self.viewMain.frame.size.height);
    } completion:^(BOOL finished){ }];
  }
    else
    {
        view_more.transform = CGAffineTransformMakeTranslation(-50, 0);
        
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view_more.transform = CGAffineTransformMakeTranslation(0, 0);
            self.viewMain.frame=CGRectMake(self.viewMain.frame.origin.x+view_more.frame.size.width-5, self.viewMain.frame.origin.y, self.viewMain.frame.size.width, self.viewMain.frame.size.height);
        } completion:^(BOOL finished){ }];
    }
}

// Move Slider Left Side

-(void)Left_slide
{
    isMenu = NO;
    
  if ([language isEqualToString:country]) {
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view_more.transform = CGAffineTransformMakeTranslation(50, 0);
        self.viewMain.frame=CGRectMake(0, self.viewMain.frame.origin.y, self.viewMain.frame.size.width, self.viewMain.frame.size.height);
    } completion:^(BOOL finished)
    {
         view_more.transform = CGAffineTransformMakeTranslation(0, 0);
     }];
  }
  else
  {
      [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          view_more.transform = CGAffineTransformMakeTranslation(-50, 0);
          self.viewMain.frame=CGRectMake(0, self.viewMain.frame.origin.y, self.viewMain.frame.size.width, self.viewMain.frame.size.height);
      } completion:^(BOOL finished)
       {
           view_more.transform = CGAffineTransformMakeTranslation(0, 0);
       }];
  }
}

#pragma mark - Change page

//Goto Next Page with Animation

-(void)gotoNextViewcontroller:(UIViewController *)nextViewController
{
    if ([language isEqualToString:country]) {
        if (iPhoneVersion == 5) {
            X = 100.0f;
        }
        else if (iPhoneVersion == 10)
        {
            X = 95.0f;
        }
        else
        {
            X = 268.0f;
        }
        view_more.frame  = CGRectMake(X, 0, self.view.frame.size.width,self.view.frame.size.height);
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:0 animations:^{
            self.viewMain.frame=CGRectMake(-self.view.frame.size.width, self.viewMain.frame.origin.y, self.viewMain.frame.size.width, self.viewMain.frame.size.height);
        } completion:^(BOOL finished) {
            
            [self.navigationController pushViewController:nextViewController animated:YES];
        }];
    }
    else{
        view_more.frame  = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
        
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:0 animations:^{
            self.viewMain.frame=CGRectMake(self.view.frame.size.width, self.viewMain.frame.origin.y, self.viewMain.frame.size.width, self.viewMain.frame.size.height);
        } completion:^(BOOL finished) {
            [self.navigationController pushViewController:nextViewController animated:YES];
        }];
    }
}

#pragma mark - Button Click method

// Select Category Type

-(IBAction)Select_listtype:(UIButton *)sender
{
    if (_interstitial.isReady) {
        
        [_interstitial presentFromRootViewController:self];
    }
    if(sender.tag==1)
    {
        Speciality *Specialitylist_obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Speciality"];
        Specialitylist_obj.category_id=[NSString stringWithFormat:@"%ld",(long)sender.tag];
        [self.navigationController pushViewController:Specialitylist_obj animated:YES];
    }
    else
    {
        List *list_page=[self.storyboard instantiateViewControllerWithIdentifier:@"List"];
        if(sender.tag==2)
        {
            list_page.list_type=NSLocalizedString(@"Favorite_Pharmacies", @"");
        }
        else if (sender.tag==3)
        {
            list_page.list_type=NSLocalizedString(@"Favorite_Hospital", @"");
        }
        [self.navigationController pushViewController:list_page animated:YES];
    }
}

//Open Close Sidebar

-(IBAction)Btn_More:(UIButton *)sender
{
    if(!isMenu)
    {
        [self Right_slide];
    }
    else
    {
        [self Left_slide];
    }
}

//Home Button

-(IBAction)Btn_Home:(UIButton *)sender
{
    [self Left_slide];
}

// category button
- (IBAction)Btn_Category:(id)sender {
    Speciality *Specialitylist_obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Speciality"];
    Specialitylist_obj.category_id=@"1";
    [self.navigationController pushViewController:Specialitylist_obj animated:YES];
}


//Goto Favourite Page
-(IBAction)Btn_Favorite:(id)sender
{
    Favorite *favorite_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Favorite"];
    [self gotoNextViewcontroller:favorite_page];
}

//Goto AppointmentList Page
-(IBAction)Btn_Appointments:(id)sender
{
    AppointmentList *appointment_page=[self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentList"];
    [self gotoNextViewcontroller:appointment_page];
}

//Goto About US Page

-(IBAction)Btn_About:(id)sender
{
    About *about_page=[self.storyboard instantiateViewControllerWithIdentifier:@"About"];
    [self gotoNextViewcontroller:about_page];
}

//Open Shocial Sharing Option

-(IBAction)Btn_Social_Share:(id)sender
{
    [self Left_slide];
    SCLAlertView *alert=[[SCLAlertView alloc]init];
    
    [alert addButton:@"Text" target:self selector:@selector(Message)];
    [alert addButton:@"Whatapp" target:self selector:@selector(Whatsapp)];
    [alert addButton:@"Facebook" target:self selector:@selector(Facebook)];
    
    UIColor *color = [UIColor colorWithRed:13.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
    [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
    [alert showCustom:self image:nil color:color title:NSLocalizedString(@"Social_Title", @"") subTitle:nil closeButtonTitle:NSLocalizedString(@"Social_Close", @"") duration:0.0f];
}

//Goto Setting Page

-(IBAction)Btn_Setting:(id)sender
{
    Setting *setting_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    [self gotoNextViewcontroller:setting_page];
}

//Goto Helthcare Page

-(IBAction)Btn_Helthcare:(id)sender
{
    HelthcarePlan *helth=[self.storyboard instantiateViewControllerWithIdentifier:@"HelthcarePlan"];
    [self gotoNextViewcontroller:helth];
}

- (IBAction)Btn_Privacy:(id)sender {
    PrivacyPolicy *privacy_page=[self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicy"];
    [self gotoNextViewcontroller: privacy_page];
}

- (IBAction)Btn_Terms:(id)sender {
    TermsOfUse *terms_page=[self.storyboard instantiateViewControllerWithIdentifier:@"TermsOfUse"];
    [self gotoNextViewcontroller: terms_page];
}

//Logout
-(IBAction)Btn_Logout:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"] length]>0)
    {
        SCLAlertView *alert=[[SCLAlertView alloc]init];
        [alert addButton:NSLocalizedString(@"Alert_Yes", @"") target:self selector:@selector(Btn_Yes_LogOut:)];
        
        UIColor *color = [UIColor colorWithRed:13.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showCustom:self image:nil color:color title:NSLocalizedString(@"Info_tittle", @"") subTitle:NSLocalizedString(@"Logout_Sub1", @"") closeButtonTitle:NSLocalizedString(@"Alert_Close1", @"") duration:0.0f];
    }
}

//Goto Login Page

-(IBAction)Btn_Signin:(id)sender
{
    Login *login_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    login_page.page_name=@"Home";
    [self gotoNextViewcontroller:login_page];
}

-(IBAction)Btn_Yes_LogOut:(id)sender
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    [[GIDSignIn sharedInstance]signOut];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Name"];
    UIImage *image=[UIImage imageNamed:@"profile1.png"];
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"Profile"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"User_id"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Mail"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self Left_slide];
    more_btn.tag=11;
    [app Show_Alert:NSLocalizedString(@"Info_tittle", @"") SubTitle:NSLocalizedString(@"Logout_Sub", @"") CloseTitle:NSLocalizedString(@"Info_close", @"")];
    [self SetName_Image];
}

#pragma mark - Set UserDetails

//If user is login than set a user details else set default values

-(void)SetName_Image
{
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Profile"];
    UIImage* image;
    
    
    userProfile_image.layer.cornerRadius=userProfile_image.frame.size.height/2;
    userProfile_image.clipsToBounds=YES;
    
    Lbl_Name.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"Name"];
    
    NSLog(@"CheckUserId %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"]);
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"] length]>0) {
        image= [UIImage imageWithData:imageData];
        signin_btn.userInteractionEnabled=NO;
        if(image == NULL) {
            image= [UIImage imageNamed:@"profile1.png"];
        }
        [userProfile_image setBackgroundImage:image forState:UIControlStateNormal];
        [signin_btn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"] forState:UIControlStateNormal];
        logout_btn.hidden=NO;
    } else {//profile1.png
        image= [UIImage imageNamed:@"profile1.png"];
        [userProfile_image setBackgroundImage:image forState:UIControlStateNormal];
        signin_btn.userInteractionEnabled=YES;
        [signin_btn setTitle:@"Sign in" forState:UIControlStateNormal];
        logout_btn.hidden=YES;
    }
}


#pragma mark - Sharing Methods
- (void)Facebook
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL=[NSURL URLWithString:GameUrl];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
}

//Share With WhatsApp

- (void)Whatsapp
{
    NSString * msg = [NSString stringWithFormat:@"%@  %@",NSLocalizedString(@"AppDesc", @""),GameUrl];
    
    msg = [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    msg = [msg stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    msg = [msg stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    msg = [msg stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    msg = [msg stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    msg = [msg stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    msg = [msg stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
    NSLog(@"%@",urlWhats);
    NSURL * whatsappURL = [NSURL URLWithString:urlWhats];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WhatsApp Alert Title",@"") message:NSLocalizedString(@"WhatsApp Alert SubTitle",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"WhatsApp Alert closeButtonTitle",@"") otherButtonTitles:nil];
        [alert show];
    }
}

// Share With SMS
// send Details By Message

- (void)Message
{
    if(![MFMessageComposeViewController canSendText])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        UIColor *color = [UIColor colorWithRed:13.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
        
        [alert showCustom:self image:nil color:color title:@"Failed" subTitle:@"Your Device does not support SMS service" closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    {
        NSArray *recipents = @[@"9999999999"];
        NSString *message = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"AppDesc", @""),GameUrl];
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setRecipients:recipents];
        [messageController setSubject:NSLocalizedString(@"Subject", @"")];
        [messageController setBody:message];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }
}

#pragma mark - MessageComposser Delegate Method
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Mail sent failure");
            break;
        default:
            break;
    }
    
    // Close the Message Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - GADInterstitial Creation and Delegate Method

-(void)createAndLoadInterstitial
{
    if ([kShowAds isEqualToString:@"YES"])
    {
        _interstitial = [[GADInterstitial alloc] initWithAdUnitID:InterstitialID];
        _interstitial.delegate = self;
        
        GADRequest *request = [GADRequest request];
        [_interstitial loadRequest:request];
    }
}

// Called when an interstitial ad request succeeded.

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"interstitialDidReceiveAd");
}

/// Called when an interstitial ad request failed.

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
        NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{}

#pragma mark - POST method
-(void)registerUser
{
    if ([Utility checkInternetConnection])
    {
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

        NSLog(@"cheCk_ID %@",InstanceID);
        [parameters setValue:InstanceID forKey:@"device_id"];
        [parameters setValue:@"iphone" forKey:@"device_type"];
        
        // add params (all params are strings)
        for (NSString *param in parameters)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //Close off the request with the boundary
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the request
        [request setHTTPBody:body];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@tokendata.php",SERVER_URL]]];
        
        _connection1 = [NSURLConnection connectionWithRequest:request delegate:self];
        [_connection1 start];
    }
}

#pragma mark - Retirve Data From Webservice
-(void)GetData:(NSString *)url
{
    if(![app Check_Connection])
    {
        [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
    }
    else
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
    
        NSLog(@"URL :: %@",url);
        NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
        StringURL = [StringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSMutableURLRequest *request = nil;
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:StringURL]];
        
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [_connection start];
    }
}

#pragma mark - Retirve table view Data From Webservice
-(void)GetMainList:(NSString *)url
{
    NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
    StringURL = [StringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:StringURL]];

    [request setHTTPMethod:@"GET"];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!error)
        {
            NSError *jsonError;

            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];

            if(!jsonError)
            {
                mainlist_arr = json[@"data"];
                NSLog(@"main list:   :%@", mainlist_arr);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainlistTableView reloadData];
                });
                
            }

        }
    }];
    [task resume];
}

#pragma mark - Retirve table view Data From Webservice
-(void)GetMainBanner:(NSString *)url
{
    NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
    StringURL = [StringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:StringURL]];

    [request setHTTPMethod:@"GET"];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!error)
        {
            NSError *jsonError;

            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];

            if(!jsonError) {
                NSMutableArray *jsonArray = [json objectForKey:@"data"];
                NSLog(@"banner array: %@", jsonArray);
                if(jsonArray != NULL) {
                    [banner_arr removeAllObjects];
                    banner_id_arr = jsonArray;
                    for(int i = 0; i < jsonArray.count; i ++) {
                        [banner_arr addObject:jsonArray[i][@"banner"]];
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.slideUIView reloadData];
                        slideUIIndex = 0;
                    });
                }
            }
        }
    }];
    [task resume];
}

#pragma mark - NSURLConnection Delegate Method

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == _connection1) {
        self.receivedData1 = [NSMutableData new];
        [_receivedData1 setLength:0];
    } else if(connection == _connection) {
        self.receivedData = [NSMutableData new];
        [_receivedData setLength:0];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == _connection1) {
        [_receivedData1 appendData:data];
    } else if(connection == _connection) {
        [_receivedData appendData:data];
    }
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
     if (connection == _connection1) {
        NSLog(@"post %@" , error);
     } else if(connection == _connection) {
           NSLog(@"get %@" , error);
     }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    if (_receivedData1 != nil)
    {
        NSMutableDictionary *dictData = [NSJSONSerialization JSONObjectWithData:_receivedData1 options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"Response : %@",dictData);
        NSMutableArray *tempArray = [dictData objectForKey:@"Status"];
        isFalse = [[tempArray objectAtIndex:0] valueForKey:@"id"];
        NSLog(@"check26352 %@",isFalse);
        if ([isFalse isEqualToString:@"True"]) {
            NSLog(@"True");
            [[NSUserDefaults standardUserDefaults] setObject:isFalse forKey:@"OneTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else
        {
            NSLog(@"False");
        }
    } else if(_receivedData != nil) {
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"json : %@, Error :: %@",resultDic,error);
        if (error == nil)
        {
            city_arr=[[[resultDic valueForKey:@"Cities"] objectAtIndex:0]valueForKey:@"name"];
            cityId_arr=[[[resultDic valueForKey:@"Cities"] objectAtIndex:0]valueForKey:@"id"];
            
            NSString *strCity = [NSString stringWithFormat:@"%@",[city_arr objectAtIndex:0]];
            [[NSUserDefaults standardUserDefaults]setObject:strCity forKey:@"selectClick"];
            [[NSUserDefaults standardUserDefaults]setObject:[cityId_arr objectAtIndex:0] forKey:@"City"];
            [[NSUserDefaults standardUserDefaults]setObject:[city_arr objectAtIndex:0] forKey:@"City_Name"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else
        {
            [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
        }
        
    }
     [DejalBezelActivityView removeViewAnimated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainlisttableviewcell"];
    NSDictionary *item = mainlist_arr[indexPath.row];
    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString: item[@"imageurl"]]];

    NSMutableAttributedString* priceText = [[self getData: item[@"name"]] mutableCopy];
    [priceText appendAttributedString: [[NSAttributedString alloc] initWithString:NSLocalizedString(@"money_unit", @"") attributes:NULL]];
//    cell.priceLabel.attributedText = [self getData: item[@"name"]];
     cell.priceLabel.attributedText = priceText;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mainlist_arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", @"1111111111");
    Detail *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    detail_page.Profile_id=mainlist_arr[indexPath.row][@"id"];
    detail_page.type=NSLocalizedString(@"Profile",@"");
    [self.navigationController pushViewController:detail_page animated:YES];
}

-(NSAttributedString *)getData:(NSString *)str
{

    NSAttributedString *attributedString = [[NSAttributedString alloc]
        initWithData: [str dataUsingEncoding:NSUnicodeStringEncoding]
        options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
        documentAttributes: nil
        error: nil ];
    return attributedString;
}


- (NSArray *)arrayWithImages:(KIImagePager *)pager {
    return (NSArray *)banner_arr;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
//    return UIViewContentModeScaleAspectFill;
    return UIViewContentModeScaleToFill;
}

    


@end
