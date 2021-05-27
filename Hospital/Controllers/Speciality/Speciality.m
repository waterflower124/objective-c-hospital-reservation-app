//
//  Speciality.m
//  Hospital
//
//  Created by Redixbit on 01/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "Speciality.h"

@interface Speciality ()
{
    AppDelegate *app;
    NSString *language;
}
@end

@implementation Speciality
@synthesize category_id;
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
    NSLog(@"CheckCate_Id%@",_city_id);
      NSLog(@"CheckCate_name%@",_City_name);
    language=[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
     language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        NSLog(@"CheRtl2");
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
        
        
    }
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    receivedData1 = [NSMutableData new];
    
    [self Set_language];
    
    img_arr=[[NSMutableArray alloc]init];
    speciality_arr=[[NSMutableArray alloc]init];
    id_arr=[[NSMutableArray alloc]init];
    
    NSLog(@"%@",app.stringToken);
    
    if([app Check_Connection])
    {
        [self GetData:[NSString stringWithFormat:@"specialities.php?category_id=%@",category_id]];
        [DejalBezelActivityView activityViewForView:speciality_collectionview withLabel:NSLocalizedString(@"Loading_text", @"")];
    }
    else
    {
        [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
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
    NSString *StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
    NSLog(@"URL :: %@",StringURL);
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
        NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:receivedData1 options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"json : %@, Error :: %@",json,error);
        if (error == nil)
        {
            NSMutableArray *arr=json;
            speciality_arr=[[[arr objectAtIndex:0]valueForKey:@"Specialities"]valueForKey:@"name"];
            img_arr=[[[arr objectAtIndex:0]valueForKey:@"Specialities"]valueForKey:@"icon"];
            id_arr=[[[arr objectAtIndex:0]valueForKey:@"Specialities"]valueForKey:@"id"];
//            [speciality_collectionview reloadData];
            [speciality_tableview reloadData];
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
    [DejalBezelActivityView removeViewAnimated:YES];
}

//#pragma mark - CollectionView Delegate & Datasource
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//   return [speciality_arr count];
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection_cell" forIndexPath:indexPath];
//
//    UILabel *speciality_label = (UILabel *)[cell.contentView viewWithTag:102];
//    [speciality_label setText:[NSString stringWithFormat:@"%@",[speciality_arr objectAtIndex:indexPath.row]]];
//
//    UIImageView *cell_image = (UIImageView *)[cell.contentView viewWithTag:101];
//
//    if(indexPath.row<=2)
//    {
//         cell_image.image=[UIImage imageNamed:@"first_cell.png"];
//    }
//    else
//    {
//        cell_image.image=[UIImage imageNamed:@"second_cell.png"];
//    }
//
//    UIImageView *Speciality_image = (UIImageView *)[cell.contentView viewWithTag:103];
//    [Speciality_image startLoaderWithTintColor:LoadingColor];
//
//    [Speciality_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",image_Url,[img_arr objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"categories_page_img.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize)
//    {
//        [Speciality_image updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
//    }
//    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//    {
//        [Speciality_image reveal];
//    }];
//
//    return cell;
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    List *list_obj=[self.storyboard instantiateViewControllerWithIdentifier:@"List"];
//    list_obj.speciality_id=[id_arr objectAtIndex:indexPath.row];
//    if([category_id isEqualToString:@"1"])
//    {
//        list_obj.list_type=NSLocalizedString(@"Favorite_Doctor", @"");
//        list_obj.cty_id = _city_id;
//        list_obj.cty_name = _City_name;
//    }
//    else if([category_id isEqualToString:@"2"])
//    {
//        list_obj.list_type=NSLocalizedString(@"Favorite_Pharmacies", @"");
//         list_obj.cty_id = _city_id;
//        list_obj.cty_name = _City_name;
//    }
//    else if([category_id isEqualToString:@"3"])
//    {
//        list_obj.list_type=NSLocalizedString(@"Favorite_Hospital", @"");
//         list_obj.cty_id = _city_id;
//        list_obj.cty_name = _City_name;
//    }
//    [self.navigationController pushViewController:list_obj animated:YES];
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
//}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SpecialityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"specialitytableviewcell"];
        NSDictionary *item = speciality_arr[indexPath.row];
        [cell.specialityImageView sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",image_Url,[img_arr objectAtIndex:indexPath.row]]]];

    cell.specialityLabel.text = [NSString stringWithFormat:@"%@",[speciality_arr objectAtIndex:indexPath.row]];

    return cell;

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [speciality_arr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    List *list_obj=[self.storyboard instantiateViewControllerWithIdentifier:@"List"];
    list_obj.speciality_id=[id_arr objectAtIndex:indexPath.row];
    if([category_id isEqualToString:@"1"]) {
        list_obj.list_type=NSLocalizedString(@"Favorite_Doctor", @"");
        list_obj.cty_id = _city_id;
        list_obj.cty_name = _City_name;
    } else if([category_id isEqualToString:@"2"]) {
        list_obj.list_type=NSLocalizedString(@"Favorite_Pharmacies", @"");
         list_obj.cty_id = _city_id;
        list_obj.cty_name = _City_name;
    } else if([category_id isEqualToString:@"3"]) {
        list_obj.list_type=NSLocalizedString(@"Favorite_Hospital", @"");
         list_obj.cty_id = _city_id;
        list_obj.cty_name = _City_name;
    }
    [self.navigationController pushViewController:list_obj animated:YES];
}




#pragma mark Button Click Method
-(IBAction)Btn_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)Set_language
{
    Lbl_title.text=NSLocalizedString(@"Speciality_Title", @"");
}

@end
