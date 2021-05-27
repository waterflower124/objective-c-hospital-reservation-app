//
//  List.m
//  Hospital
//
//  Created by Redixbit on 27/07/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "List.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface List ()<GADBannerViewDelegate>
{
    NSString *language;
}
@property (strong, nonatomic) GADBannerView *bannerView;

@end

@implementation List
@synthesize Lbl_title,speciality_id,list_type,city_id,lat_str,long_str,setting_press;

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
    if (iPhoneVersion == 5)
    {
        tSize = 50.0f;
    }
    else if(iPhoneVersion == 10)
    {
        tSize = 90.0f;
    }
    else
    {
        tSize = 90.0f;
    }
    
    [self Set_language];
    [self set_radius];
    location_press=YES;
    
    receivedData1 = [NSMutableData new];
    
    neraBy_imageview.hidden=NO;
    city_imageview.hidden=YES;
    AlphabetOrder_imageview.hidden=YES;
    [neraBy_btn setTitleColor:[UIColor colorWithRed:237/255.0 green:87/255.0 blue:114/255.0 alpha:1.0] forState:UIControlStateNormal];
    [city_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [AlphabetOrder_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    record_array=[[NSMutableArray alloc]init];
    record_table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    Lbl_title.text=list_type;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [locationManager requestAlwaysAuthorization];
    }
    [DejalBezelActivityView activityViewForView:record_table withLabel:@"Loading.."];
    [locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _cty_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"City_Name"];
    _cty_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"City"];
    NSLog(@"CheckCITYID %@",_cty_id);
    NSLog(@"CheckCITYNAme %@",_cty_name);
    city_id = [userDefaults objectForKey:@"City"];
    if (city_id !=nil) {
        city_id = [userDefaults objectForKey:@"City"];
    }
    else{
        city_id =_cty_id;
    }
    [self initiateAds];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UITableView Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [record_array count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
           
    }
    cell.backgroundColor=[UIColor clearColor];
    NSDictionary *temp=[record_array objectAtIndex:indexPath.row];
    UILabel *name_lbl=(UILabel *)[cell.contentView viewWithTag:101];
    name_lbl.text=[temp valueForKey:@"name"];
    
    
    UILabel *sevice_lbl=(UILabel *)[cell.contentView viewWithTag:102];
    NSMutableAttributedString* sevice_text = [[self getData: [temp valueForKey:@"services"]] mutableCopy];
    sevice_lbl.attributedText=sevice_text;
    
    UILabel *rating_lbl=(UILabel *)[cell.contentView viewWithTag:103];
    rating_lbl.text=NSLocalizedString(@"List_Ratting", @"");
    
    UILabel *distance_lbl=(UILabel *)[cell.contentView viewWithTag:104];
    distance_lbl.text=NSLocalizedString(@"List_Distance", @"");
    
    UILabel *rating_value=(UILabel *)[cell.contentView viewWithTag:105];
    rating_value.text=[NSString stringWithFormat:@"%0.1f",[[temp valueForKey:@"ratting"] floatValue]];
    
    HCSStarRatingView *starRatingView = (HCSStarRatingView *) [cell.contentView viewWithTag:106];;
    
    starRatingView.value = [rating_value.text floatValue];
    starRatingView.maximumValue =5;
    starRatingView.minimumValue = 0;
    starRatingView.spacing =1;
    starRatingView.allowsHalfStars =YES;
    starRatingView.accurateHalfStars =YES;
    starRatingView.emptyStarImage = [UIImage imageNamed:@"unfill_rate.png"];
    starRatingView.filledStarImage = [UIImage imageNamed:@"fill_rate.png"];
    
    UILabel *distance_value=(UILabel *)[cell.contentView viewWithTag:107];
    distance_value.text=[NSString stringWithFormat:@"%0.2f %@",[[temp valueForKey:@"distance"] floatValue],NSLocalizedString(@"km", @"")];
    
    UILabel *category_lbl=(UILabel *)[cell.contentView viewWithTag:108];
    UIImageView *category_imgview=(UIImageView *)[cell.contentView viewWithTag:109];
    
    category_lbl.hidden = YES;
    category_imgview.hidden = YES;
    
    if([list_type isEqualToString:NSLocalizedString(@"Favorite_Doctor", @"")])
    {
        category_lbl.hidden = NO;
        category_imgview.hidden = NO;
        category_lbl.text=@"D";
        category_imgview.image=[UIImage imageNamed:@"d_bg.png"];
    }
    else if([list_type isEqualToString:NSLocalizedString(@"Favorite_Pharmacies", @"")])
    {
        category_lbl.hidden = NO;
        category_imgview.hidden = NO;
        category_lbl.text=@"P";
        category_imgview.image=[UIImage imageNamed:@"p_bg.png"];
    }
    else if([list_type isEqualToString:NSLocalizedString(@"Favorite_Hospital", @"")])
    {
        category_lbl.hidden = NO;
        category_imgview.hidden = NO;
        category_lbl.text=@"H";
        category_imgview.image=[UIImage imageNamed:@"h_bg.png"];
    }
    if ([language isEqualToString:country]) {
        NSLog(@"CheRtl2");
        category_imgview.image = [category_imgview.image imageFlippedForRightToLeftLayoutDirection];
    }
    
    UIImageView *profile_imgview=(UIImageView *)[cell.contentView viewWithTag:110];
    profile_imgview.layer.cornerRadius=radius_value;
    profile_imgview.clipsToBounds=YES;
    [profile_imgview startLoaderWithTintColor:LoadingColor];
    profile_imgview.layer.borderWidth=1;
    profile_imgview.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    
    NSString *Str_image_name = [NSString stringWithFormat:@"%@",[temp objectForKey:@"icon"]];
    Str_image_name = [Str_image_name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *url1= [image_Url stringByAppendingString:Str_image_name];
    [profile_imgview sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"home_page_cell_img"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [profile_imgview updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        [profile_imgview reveal];
    }];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *temp=[record_array objectAtIndex:indexPath.row];
   if([list_type isEqualToString:NSLocalizedString(@"Favorite_Doctor",@"")])
   {
       
        Detail *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        detail_page.Profile_id=[temp valueForKey:@"id"];
        detail_page.type=NSLocalizedString(@"Favorite_Doctor",@"");
        [self.navigationController pushViewController:detail_page animated:YES];
   }
   else if([list_type isEqualToString:NSLocalizedString(@"Favorite_Hospital",@"")])
   {
       
       Detail *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
       detail_page.Profile_id=[temp valueForKey:@"id"];
       detail_page.type=NSLocalizedString(@"Favorite_Hospital",@"");
       [self.navigationController pushViewController:detail_page animated:YES];
   }
   else
   {
       Pharmcy_Detail *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Pharmcy_Detail"];
       detail_page.Profile_id=[temp valueForKey:@"id"];
       detail_page.type=NSLocalizedString(@"Favorite_Pharmacies",@"");
       [self.navigationController pushViewController:detail_page animated:YES];
   }
}
#pragma mark Call Web Service Method
-(void)Get_Data:(NSString *)str
{
    if([app Check_Connection])
    {
        [DejalBezelActivityView activityViewForView:record_table withLabel:NSLocalizedString(@"Loading_text", @"")];
        NSString *string;
        
        if([list_type isEqualToString:NSLocalizedString(@"Favorite_Doctor", @"")])
        {
            string = [NSString stringWithFormat:@"getprofile.php?specialities_id=%@&lat=%@&lon=%@&%@",speciality_id,lat_str,long_str,str];
        }
        else
        {
            if([list_type isEqualToString:NSLocalizedString(@"Favorite_Hospital", @"")])
            {
                string = [NSString stringWithFormat:@"hospitalandpharmacie.php?category_id=3&lat=%@&lon=%@&%@",lat_str,long_str,str];
            }
            else if([list_type isEqualToString:NSLocalizedString(@"Favorite_Pharmacies", @"")])
            {
                string = [NSString stringWithFormat:@"hospitalandpharmacie.php?category_id=2&lat=%@&lon=%@&%@",lat_str,long_str,str];
            }
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
        if (error == nil)
        {
            if([[[resultDic valueForKey:@"status"]objectAtIndex:0] isEqualToString:@"Failed"])
            {
                [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
                [record_array removeAllObjects];
                [record_table reloadData];
            }
            else
            {
                record_array=[[resultDic valueForKey:@"List_profile"] objectAtIndex:0];
                [record_table reloadData];
                NSLog(@"%@",resultDic);
            }
        }
        else
        {
            [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
        }
        [DejalBezelActivityView removeViewAnimated:YES];
    }
    else
    {
        NSLog(@"Data not found");
        [app Show_Alert:@"Failed" SubTitle:@"Failed to retrive data from server" CloseTitle:@"OK"];
        [DejalBezelActivityView removeViewAnimated:YES];
    }
}

#pragma mark Location Delegate Method
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    record_array = nil;
    [record_table reloadData];
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        long_str = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        lat_str = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        [self getAddressFromLatLon:newLocation];
        if(location_press==YES)
        {
            NSString *strRadius;
            NSString *strOnOff = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"OnOff"];
            if ([strOnOff isEqualToString:@"off"]) {
                
                strRadius = @"100000";
            }
            else if ([strOnOff isEqualToString:@"on"]) {
                
                strRadius = [[NSUserDefaults standardUserDefaults]objectForKey:@"Radius"];
            }
            else
            {
                strRadius = @"100000";
            }
            

            [self Get_Data:[NSString stringWithFormat:@"radius=%@",strRadius]];
        }
        else
        {
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"City"] length]>0)
            {
                [self Get_Data:[NSString stringWithFormat:@"city=%@",city_id]];
            }
            else
            {
                [self Get_Data:[NSString stringWithFormat:@"city=&current_city=%@",city_id]];
            }
        }
        [locationManager stopUpdatingLocation];
        locationManager = nil;
    }
}

- (void) getAddressFromLatLon:(CLLocation *)bestLocation
{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:bestLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
      
//         current_city= placemark.locality;
     }];
}

#pragma mark Button Click Method
-(IBAction)Btn_Setting:(id)sender
{
    Setting *Setting_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    Setting_page.lat_str=lat_str;
    Setting_page.long_str=long_str;
    Setting_page.speciality_id=speciality_id;
    [self.navigationController pushViewController:Setting_page animated:YES];
    
}
-(IBAction)Btn_back:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
 
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)Filter:(UIButton *)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
    if (sender.tag==1)
    {
        location_press=YES;
        neraBy_imageview.hidden=NO;
        city_imageview.hidden=YES;
        AlphabetOrder_imageview.hidden=YES;
        NSString *strRadius;
        NSString *strOnOff = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"OnOff"];
        if ([strOnOff isEqualToString:@"off"]) {
            
            strRadius = @"100000";
        }
        else if ([strOnOff isEqualToString:@"on"]) {
            
            strRadius = [[NSUserDefaults standardUserDefaults]objectForKey:@"Radius"];
        }
        else
        {
            strRadius = @"100000";
        }
        [self Get_Data:[NSString stringWithFormat:@"radius=%@",strRadius]];
        [neraBy_btn setTitleColor:[UIColor colorWithRed:237/255.0 green:87/255.0 blue:114/255.0 alpha:1.0] forState:UIControlStateNormal];
        [city_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [AlphabetOrder_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    else if (sender.tag==2)
    {
        location_press=NO;
        neraBy_imageview.hidden=YES;
        city_imageview.hidden=NO;
        AlphabetOrder_imageview.hidden=YES;
        city_press=YES;
       
        if(current_city.length>0)
        {
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"City"] length]>0)
            {
              
                [self Get_Data:[NSString stringWithFormat:@"city=%@",city_id]];
            }
            else
            {
                [self Get_Data:[NSString stringWithFormat:@"city=&current_city=%@",current_city]];
            }
        }
        else
        {
            NSString *selectCity = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectClick"];
            if (selectCity != nil) {
                 current_city =[[NSUserDefaults standardUserDefaults] stringForKey:@"selectClick"];
                
            }
            else
            {
               current_city =_cty_name;
            }
             [self Get_Data:[NSString stringWithFormat:@"city=&current_city=%@",current_city]];
//

        }
        [city_btn setTitleColor:[UIColor colorWithRed:237/255.0 green:87/255.0 blue:114/255.0 alpha:1.0] forState:UIControlStateNormal];
        [neraBy_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [AlphabetOrder_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    else if (sender.tag==3)
    {
        location_press=NO;
        neraBy_imageview.hidden=YES;
        city_imageview.hidden=YES;
        AlphabetOrder_imageview.hidden=NO;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderBy"] isEqualToString:@"ASC"])
        {
            [self Get_Data:@"orderby=a-z"];
        }
        else
        {
            [self Get_Data:@"orderby=z-a"];
        }
        
        [AlphabetOrder_btn setTitleColor:[UIColor colorWithRed:237/255.0 green:87/255.0 blue:114/255.0 alpha:1.0] forState:UIControlStateNormal];
        [city_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [neraBy_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [DejalBezelActivityView activityViewForView:record_table withLabel:@"Loading.."];
}

-(void)Set_language
{
    language=[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        NSLog(@"CheRtl2");
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
    }
    
    if([list_type isEqualToString:NSLocalizedString(@"Favorite_Doctor", @"")]) {
        Lbl_title.text=NSLocalizedString(@"Favorite_Doctor", @"");
    } else if([list_type isEqualToString:NSLocalizedString(@"Favorite_Hospital", @"")]) {
        Lbl_title.text=NSLocalizedString(@"Favorite_Hospital", @"");
    } else if([list_type isEqualToString:NSLocalizedString(@"Favorite_Pharmacies", @"")]) {
        Lbl_title.text=NSLocalizedString(@"Favorite_Pharmacies", @"");
    }
    
    neraBy_btn.titleLabel.text=NSLocalizedString(@"List_Nearby", @"");
    city_btn.titleLabel.text=NSLocalizedString(@"List_City", @"");
    AlphabetOrder_btn.titleLabel.text=NSLocalizedString(@"List_ALphabetical", @"");
}
// Tells the delegate an ad request loaded an ad.
#pragma mark#Banner
-(void)initiateAds
{
    _bannerView.hidden = YES;
    if ([kShowAds isEqualToString:@"YES"])
    {
        _bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, round(self.view.frame.size.height -  (SCREEN_SIZE.height * 0.088) - ((iPhoneVersion==10)?21:0)), [UIScreen mainScreen].bounds.size.width, round(SCREEN_SIZE.height * 0.088))];
        _bannerView.hidden = NO;
        self.bannerView.adUnitID = AddsID;
        self.bannerView.rootViewController = self;
        _bannerView.delegate = self;
        GADRequest *req = [GADRequest request];
        //        req.testDevices = @[ @"162e5e94ed20dd4bfbc68b5ffecbfdf0" ];
        [self.bannerView loadRequest:req];
        [self.view addSubview:_bannerView];
    }
}
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
    _bannerView.hidden=NO;
    if (self.view.frame.size.height == (record_table.frame.origin.y + record_table.frame.size.height + ((iPhoneVersion==10)?34:0)))
    {
        record_table.frame = CGRectMake(record_table.frame.origin.x, record_table.frame.origin.y, record_table.frame.size.width, record_table.frame.size.height - _bannerView.frame.size.height - ((iPhoneVersion==-10)?-10:0));
    }
    
    
    
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
  
    _bannerView.hidden = YES;
    if (self.view.frame.size.height > (record_table.frame.origin.y + record_table.frame.size.height + 50))
    {
        record_table.frame = CGRectMake(record_table.frame.origin.x, record_table.frame.origin.y, record_table.frame.size.width, record_table.frame.size.height);
    }
  
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}
@end

