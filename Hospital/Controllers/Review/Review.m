//
//  Review.m
//  Hospital
//
//  Created by Redixbit on 06/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "Review.h"
#import "Constants.h"
@interface Review ()
{
    NSString *language;
}
@end

@implementation Review
@synthesize profile_id,user_id,rating_str;

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
         txt_addreviw.textAlignment = UITextAlignmentRight;
    }
    receivedData1 = [NSMutableData new];
    
    Review_Table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    review_arr=[[NSMutableArray alloc]init];
    
    [self Set_language];
    
    View_AddReview.hidden=YES;
    View_DisplayReview.hidden=YES;
    
    user_id=[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([app Check_Connection])
    {
        [DejalBezelActivityView activityViewForView:Review_Table withLabel:NSLocalizedString(@"Loading_text", @"")];
        [self GetData:[NSString stringWithFormat:@"getreview.php?profile_id=%@",profile_id]];
    }
    else
    {
        [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
    }
}

#pragma mark - Retirve Data From Webservice
-(void)GetData:(NSString *)url
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
            if(is_addReview==YES)
            {
                if([[[resultDic valueForKey:@"status"]objectAtIndex:0] isEqualToString:@"Success"])
                {
                    [app Show_Alert:NSLocalizedString(@"Info_tittle", @"") SubTitle:NSLocalizedString(@"Info_subtitle", @"") CloseTitle:NSLocalizedString(@"Info_close", @"")];
                    [self GetData:[NSString stringWithFormat:@"getreview.php?profile_id=%@",profile_id]];
                    is_addReview=NO;
                }
            }
            else
            {
                if([[[resultDic valueForKey:@"status"]objectAtIndex:0] isEqualToString:@"Failed"])
                {
                    [app Show_Alert:NSLocalizedString(@"Error Alert Title", @"") SubTitle:NSLocalizedString(@"Error Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Error Alert closeButtonTitle", @"")];
                }
                else
                {
                    review_arr=[[resultDic valueForKey:@"List_review"]objectAtIndex:0];
                    NSLog(@"REview list=======%@",review_arr);
                    [Review_Table reloadData];
                }
            }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Set_language
{
    Lbl_title.text=NSLocalizedString(@"Review_Title", @"");
    Lbl_Submit.text=NSLocalizedString(@"Review_Submit", @"");
    Lbl_Cancel.text=NSLocalizedString(@"Review_Cancel", @"");
    Lbl_yourExperience.text=NSLocalizedString(@"Review_Exp", @"");
    txt_addreviw.text=NSLocalizedString(@"Review_Placeholder", @"");
}

#pragma mark - UITextView Delegate Method
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:NSLocalizedString(@"Review_Placeholder", @"")])
    {
        textView.text=nil;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length==0)
    {
        textView.text=NSLocalizedString(@"Review_Placeholder", @"");
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView==txt_addreviw)
    {
        if([textView.text isEqualToString:NSLocalizedString(@"Review_Placeholder", @"")])
        {
            textView.text=nil;
        }
    }
}
#pragma mark Button Click method
-(IBAction)Btn_Back:(id)sender
{
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    if (_AlreadyLogin)
    {
        [navigationArray removeObjectAtIndex: navigationArray.count- (2)];  // You can pass your index here
        self.navigationController.viewControllers = navigationArray;
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)ADD_Review:(id)sender
{
    is_addReview=YES;
    [UIView transitionWithView:View_AddReview
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        View_AddReview.hidden = NO;
                    }
                    completion:NULL];
}
-(IBAction)Btn_Cancle:(id)sender
{
    [UIView transitionWithView:View_AddReview
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        View_AddReview.hidden = YES;
                    }
                    completion:NULL];

}
-(IBAction)Btn_Ok:(id)sender
{
    [UIView transitionWithView:View_AddReview
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        View_DisplayReview.hidden = YES;
                    }
                    completion:NULL];
}
-(IBAction)Btn_Submit:(id)sender
{
    if(![txt_addreviw.text isEqualToString:NSLocalizedString(@"Review_Placeholder", @"")])
    {
        if (rating_str.length != 0)
        {
            if([app Check_Connection])
            {
                //                if(rating_str.length==0)
                //                {
                //                    rating_str=@"0.0";
                //                }
                
                [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Loading_text", @"")];
                
                NSString *original_url=[NSString stringWithFormat:@"postreview.php?user_id=%@&profile_id=%@&review_text=%@&ratting=%@",user_id,profile_id,txt_addreviw.text,rating_str];
                
                [self GetData:original_url];
            }
            else
            {
                [app Show_Alert:NSLocalizedString(@"Warning Alert Title", @"") SubTitle:NSLocalizedString(@"Warning Alert SubTitle", @"") CloseTitle:NSLocalizedString(@"Warning Alert closeButtonTitle", @"")];
            }
            [UIView transitionWithView:View_AddReview
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                View_AddReview.hidden = YES;
                            }
                            completion:NULL];
            is_addReview=YES;
        }
        else
        {
              NSString *msg;
             [app Show_Alert:NSLocalizedString(@"Review Rate", @"") SubTitle:msg CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
        }
        
    }
    else
    {
        NSString *msg;
       
        [app Show_Alert:NSLocalizedString(@"Review Alert", @"") SubTitle:msg CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    }

}
- (IBAction)didChangeValue:(HCSStarRatingView *)sender
{
    NSLog(@"Changed rating to %.1f", sender.value);
    
    self.Rating.value = sender.value;
    
    rating_str = [NSString stringWithFormat:@"%f",self.Rating.value];

}
#pragma mark tableview delegate metod
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReviewCell"];
        
    }
    NSDictionary *temp=[review_arr objectAtIndex:indexPath.row];
    UILabel *name=(UILabel *)[cell viewWithTag:101];
    name.text=[temp valueForKey:@"username"];
    
    UILabel *review_text=(UILabel *)[cell viewWithTag:102];
    review_text.text=[temp valueForKey:@"review_text"];
    
    UILabel *ratting=(UILabel *)[cell viewWithTag:103];
    ratting.text=[NSString stringWithFormat:@"%.1f",[[temp valueForKey:@"ratting"] floatValue]];
    
    HCSStarRatingView *rateview=(HCSStarRatingView *)[cell viewWithTag:104];
    rateview.value=[[temp valueForKey:@"ratting"] floatValue];
    
    UIImageView *profile_imgview=(UIImageView *)[cell viewWithTag:105];
    profile_imgview.layer.cornerRadius=profile_imgview.frame.size.height/2;
    profile_imgview.clipsToBounds=YES;
    [profile_imgview startLoaderWithTintColor:LoadingColor];
    
    NSString *url1= [NSString stringWithFormat:@"%@%@",image_Url,[temp objectForKey:@"userimage"]];
    [profile_imgview sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"home_page_cell_img"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [profile_imgview updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         [profile_imgview reveal];
     }];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [review_arr count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *temp=[review_arr objectAtIndex:indexPath.row];
    [UIView transitionWithView:View_AddReview duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        View_DisplayReview.hidden = NO;
                    } completion:NULL];
    name_lbl.text=[temp valueForKey:@"username"];
    txt_displayreview.text=[temp valueForKey:@"review_text"];
    display_ratting.value=[[temp valueForKey:@"ratting"]floatValue];
    
}

//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

@end
