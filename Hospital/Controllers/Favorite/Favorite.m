//
//  Favorite.m
//  Hospital
//
//  Created by Redixbit on 11/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "Favorite.h"
#import "SQLFile.h"
#import "Detail.h"
#import "SCLAlertView.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "Constants.h"
#import "Pharmcy_Detail.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
@interface Favorite ()<GADBannerViewDelegate>
{
    AppDelegate *app;
    NSString *language;
}
@property (strong, nonatomic) GADBannerView *bannerView;

@end

@implementation Favorite

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

        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"CheckOut");
    [self initiateAds];
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    fav_table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    title_lbl.text=NSLocalizedString(@"Favorite_Title", @"");
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
    fav_table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    if(iPhoneVersion==4 || iPhoneVersion==5)
    {
        fontsize=12;
    }
    else if(iPhoneVersion==6)
    {
        fontsize=15;
        
    }
    else if(iPhoneVersion==61)
    {
        fontsize=17;
    }
    else if(iPhoneVersion==10)
    {
        fontsize=17;
    }
    else
    {
        fontsize=30;
    }
    arr_favourity=[[NSMutableArray alloc]init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    section_arr=[[NSMutableArray alloc]init];
    title_arr=[[NSMutableArray alloc]init];
    
    SQLFile *new =[[SQLFile alloc]init];
    
    NSString *query_doc =[NSString stringWithFormat:@"select * from Favorite where Type ='%@'",NSLocalizedString(@"Favorite_Doctor", @"")];
    NSString *query_hos =[NSString stringWithFormat:@"select * from Favorite where Type ='%@'",NSLocalizedString(@"Favorite_Hospital", @"")];
    NSString *query_phr =[NSString stringWithFormat:@"select * from Favorite where Type ='%@'",NSLocalizedString(@"Favorite_Pharmacies", @"")];
    
    doc_arr = [new select_favou:query_doc];
    pharmacies_arr = [new select_favou:query_phr];
    hospital_arr = [new select_favou:query_hos];
    
    if([doc_arr count]>0)
    {
        [section_arr addObject:doc_arr];
        [title_arr addObject:NSLocalizedString(@"Favorite_Doctor", @"")];
    }
   
    if([pharmacies_arr count]>0)
    {
        [section_arr addObject:pharmacies_arr];
        [title_arr addObject:NSLocalizedString(@"Favorite_Pharmacies", @"")];
    }
    if([hospital_arr count]>0)
    {
        [section_arr addObject:hospital_arr];
        [title_arr addObject:NSLocalizedString(@"Favorite_Hospital", @"")];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Location Delegate Mthod
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
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
       
        [locationManager stopUpdatingLocation];
        locationManager = nil;

        [self Add_Distance:doc_arr Location:newLocation];
        [self Add_Distance:pharmacies_arr Location:newLocation];
        [self Add_Distance:hospital_arr Location:newLocation];
        [fav_table reloadData];
    }
    [DejalBezelActivityView removeViewAnimated:YES];
}

#pragma mark - Distance calculation
-(void)Add_Distance:(NSMutableArray *)arr_fav Location:(CLLocation *)newLocation
{
    for (int i=0; i<[arr_fav count]; i++)
    {
        
        NSMutableDictionary *temp = [arr_fav objectAtIndex:i];
        
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[temp objectForKey:@"Latitude"] doubleValue] longitude:[[temp objectForKey:@"Longitude"]doubleValue]];
        
        CLLocationDistance distance = [locA distanceFromLocation:newLocation];
        
        NSLog(@"Calculated Miles %@", [NSString stringWithFormat:@"%.1fmi",(distance/1609.344)]);
        
        [temp setValue:[NSString stringWithFormat:@"%0.02f",(distance/1000.0)] forKey:@"Miles"];
        
        [arr_fav replaceObjectAtIndex:i withObject:temp];
        
    }
}
#pragma mark - UITableView Delegate and Datasource Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [section_arr count];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.sectionHeaderHeight)];
    UIView *view_background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.sectionHeaderHeight)];
    view_background.backgroundColor = [UIColor whiteColor];
    [view addSubview:view_background];
    UIImageView *heaer_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.sectionHeaderHeight)];
    heaer_image.image=[UIImage imageNamed:@"dr_title_bg.png"];
    [view addSubview:heaer_image];

    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-20, tableView.sectionHeaderHeight)];
    title.font=[UIFont fontWithName:@"Raleway" size:fontsize];
  

    title.text=[title_arr objectAtIndex:section];
    if([title.text isEqualToString:NSLocalizedString(@"Favorite_Doctor", @"")])
    {
//        if ([language isEqualToString:country]) {
//            NSLog(@"CheRtl2");
//            cell_image.image = [cell_image.image imageFlippedForRightToLeftLayoutDirection];
//
//
//        }
//        else
//        {
//
//        }
        title.textColor=[UIColor colorWithRed:176.0/255.0f green:63.0/255.0f blue:71.0/255.0f alpha:1.0];
        heaer_image.image=[UIImage imageNamed:@"dr_title_bg.png"];
    }
    else if([title.text isEqualToString:NSLocalizedString(@"Favorite_Pharmacies", @"")])
    {
        title.textColor=[UIColor colorWithRed:65/255.0f green:137/255.0f blue:75/255.0f alpha:1.0];
        heaer_image.image=[UIImage imageNamed:@"pharmacies_title_bg.png"];
    }
    else if([title.text isEqualToString:NSLocalizedString(@"Favorite_Hospital", @"")])
    {
        title.textColor=[UIColor colorWithRed:63.0/255.0f green:142/255.0f blue:205/255.0f alpha:1.0];
        heaer_image.image=[UIImage imageNamed:@"hospital_title_bg.png"];
    }
    [view addSubview:title];
       return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[section_arr objectAtIndex:section]count];

   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellid";

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
        UILabel *first_ch=(UILabel *)[cell viewWithTag:101];

        UILabel *name=(UILabel *)[cell viewWithTag:102];
    
        UILabel *service=(UILabel *)[cell viewWithTag:103];
    
        UILabel *distance=(UILabel *)[cell viewWithTag:104];
    UIImageView *cell_image=(UIImageView *)[cell viewWithTag:105];
    
    
    
    
    NSLog(@"%d",[section_arr count]);
        for(int i=0;i<[section_arr count];i++)
        {
            if ([[[[section_arr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"Type"] isEqualToString:NSLocalizedString(@"Favorite_Doctor", @"")])
            {
                for(int i=0;i<[doc_arr count];i++)
                {
                    
                    cell_image.image=[UIImage imageNamed:@"dr_cell"];
                    if ([language isEqualToString:country]) {
                        NSLog(@"CheRtl2");
                        cell_image.image = [cell_image.image imageFlippedForRightToLeftLayoutDirection];
                        
                        
                    }
                    else
                    {
                        
                    }
                    first_ch.text=[[[[doc_arr objectAtIndex:indexPath.row]valueForKey:@"Name"] substringToIndex:1]uppercaseString];
                    name.text=[[doc_arr objectAtIndex:indexPath.row]valueForKey:@"Name"];
                    service.text=[[doc_arr objectAtIndex:indexPath.row]valueForKey:@"Services"];
                    distance.text=[NSString stringWithFormat:@"%.2f %@",[[[doc_arr objectAtIndex:indexPath.row]valueForKey:@"Miles"]floatValue],NSLocalizedString(@"km", @"")];
                }
            }
           
            else  if([[[[section_arr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"Type"] isEqualToString:NSLocalizedString(@"Favorite_Pharmacies", @"")])
            {
                for(int i=0;i<[pharmacies_arr count];i++)
                {
                    cell_image.image=[UIImage imageNamed:@"pharmacies_cell"];
                    if ([language isEqualToString:country]) {
                        NSLog(@"CheRtl2");
                        cell_image.image = [cell_image.image imageFlippedForRightToLeftLayoutDirection];
                        
                        
                    }
                    else
                    {
                        
                    }
                    first_ch.text=[[[[pharmacies_arr objectAtIndex:indexPath.row]valueForKey:@"Name"] substringToIndex:1]uppercaseString];
                    name.text=[[pharmacies_arr objectAtIndex:indexPath.row]valueForKey:@"Name"];
                    service.text=[[pharmacies_arr objectAtIndex:indexPath.row]valueForKey:@"Services"];
                    distance.text=[NSString stringWithFormat:@"%.2f %@",[[[pharmacies_arr objectAtIndex:indexPath.row]valueForKey:@"Miles"]floatValue],NSLocalizedString(@"km", @"")];
                }
            }
            else
            {
                for(int i=0;i<[hospital_arr count];i++)
                {
                    cell_image.image=[UIImage imageNamed:@"hospital_cell"];
                    if ([language isEqualToString:country]) {
                        NSLog(@"CheRtl2");
                        cell_image.image = [cell_image.image imageFlippedForRightToLeftLayoutDirection];
                        
                        
                    }
                    else
                    {
                        
                    }
                    first_ch.text=[[[[hospital_arr objectAtIndex:indexPath.row]valueForKey:@"Name"] substringToIndex:1]uppercaseString];
                    name.text=[[hospital_arr objectAtIndex:indexPath.row]valueForKey:@"Name"];
                    service.text=[[hospital_arr objectAtIndex:indexPath.row]valueForKey:@"Services"];
                    distance.text=[NSString stringWithFormat:@"%.2f %@",[[[hospital_arr objectAtIndex:indexPath.row]valueForKey:@"Miles"]floatValue],NSLocalizedString(@"km", @"")];
                }
            }
        }
        
    
    

   
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
       return cell;
    
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"checkName %@",[[[section_arr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"Type"]);
    if([[[[section_arr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"Type"] isEqualToString:NSLocalizedString(@"Favorite_Doctor", @"")])
    {
        Detail *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        detail_page.Profile_id=[[doc_arr objectAtIndex:indexPath.row]valueForKey:@"id"];
         detail_page.type=NSLocalizedString(@"Favorite_Doctor", @"");
        [self.navigationController pushViewController:detail_page animated:YES];
    }
   
    else if ([[[[section_arr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"Type"] isEqualToString:NSLocalizedString(@"Favorite_Pharmacies", @"")])
    {
        Pharmcy_Detail *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Pharmcy_Detail"];
        detail_page.Profile_id=[[pharmacies_arr objectAtIndex:indexPath.row]valueForKey:@"id"];
        detail_page.type=NSLocalizedString(@"Favorite_Pharmacies", @"");
        [self.navigationController pushViewController:detail_page animated:YES];
    }
    else if([[[[section_arr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"Type"] isEqualToString:NSLocalizedString(@"Favorite_Hospital", @"")])
    {
        Pharmcy_Detail *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"Pharmcy_Detail"];
        detail_page.Profile_id=[[hospital_arr objectAtIndex:indexPath.row]valueForKey:@"id"];
        detail_page.type=NSLocalizedString(@"Favorite_Hospital", @"");
        [self.navigationController pushViewController:detail_page animated:YES];
    }
    
    
    
    
    
}


-(IBAction)Btn_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    if (self.view.frame.size.height == (fav_table.frame.origin.y + fav_table.frame.size.height + ((iPhoneVersion==10)?34:0)))
    {
        fav_table.frame = CGRectMake(fav_table.frame.origin.x, fav_table.frame.origin.y, fav_table.frame.size.width, fav_table.frame.size.height - _bannerView.frame.size.height - ((iPhoneVersion==-10)?-10:0));
    }
//
    
    
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    
    _bannerView.hidden = YES;
    if (self.view.frame.size.height > (fav_table.frame.origin.y + fav_table.frame.size.height + 50))
    {
        fav_table.frame = CGRectMake(fav_table.frame.origin.x, fav_table.frame.origin.y, fav_table.frame.size.width, fav_table.frame.size.height);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
