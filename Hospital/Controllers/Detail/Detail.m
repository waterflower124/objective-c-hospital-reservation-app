//
//  Detail.m
//  Hospital
//
//  Created by Redixbit on 27/07/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "Detail.h"

@interface Detail ()
{
    NSString *language;
}
@end

@implementation Detail
@synthesize Profile_id,type;

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
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
        category_imgview.image = [category_imgview.image imageFlippedForRightToLeftLayoutDirection];
        vretical_line_imgview.image = [vretical_line_imgview.image imageFlippedForRightToLeftLayoutDirection];
        
    }
    [self set_radius];
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self Set_language];
    
    NSLog(@"%@",Profile_id);
    
    receivedData1 = [NSMutableData new];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
    mymap.delegate =self;
    mymap.mapType = MKMapTypeStandard;
    mymap.showsUserLocation = NO;
   
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    if(iPhoneVersion==4 || iPhoneVersion==5) {
        space1=0;
        space=10;
        labelSpace = 5;
        vrtclHeight=20;
    } else if (iPhoneVersion==10) {
        space = 12;
         space1=0;
        labelSpace = 5;
        vrtclHeight=46;
    } else {
          space1=-50;
        space=25;
        labelSpace = 10;
         vrtclHeight=99;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Retirve Data From Webservice
-(void)GetData:(NSString *)url
{
    NSLog(@"URL :: %@",url);
    NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
    
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
        NSMutableArray *resultDic = [NSJSONSerialization JSONObjectWithData:receivedData1 options:NSJSONReadingMutableContainers error:&error];

        if (error == nil) {
            if([[[resultDic valueForKey:@"status"] objectAtIndex:0] isEqualToString:@"Success"]) {
                res_dict= [[[resultDic valueForKey:@"profile_detail"] objectAtIndex:0] objectAtIndex:0];
                NSLog(@"Value : %@",[res_dict valueForKey:@"name"]);
                [self CheckFavourite];
                
                // SET VALUES IN LABLES
                
                name_lbl.text=[res_dict valueForKey:@"name"];
                [[NSUserDefaults standardUserDefaults] setObject:[res_dict valueForKey:@"email"] forKey:@"Email"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                address_lbl.text=[res_dict valueForKey:@"address"];
                ratting_lbl.text=NSLocalizedString(@"Detail_Rating", @"");
                distance_lbl.text=NSLocalizedString(@"Detail_Distance", @"");
                rate_value.text=[NSString stringWithFormat:@"%.1f",[[res_dict valueForKey:@"ratting"] floatValue]];
                ratting_view.value=[[res_dict valueForKey:@"ratting"] floatValue];
                distance_value.text=[NSString stringWithFormat:@"%.2f %@",[[res_dict valueForKey:@"distancekm"] floatValue],NSLocalizedString(@"km", @"")];
                txt_service.text=[res_dict valueForKey:@"services"];
                timing_lbl.text=[res_dict valueForKey:@"hours"];
                txt_healthcare.text=[res_dict valueForKey:@"helthcare"];
                txt_about.text=[res_dict valueForKey:@"about"];
                
                NSString *price = [NSString stringWithFormat:@"(%@ %@) %@ %@ %@ %@", [res_dict valueForKey:@"offer"], NSLocalizedString(@"money_unit", @""), NSLocalizedString(@"offer_label", @""), NSLocalizedString(@"price_label", @""), [res_dict valueForKey:@"offer"], NSLocalizedString(@"money_unit", @"")];
                _priceLabel.text = price;
                NSString *expiredate = [NSString stringWithFormat:@"%@ %@%@", NSLocalizedString(@"offer_expire", @""), [res_dict valueForKey:@"expiresafter"], NSLocalizedString(@"offer_expire_day", @"")];
                _expiredateLabel.text = expiredate;
                NSString *expirehour = [NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"hours_remaining", @""), [[res_dict valueForKey:@"expiresafter"] integerValue] * 24];
                _expirehourLabel.text = expirehour;
                
                // SET PROFILE IMAGE
                
                [profile_imgview startLoaderWithTintColor:LoadingColor];
                profile_imgview.layer.cornerRadius=radius_value;
                profile_imgview.clipsToBounds=YES;
                profile_imgview.layer.borderWidth=1;
                profile_imgview.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                
                NSString *Str_image_name = [NSString stringWithFormat:@"%@",[res_dict objectForKey:@"icon"]];
                Str_image_name = [Str_image_name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
                NSString *url1= [image_Url stringByAppendingString:Str_image_name];
                [profile_imgview sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"home_page_cell_img"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    [profile_imgview updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [profile_imgview reveal];
                }];
                
                // SET CATEGORY PROFILE ICON D/P/H
                
                NSLog(@"%@",type);
               
                if([type isEqualToString:NSLocalizedString(@"Favorite_Doctor", @"")]) {
                    category_imgview.hidden = NO;
                    category_lbl.hidden = NO;
                    category_imgview.image=[UIImage imageNamed:@"d_bg.png"];
                    category_lbl.text=NSLocalizedString(@"doctor_symbol", @"");
                } else if([type isEqualToString:NSLocalizedString(@"Favorite_Pharmacies", @"")]) {
                    category_imgview.hidden = NO;
                    category_lbl.hidden = NO;
                    category_imgview.image=[UIImage imageNamed:@"p_bg.png"];
                    category_lbl.text=NSLocalizedString(@"pharmacy_symbol", @"");
                } else if([type isEqualToString:NSLocalizedString(@"Favorite_Hospital", @"")]) {
                    category_imgview.hidden = NO;
                    category_lbl.hidden = NO;
                    category_imgview.image=[UIImage imageNamed:@"h_bg.png"];
                    category_lbl.text=NSLocalizedString(@"hospital_symbol", @"");
                }
                
                if ([language isEqualToString:country]) {
                    NSLog(@"CheRtl2");
                    
                    category_imgview.image = [category_imgview.image imageFlippedForRightToLeftLayoutDirection];
                }
                
                CLLocationCoordinate2D loc;
                loc.longitude = [[res_dict valueForKey:@"lon"] floatValue];
                loc.latitude = [[res_dict valueForKey:@"lat"] floatValue];
                
                MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
                annotationPoint.coordinate = loc;
                annotationPoint.title =@"";
                [mymap addAnnotation:annotationPoint];
                
                // Set Default Zomm to Resturant Location
                
                if (iPhoneVersion == 5) {
                    W = 10000.0f;
                    H = 10000.0f;
                }
                else if (iPhoneVersion == 10)
                {
                    W = 10000.0f;
                    H = 10000.0f;
                }
                else
                {
                    W = 10000.0f;
                    H = 10000.0f;
                }
                MKMapRect zoomRect = MKMapRectNull;
                for (id <MKAnnotation> annotation in mymap.annotations)
                {
                    MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, W, H);
                    zoomRect = MKMapRectUnion(zoomRect, pointRect);
                    
                }
                [mymap setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(40, 10, 10, 10) animated:YES];
                
                
                [self set_height:txt_service.text label:txt_service];
//                [self set_height:txt_healthcare.text label:txt_healthcare];
                [self set_height:txt_about.text label:txt_about];
                
                //set Service label, description and bottom line position
                
                [txt_service setFrame:CGRectMake(txt_service.frame.origin.x, Lbl_service.frame.origin.y+Lbl_service.frame.size.height+labelSpace, txt_service.frame.size.width, txt_service.frame.size.height)];
                [line1_imgview setFrame:CGRectMake(line1_imgview.frame.origin.x, txt_service.frame.origin.y+txt_service.frame.size.height+space, line1_imgview.frame.size.width, line1_imgview.frame.size.height)];
                
                //set Timing label, description and bottom line posotion
                [Lbl_timing setFrame:CGRectMake(Lbl_timing.frame.origin.x, line1_imgview.frame.origin.y+line1_imgview.frame.size.height+space, Lbl_timing.frame.size.width, Lbl_timing.frame.size.height)];
                [timing_lbl setFrame:CGRectMake(timing_lbl.frame.origin.x, Lbl_timing.frame.origin.y+Lbl_timing.frame.size.height+labelSpace, timing_lbl.frame.size.width, timing_lbl.frame.size.height)];
                [line2_imgview setFrame:CGRectMake(line2_imgview.frame.origin.x, timing_lbl.frame.origin.y+timing_lbl.frame.size.height+space, line2_imgview.frame.size.width, line2_imgview.frame.size.height)];
                
                //set Share label, share button and bottom line posotion
                [Lbl_Share setFrame:CGRectMake(Lbl_Share.frame.origin.x, line2_imgview.frame.origin.y+line2_imgview.frame.size.height+space, Lbl_Share.frame.size.width, Lbl_Share.frame.size.height)];
                [facebook_btn setFrame:CGRectMake(facebook_btn.frame.origin.x, Lbl_Share.frame.origin.y+Lbl_Share.frame.size.height+space, facebook_btn.frame.size.width, facebook_btn.frame.size.height)];
                [twiter_btn setFrame:CGRectMake(twiter_btn.frame.origin.x, Lbl_Share.frame.origin.y+Lbl_Share.frame.size.height+space, twiter_btn.frame.size.width, twiter_btn.frame.size.height)];
                [whatspp_btn setFrame:CGRectMake(whatspp_btn.frame.origin.x, Lbl_Share.frame.origin.y+Lbl_Share.frame.size.height+space, whatspp_btn.frame.size.width, whatspp_btn.frame.size.height)];
                [line3_imgview setFrame:CGRectMake(line3_imgview.frame.origin.x, facebook_btn.frame.origin.y+facebook_btn.frame.size.height+space, line3_imgview.frame.size.width, line3_imgview.frame.size.height)];
                
                //set Helthcare label, description and bottom line
                [Lbl_healthcare setFrame:CGRectMake(Lbl_healthcare.frame.origin.x, line3_imgview.frame.origin.y+line3_imgview.frame.size.height+space, Lbl_healthcare.frame.size.width, Lbl_healthcare.frame.size.height)];
//                [txt_healthcare setFrame:CGRectMake(txt_healthcare.frame.origin.x, Lbl_healthcare.frame.origin.y+Lbl_healthcare.frame.size.height+labelSpace, txt_healthcare.frame.size.width, txt_healthcare.frame.size.height)];
                [_call_btn setFrame:CGRectMake(_call_btn.frame.origin.x, Lbl_healthcare.frame.origin.y+Lbl_healthcare.frame.size.height+space, _call_btn.frame.size.width, _call_btn.frame.size.height)];
                [_map_btn setFrame:CGRectMake(_map_btn.frame.origin.x, Lbl_healthcare.frame.origin.y+Lbl_healthcare.frame.size.height+space, _map_btn.frame.size.width, _map_btn.frame.size.height)];
                [_review_btn setFrame:CGRectMake(_review_btn.frame.origin.x, Lbl_healthcare.frame.origin.y+Lbl_healthcare.frame.size.height+space, _review_btn.frame.size.width, _review_btn.frame.size.height)];
                
                [line4_imgview setFrame:CGRectMake(line4_imgview.frame.origin.x, _call_btn.frame.origin.y+_call_btn.frame.size.height+space, line4_imgview.frame.size.width, line4_imgview.frame.size.height)];
                
                //set frame of information view
                [info_view setFrame:CGRectMake(info_view.frame.origin.x, info_view.frame.origin.y, info_view.frame.size.width, line4_imgview.frame.size.height+line4_imgview.frame.origin.y+space)];
                
                //set frame of mapView
                [mymap setFrame:CGRectMake(mymap.frame.origin.x, info_view.frame.origin.y+info_view.frame.size.height+space1, mymap.frame.size.width, mymap.frame.size.height)];
                
                //set frame of about detail label
                [txt_about setFrame:CGRectMake(txt_about.frame.origin.x, mymap.frame.origin.y+mymap.frame.size.height+space, txt_about.frame.size.width, txt_about.frame.size.height)];
                
                //set frame of appointment button
                [appointment_btn setFrame:CGRectMake(appointment_btn.frame.origin.x, txt_about.frame.origin.y+txt_about.frame.size.height+space, appointment_btn.frame.size.width, appointment_btn.frame.size.height)];
                
                //Set Position of verticale dots
                [point1 setFrame:CGRectMake(point1.frame.origin.x, Lbl_timing.frame.origin.y, point1.frame.size.width, point1.frame.size.height)];
                [point2 setFrame:CGRectMake(point2.frame.origin.x, Lbl_Share.frame.origin.y, point2.frame.size.width, point2.frame.size.height)];
                [point3 setFrame:CGRectMake(point3.frame.origin.x, Lbl_healthcare.frame.origin.y, point3.frame.size.width, point3.frame.size.height)];
                
                //Set frame of verticale line
                _verticalHeight.constant=line4_imgview.frame.origin.y-vrtclHeight;
                
                //Set scrolling size
                [main_scroll setContentSize:CGSizeMake(main_scroll.frame.size.width, appointment_btn.frame.origin.y+appointment_btn.frame.size.height+6)];
                
                fav_btn.enabled = YES;
            }
            else
            {
                [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
            }
            [DejalBezelActivityView removeViewAnimated:YES];
        }
        else
        {
            [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
            [DejalBezelActivityView removeViewAnimated:YES];
        }
    }
    else
    {
        NSLog(@"Data not found");
        [app Show_Alert:@"Failed" SubTitle:@"Failed to retrive data from server" CloseTitle:@"OK"];
        [DejalBezelActivityView removeViewAnimated:YES];
    }
}

#pragma mark - UITextView Action Method
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

#pragma mark - Map delegate Method
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    if(annotation != mymap.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mymap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        //pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        pinView.image = [UIImage imageNamed:@"map_pin.png"];    //as suggested by Squatch
    }
    else
    {
        [mymap.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

#pragma mark - Locaton Delegate Method
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        long_str = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        lat_str = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
      
        if([app Check_Connection])
        {
            [self GetData:[NSString stringWithFormat:@"getprofilefulldetail.php?profile_id=%@&lat=%@&lon=%@",Profile_id,lat_str,long_str]];
        } else {
            [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
            [DejalBezelActivityView removeViewAnimated:YES];
        }
        [locationManager stopUpdatingLocation];
        locationManager = nil;
    }
}

#pragma mark - Check Favourites
-(void)CheckFavourite
{
    SQLFile *new =[[SQLFile alloc]init];
    
    NSString *querynew =[NSString stringWithFormat:@"select * from Favorite where id = %@",[res_dict valueForKey:@"id"]];
    NSMutableArray *arr_fav = [new select_favou:querynew];
    
    if (arr_fav.count > 0)
    {
        [fav_btn setImage:[UIImage imageNamed:@"favorite_btn.png"] forState:UIControlStateNormal];
        [fav_btn setTag:23];
    }
    else
    {
        [fav_btn setImage:[UIImage imageNamed:@"unfavorite_btn.png"] forState:UIControlStateNormal];
        [fav_btn setTag:22];
    }
}

#pragma mark - Button Click Method
-(IBAction)Btn_bookApointment:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"]length]>0)
    {
        Appointment *appointment_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Appointment"];
        appointment_page.doctor_id=[res_dict valueForKey:@"id"];
        appointment_page.EmailId=[res_dict valueForKey:@"email"];
       
        [self.navigationController pushViewController:appointment_page animated:YES];
    } else {
        SCLAlertView *alert=[[SCLAlertView alloc]init];
        [alert addButton:NSLocalizedString(@"Alert_Yes", @"") target:self selector:@selector(Btn_Yes_Appointmene:)];
        
        UIColor *color = [UIColor colorWithRed:13.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showCustom:self image:nil color:color title:NSLocalizedString(@"Alert_title1", @"") subTitle:NSLocalizedString(@"Alert_Sub2", @"") closeButtonTitle:NSLocalizedString(@"Alert_Close1", @"") duration:0.0f];
    }
}

//Favourite button
-(IBAction)Favorite:(UIButton *)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
    SQLFile *new=[[SQLFile alloc]init];
    if(sender.tag==22)
    {
        [sender setTag:23];
        NSString *passingstr=[NSString stringWithFormat:@"insert into Favorite values('%@','%@','%@','%@','%@','%@')",[res_dict valueForKey:@"id"],[res_dict valueForKey:@"services"],[res_dict valueForKey:@"lat"],[res_dict valueForKey:@"lon"],[res_dict valueForKey:@"name"],type];
        
        NSLog(@"%@",passingstr);
        if ([new operationdb:passingstr]==YES)
        {
            
        }
        [fav_btn setImage:[UIImage imageNamed:@"favorite_btn.png"] forState:UIControlStateNormal];
    }
    else
    {
        sender.tag=22;
        NSString *passingstr=[NSString stringWithFormat:@"DELETE FROM Favorite WHERE id =%@",[res_dict valueForKey:@"id"]];
        if ([new operationdb:passingstr]==YES)
        {
        }
        NSLog(@"%@",passingstr);
        [fav_btn setImage:[UIImage imageNamed:@"unfavorite_btn.png"] forState:UIControlStateNormal];
    }
    
}
-(IBAction)Btn_Review:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
//    if([type isEqualToString:NSLocalizedString(@"Favorite_Doctor", @"")])
//    {
//        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"]length]>0)
//        {
//            Review *review_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Review"];
//            review_page.profile_id=[res_dict valueForKey:@"id"];
//            [self.navigationController pushViewController:review_page animated:YES];
//        }
//        else
//        {
//            SCLAlertView *alert=[[SCLAlertView alloc]init];
//            [alert addButton:NSLocalizedString(@"Alert_Yes", @"") target:self selector:@selector(Btn_Yes:)];
//
//            UIColor *color = [UIColor colorWithRed:13.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
//            [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
//            [alert showCustom:self image:nil color:color title:NSLocalizedString(@"Alert_title1", @"") subTitle:NSLocalizedString(@"Alert_Sub1", @"") closeButtonTitle:NSLocalizedString(@"Alert_Close1", @"") duration:0.0f];
//        }
//    }
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"]length]>0)
    {
        Review *review_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Review"];
        review_page.profile_id=[res_dict valueForKey:@"id"];
        [self.navigationController pushViewController:review_page animated:YES];
    }
    else
    {
        SCLAlertView *alert=[[SCLAlertView alloc]init];
        [alert addButton:NSLocalizedString(@"Alert_Yes", @"") target:self selector:@selector(Btn_Yes:)];
        
        UIColor *color = [UIColor colorWithRed:13.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showCustom:self image:nil color:color title:NSLocalizedString(@"Alert_title1", @"") subTitle:NSLocalizedString(@"Alert_Sub1", @"") closeButtonTitle:NSLocalizedString(@"Alert_Close1", @"") duration:0.0f];
    }
}

-(IBAction)Btn_Yes:(id)sender
{
    Login *login_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    login_page.profile_id=[res_dict valueForKey:@"id"];
    login_page.page_name=NSLocalizedString(@"Review_Title", @"");
    [self.navigationController pushViewController:login_page animated:YES];
}

-(IBAction)Btn_Yes_Appointmene:(id)sender
{
    Login *login_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    login_page.profile_id=[res_dict valueForKey:@"id"];
    login_page.page_name=NSLocalizedString(@"Appointment_Title", @"");
    [self.navigationController pushViewController:login_page animated:YES];
}


-(IBAction)Btn_Back:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
   
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)Btn_Map:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
//
    NSLog(@"Latitude :: %f, Longitude :: %f",[[res_dict valueForKey:@"lat"] doubleValue],[[res_dict valueForKey:@"lon"] doubleValue]);
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake([[res_dict valueForKey:@"lat"] floatValue], [[res_dict valueForKey:@"lon"] floatValue]);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    NSLog(@"CheckNaem %@",name_lbl.text);
    endingItem.name = name_lbl.text;

    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    [endingItem openInMapsWithLaunchOptions:launchOptions];
    
//    NSURL *mapurl=[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%f,%f",[[res_dict valueForKey:@"lat"] doubleValue],[[res_dict valueForKey:@"lon"] doubleValue]]];
//    [[UIApplication sharedApplication]openURL:mapurl];
    
    

}
-(IBAction)Btn_Mail:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setToRecipients:[NSArray arrayWithObjects:[res_dict valueForKey:@"email"],nil]];
        [mailCont setSubject:[NSString stringWithFormat:@"Contact %@",type]];
        
        NSString *name = [NSString stringWithFormat:@"%@",[res_dict valueForKey:@"name"]];
        
        
        NSString *html =[NSString stringWithFormat:@"<html><body>Write your query to %@ here</html>",name];
        
        [mailCont setMessageBody:html isHTML:YES];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    
}

-(IBAction)Btn_Call:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
    NSString *phoneNumber = [@"tel://" stringByAppendingString:[res_dict valueForKey:@"phone"]];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else
    {
        [app Show_Alert:@"Failed" SubTitle:@"Your device does not support calling functionality" CloseTitle:@"OK"];
    }
}

#pragma mark Social Share Method
- (IBAction)Facebook:(id)sender
{
    NSString *str =[NSString stringWithFormat:@"%@ is specialist in service %@, you can contact him on %@, or visit him at %@",[res_dict valueForKey:@"name"],[res_dict valueForKey:@"about"],[res_dict valueForKey:@"phone"],[res_dict valueForKey:@"address"]];//helthcare
//
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL=[NSURL URLWithString:@"http://redixbit.com"];
    content.quote =str;
   
    

    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
//    [FBSDKMessageDialog showWithContent:content delegate:self];
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//
//        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//
//
//
//
//        [controller setInitialText:str];
//        [controller addURL:[NSURL URLWithString:@"http://www.redixbit.com"]];
//
//
//        [self presentViewController:controller animated:YES completion:Nil];
//
//    }
}

//Share With WhatsApp
- (IBAction)Whatsapp:(id)sender
{
    NSString * msg = [NSString stringWithFormat:@"Name:%@\n Services:\n%@",[res_dict valueForKey:@"name"],[res_dict valueForKey:@"services"]];
//    NSString *url1= [image_Url stringByAppendingString:[res_dict valueForKey:@"icon"]];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url1]];
//    UIImage *shared_image = [UIImage imageWithData:imageData];

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

//Share With SMS
// send Details By Message
- (void)Message
{
    if(![MFMessageComposeViewController canSendText])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        UIColor *color = [UIColor colorWithRed:13.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
        
        [alert showCustom:self image:nil color:color title:@"Failed" subTitle:@"Your Device can not send SMS" closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    {
        NSArray *recipents = @[@"9999999999"];
        //        NSString *title = @"RESERVA DESDE NEARME";
        //        NSString *name = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Name", @""),self.txt_name.text];
        //        NSString *MailID = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Mail Id", @""),self.txt_mail_id.text];
        //        NSString *ContactNo = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Phone Number", @""),self.txt_phone.text];
        //        NSString *No_of_Person = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Person", @""),self.txt_num_of_person.text];
        //        NSString *Date = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Date", @""),self.txt_Date.text];
        //        NSString *Time = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Time", @""),self.txt_Time.text];
        //        NSString *Comment = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Comment", @""),self.txt_comments.text];
        //
        //        NSString *message = [[[[[[[[[[[[[[title stringByAppendingString:@"\n"] stringByAppendingString:name] stringByAppendingString:@",\n"] stringByAppendingString:MailID]
        //                                      stringByAppendingString:@",\n"]
        //                                     stringByAppendingString:ContactNo]
        //                                    stringByAppendingString:@",\n"]
        //                                   stringByAppendingString:No_of_Person]
        //                                  stringByAppendingString:@",\n"]
        //                                 stringByAppendingString:Date]
        //                                stringByAppendingString:@",\n"]
        //                               stringByAppendingString:Time]
        //                              stringByAppendingString:@",\n"]
        //                             stringByAppendingString:Comment];
        
         NSString *message = [NSString stringWithFormat:@"%@\n %@",[res_dict valueForKey:@"name"],[res_dict valueForKey:@"services"]];
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setRecipients:recipents];
        [messageController setSubject:NSLocalizedString(@"Subject", @"")];
        [messageController setBody:message];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }
}

//Share With Twitter
- (IBAction)Twitter:(id)sender
{
//    [self Message];
    NSString *tweet =[NSString stringWithFormat:@"%@\n\n %@",[res_dict valueForKey:@"name"],[res_dict valueForKey:@"twiter"]];
    NSString *tweetAppUrl = tweet;
    
    tweetAppUrl = [tweetAppUrl stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    tweetAppUrl = [tweetAppUrl stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    tweetAppUrl = [tweetAppUrl stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    tweetAppUrl = [tweetAppUrl stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    tweetAppUrl = [tweetAppUrl stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    tweetAppUrl = [tweetAppUrl stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    tweetAppUrl = [tweetAppUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    tweet = [tweet stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://post?message=%@",tweet]]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://post?message=%@",tweet]]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/share?text=%@",tweet]]];
    }
////    mySLcomposerSheet = [[SLComposeViewController alloc]init];
////    mySLcomposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
////    [mySLcomposerSheet setInitialText:[NSString stringWithFormat:@"%@\n%@",name_lbl.text,[res_dict valueForKey:@"services"]]];
////    [mySLcomposerSheet addImage:fbImage];
////    [mySLcomposerSheet addURL:[NSURL URLWithString:GameUrl]];
////    [mySLcomposerSheet setAccessibilityElementsHidden:YES];
////    [self presentViewController:mySLcomposerSheet animated:YES completion:NULL];
}

#pragma mark - Buy Now button
- (IBAction)Btn_Buynow:(id)sender {
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"]length]>0) {
        Appointment *appointment_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Appointment"];
//         appointment_page.doctor_id=[res_dict valueForKey:@"id"];
        appointment_page.doctor_detail_dict = res_dict;
        
         [self.navigationController pushViewController:appointment_page animated:YES];
    } else {
        SCLAlertView *alert=[[SCLAlertView alloc]init];
        [alert addButton:NSLocalizedString(@"Alert_Yes", @"") target:self selector:@selector(Btn_Yes:)];
        
        UIColor *color = [UIColor colorWithRed:13.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showCustom:self image:nil color:color title:NSLocalizedString(@"Alert_title1", @"") subTitle:NSLocalizedString(@"Alert_Sub1", @"") closeButtonTitle:NSLocalizedString(@"Alert_Close1", @"") duration:0.0f];
    }
}

#pragma mark - MFMailComposerDelegate method
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Set UILabel Frame
//calculate frame of UILabel according to text
-(void)set_height:(NSString *)str label:(UILabel *)lbl
{
    CGSize maximumLabelSize = CGSizeMake(lbl.frame.size.width, FLT_MAX);
    CGSize expectedLabelSize = [str sizeWithFont:lbl.font constrainedToSize:maximumLabelSize lineBreakMode:lbl.lineBreakMode];
    //adjust the label the the new height.
    CGRect newFrame = lbl.frame;
    newFrame.size.height = expectedLabelSize.height;
    lbl.frame = newFrame;
}

#pragma mark - Other Methods
-(void)Set_language
{
    Lbl_title.text=NSLocalizedString(@"Detail_Title", @"");
    Lbl_service.text=NSLocalizedString(@"Detail_Description", @"");
    Lbl_timing.text=NSLocalizedString(@"Detail_Timing", @"");
    Lbl_Share.text=NSLocalizedString(@"Detail_Share", @"");
    Lbl_healthcare.text=NSLocalizedString(@"LblContactUs", @"");
    ratting_lbl.text = NSLocalizedString(@"Detail_Rating", @"");
    distance_lbl.text = NSLocalizedString(@"Detail_Distance", @"");
    [buynowButton setTitle:NSLocalizedString(@"buynow_button_text", @"") forState:UIControlStateNormal];
}
-(void)set_radius
{
    if(iPhoneVersion==4 || iPhoneVersion==5)
    {
        radius_value=4;
    }
    else
    {
        radius_value=6;
    }
}

@end
