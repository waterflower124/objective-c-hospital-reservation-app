//
//  HelthcarePlan.m
//  Hospital
//
//  Created by Redixbit on 12/10/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "HelthcarePlan.h"

@interface HelthcarePlan ()

@end

@implementation HelthcarePlan

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.tbl_helth.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    receivedData1 = [NSMutableData new];
    record_array = [[NSMutableArray alloc] init];
    
    if(iPhoneVersion==4 || iPhoneVersion==5)
    {
        radius_value=4;
    }
    else
    {
        radius_value=6;
    }
    [DejalBezelActivityView activityViewForView:self.tbl_helth withLabel:@"Loading"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    city_name=[[NSUserDefaults standardUserDefaults]objectForKey:@"City_Name"];
    
    if (city_name.length > 0)
    {
        [self GetData:[NSString stringWithFormat:@"localhelthcare.php?city_name=%@",city_name]];
    }
    else
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate=self;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [locationManager requestAlwaysAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Locaton Delegate Method
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        [self getAddressFromLatLon:newLocation];
        [locationManager stopUpdatingLocation];
        locationManager = nil;
    }
}
- (void) getAddressFromLatLon:(CLLocation *)bestLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:bestLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         [[NSUserDefaults standardUserDefaults] setObject:placemark.locality forKey:@"City_Name"];
         [self GetData:[NSString stringWithFormat:@"localhelthcare.php?city_name=%@",placemark.locality]];
     }];
}


#pragma mark Button Click Method
-(IBAction)Btn_Setting:(id)sender
{
    Setting *Setting_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    [self.navigationController pushViewController:Setting_page animated:YES];
}

-(IBAction)Btn_back:(id)sender
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
        NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
        NSLog(@"URL :: %@",StringURL);
        StringURL = [StringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSMutableURLRequest *request = nil;
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:StringURL]];

        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
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
        NSArray *json = [NSJSONSerialization JSONObjectWithData:receivedData1 options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"json : %@, Error :: %@",json,error);
        if (error == nil)
        {
            if ([[[json objectAtIndex:0] valueForKey:@"status"] isEqualToString:@"Success"])
            {
                record_array = [[json objectAtIndex:0] valueForKey:@"health_plan"];
            }
            else
            {
                [app Show_Alert:@"Failed" SubTitle:[NSString stringWithFormat:@"Healthcare plan not available for %@ city",[[NSUserDefaults standardUserDefaults]objectForKey:@"City_Name"]] CloseTitle:@"OK"];
                record_array = nil;
            }
        }
        else
        {
            [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
            record_array = nil;
        }
    }
    else
    {
        NSLog(@"Data not found");
        [app Show_Alert:@"Failed" SubTitle:@"Failed to retrive data from server" CloseTitle:@"OK"];
    }
    [self.tbl_helth reloadData];
    [DejalBezelActivityView removeViewAnimated:YES];
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
    NSDictionary *temp = [record_array objectAtIndex:indexPath.row];

    UILabel *sevice_lbl=(UILabel *)[cell.contentView viewWithTag:102];
    sevice_lbl.text=[temp valueForKey:@"desc"];
    [sevice_lbl sizeToFit];
    
    UILabel *lbl_PhoneNumber=(UILabel *)[cell.contentView viewWithTag:103];
    lbl_PhoneNumber.text = NSLocalizedString(@"lbl_phone", @"");
    
    UIButton *call = (UIButton *)[cell.contentView viewWithTag:104];
    [call setTitleColor:[UIColor colorWithRed:19.0/255.0 green:28.0/255.0 blue:107.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [call setTitle:[temp valueForKey:@"phone_no"] forState:UIControlStateNormal];
    [call addTarget:self action:@selector(makeCall:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    HelthcareDetail *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"HelthcareDetail"];
    detail_page.dataDictionary = temp;
    [self.navigationController pushViewController:detail_page animated:YES];
}

-(IBAction)makeCall:(UIButton *)sender
{
    NSLog(@"Clicked");
    NSString *phoneNumber = [@"tel://" stringByAppendingString:sender.titleLabel.text];
    NSLog(@"Call Number :: %@",sender.titleLabel.text);
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else
    {
        [app Show_Alert:@"Failed" SubTitle:@"Your device does not support calling functionality" CloseTitle:@"OK"];
    }
}
@end
