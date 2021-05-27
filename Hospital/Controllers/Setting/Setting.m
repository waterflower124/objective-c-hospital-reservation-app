//
//  Setting.m
//  Hospital
//
//  Created by Redixbit on 10/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "Setting.h"

@interface Setting ()
{
    NSString *language;
    NSString *RowZero;
}
@end

@implementation Setting
@synthesize lat_str,long_str,speciality_id;

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
        currentCity_lbl.textAlignment = NSTextAlignmentLeft;
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
    }
    else
    {
          NSLog(@"CheRtl");
        currentCity_lbl.textAlignment = NSTextAlignmentRight;
    }
    
    [self set_radius];
    [self Set_Language];
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    receivedData1 = [NSMutableData new];
    
    UIImage *thumbImage;
    if(self.view.frame.size.width>=768)
    {
        thumbImage = [UIImage imageNamed:@"iPad_level_btn.png"];
    }
    else
    {
        thumbImage = [UIImage imageNamed:@"level_btn.png"];
    }
    [radius_slider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    UIImage *sliderLeftTrackImage = [UIImage imageNamed: @"fill_scroll.png"];
    sliderLeftTrackImage = [sliderLeftTrackImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImage *sliderRightTrackImage = [UIImage imageNamed: @"scroll_bg.png"];
    sliderRightTrackImage = [sliderRightTrackImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    [radius_slider setMinimumTrackImage:sliderLeftTrackImage forState:UIControlStateNormal];
    [radius_slider setMaximumTrackImage:sliderRightTrackImage forState:UIControlStateNormal];
    
    city_table.layer.masksToBounds=YES;
    city_table.layer.cornerRadius=table_radius;
    
    city_arr=[[NSMutableArray alloc]init];
    cityId_arr=[[NSMutableArray alloc]init];
    _lblkm.text = NSLocalizedString(@"km", @"");
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderBy"] isEqualToString:@"ASC"])
    {
        [order_switchbtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
        order_switchbtn.tag=11;
        order_lbl.text=NSLocalizedString(@"Setting_Asc", @"");
    }
    else
    {
        [order_switchbtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
        order_switchbtn.tag=111;
         order_lbl.text=NSLocalizedString(@"Setting_Des", @"");
    }

    radius_slider.value=[[[NSUserDefaults standardUserDefaults]objectForKey:@"Radius"]floatValue];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Radius"]);
    radiusValue_lbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"Radius"];
    
    order_imgview.layer.cornerRadius=img_radius;
    order_imgview.clipsToBounds=YES;
    
    radius_imgview.layer.cornerRadius=img_radius;
    radius_imgview.clipsToBounds=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self GetData:@"city.php"];
    [DejalBezelActivityView activityViewForView:[[UIView alloc]initWithFrame:CGRectMake(0, title_lbl.frame.size.height, self.view.frame.size.width, self.view.frame.size.height- title_lbl.frame.size.height)] withLabel:NSLocalizedString(@"Loading_text", @"")];

    radius_slider.enabled=NO;
    [btnRedius setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
   
    NSString *strOnOff = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"OnOff"];
   
    if ([strOnOff isEqualToString:@"off"]) {
        radius_slider.enabled=NO;
        [btnRedius setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
         [self OffAlpa];
    }
    else if ([strOnOff isEqualToString:@"on"])
    {
        radius_slider.enabled=YES;
        [btnRedius setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
         [self OnAlpa];
    }
    else
    {
        radius_slider.enabled=NO;
        [btnRedius setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
        [self OffAlpa];
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
        NSLog(@"URL :: %@",url);
        NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
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
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:receivedData1 options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"json : %@, Error :: %@",resultDic,error);
        if (error == nil)
        {
            city_arr=[[[resultDic valueForKey:@"Cities"] objectAtIndex:0]valueForKey:@"name"];
             NSLog(@"city_arr : %@",city_arr);
          
            cityId_arr=[[[resultDic valueForKey:@"Cities"] objectAtIndex:0]valueForKey:@"id"];
            [city_table reloadData];
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

-(void)set_radius
{
  
    if(iPhoneVersion==4 || iPhoneVersion==5)
    {
        img_radius=6;
        table_radius=8;
    }
    if(iPhoneVersion==6)
    {
        img_radius=8;
        table_radius=10;
    }
    else if(iPhoneVersion==61)
    {
        img_radius=10;
        table_radius=12;
    }
    else
    {
        img_radius=16;
        table_radius=14;
    }
}

#pragma mark - UITableView Datasource and Delegte Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [city_arr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityCell"];
    }
    if(indexPath.row==0)
    {
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(table_radius, table_radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
    else if(indexPath.row==[city_arr count]-1)
    {
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(table_radius, table_radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
    else
    {
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(0, 0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }

    UILabel *city=(UILabel *)[cell viewWithTag:102];
    
    city.text=[city_arr objectAtIndex:indexPath.row];
    UIImageView *selected = (UIImageView *)[cell.contentView viewWithTag:1024];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"City_Name"]length]>0)
    {
        currentCity_lbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"City_Name"];
        NSLog(@"Checksd currentCity_lbl123123%@",currentCity_lbl.text);
    }
    else
    {
        if ([city_arr objectAtIndex:0]) {
            currentCity_lbl.text=[city_arr objectAtIndex:0];
            RowZero = [city_arr objectAtIndex:0];
            NSLog(@"RowZero : %@",RowZero);
            [[NSUserDefaults standardUserDefaults]setObject:RowZero forKey:@"selectClick"];
        }
    }
    
    NSString *selectCity = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectClick"];
    if ([city.text isEqualToString:selectCity])
    {
        selected.image = [UIImage imageNamed:@"righticon.png"];
    }
    else
    {
        selected.image = [UIImage imageNamed:@""];
    }
   

    cell.backgroundColor = [UIColor whiteColor];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentCity_lbl.text=[city_arr objectAtIndex:indexPath.row];
    strCity = [NSString stringWithFormat:@"%@",[city_arr objectAtIndex:indexPath.row]];
    [[NSUserDefaults standardUserDefaults]setObject:strCity forKey:@"selectClick"];
    [[NSUserDefaults standardUserDefaults]setObject:[cityId_arr objectAtIndex:indexPath.row] forKey:@"City"];
    [[NSUserDefaults standardUserDefaults]setObject:[city_arr objectAtIndex:indexPath.row] forKey:@"City_Name"];
    [[NSUserDefaults standardUserDefaults]synchronize];
     [city_table reloadData];

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([city_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [city_table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([city_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [city_table setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark Locaton Delegate Method
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
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
         NSLog(@"Checksd currentCity_lbl%@",currentCity_lbl.text);
     }];
}

#pragma mark Slider Method
- (IBAction)sliderValueChanged:(UISlider *)sender
{
    radius_slider.value=sender.value;
    radiusValue_lbl.text=[NSString stringWithFormat:@"%.0f",radius_slider.value];
    [[NSUserDefaults standardUserDefaults]setObject:radiusValue_lbl.text forKey:@"Radius"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark Switch Method

- (IBAction)RediusChangeSwitch:(UIButton *)sender {
    if([sender tag]==33)
    {
       
        sender.tag=333;
        NSLog(@"Switch is OFF");
        NSString *Redius =@"100000";
        [[NSUserDefaults standardUserDefaults]setObject:Redius forKey:@"Radius1"];
         
        radius_slider.enabled=NO;
        [btnRedius setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"off" forKey:@"OnOff"];
         [self OffAlpa];

    }
    else
    {
        sender.tag=33;
        NSLog(@"Switch is ON");
        radius_slider.enabled=YES;
        [btnRedius setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"on" forKey:@"OnOff"];
        [self OnAlpa];
    }
}

- (IBAction)changeSwitch:(UIButton *)sender
{
    if([sender tag]==111)
    {
        sender.tag=11;
        NSLog(@"Switch is ON");
        order_lbl.text=NSLocalizedString(@"Setting_Asc", @"");
        [[NSUserDefaults standardUserDefaults]setObject:@"ASC" forKey:@"OrderBy"];
        [order_switchbtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
    }
    else
    {
        sender.tag=111;
        order_lbl.text=NSLocalizedString(@"Setting_Des", @"");
        [[NSUserDefaults standardUserDefaults]setObject:@"DES" forKey:@"OrderBy"];
        [order_switchbtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
        NSLog(@"Switch is OFF");
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark extra metthod
-(void)OffAlpa
{
    lblDistance.alpha=0.3;
    radiusValue_lbl.alpha=0.3;
    self.lblkm.alpha=0.3;
     Lbl_Radius.alpha=0.3;
    radius_imgview.alpha = 0.3;
}
-(void)OnAlpa
{
    lblDistance.alpha=1;
    radiusValue_lbl.alpha=1;
    self.lblkm.alpha=1;
    Lbl_Radius.alpha=1;
    radius_imgview.alpha = 1;
}
-(void)Set_Language
{
    title_lbl.text=NSLocalizedString(@"Setting_title", @"");
    Lbl_currentLocation.text=NSLocalizedString(@"Setting_CurrentCity", @"");
    Lbl_Radius.text=NSLocalizedString(@"Setting_Radius", @"");
    Lbl_orderby.text=NSLocalizedString(@"Setting_Order", @"");
    lblRadius.text=NSLocalizedString(@"Setting_Redius", @"");
    lblDistance.text = NSLocalizedString(@"Setting_distance", @"");
    ordering_lbl.text = NSLocalizedString(@"Setting_ordering", @"");
}
-(IBAction)Btn_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
