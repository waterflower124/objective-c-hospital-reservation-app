//
//  HelthcareDetail.m
//  Hospital
//
//  Created by Redixbit on 13/10/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "HelthcareDetail.h"

@interface HelthcareDetail ()

@end

@implementation HelthcareDetail
@synthesize profile_imgview;

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
    
    NSLog(@"Dictionary : %@",self.dataDictionary);
    
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(iPhoneVersion==4 || iPhoneVersion==5)
    {
        radius_value=4;
    }
    else
    {
        radius_value=6;
    }
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setData
{
    profile_imgview.layer.cornerRadius=radius_value;
    profile_imgview.clipsToBounds=YES;
    [profile_imgview startLoaderWithTintColor:LoadingColor];
    profile_imgview.layer.borderWidth=1;
    profile_imgview.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    
    NSString *Str_image_name = [NSString stringWithFormat:@"%@",[self.dataDictionary objectForKey:@"icon"]];
    Str_image_name = [Str_image_name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *url1= [image_Url stringByAppendingString:Str_image_name];
    [profile_imgview sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"home_page_cell_img"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [profile_imgview updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         [profile_imgview reveal];
     }];
    
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
    paragraphStyles.firstLineHeadIndent = 1.0; //Must for perform
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: [self.dataDictionary objectForKey:@"desc"] attributes: attributes];
    
    self.lbl_planDetail.attributedText = attributedString;

    [self.lbl_planDetail sizeToFit];
    
    self.lbl_contactDetail.text = [self.dataDictionary objectForKey:@"phone_no"];
    [self.lbl_contactDetail sizeToFit];
    
    self.lbl_websiteDetail.text = [self.dataDictionary objectForKey:@"url"];
    [self.lbl_websiteDetail sizeToFit];
    
    [_img_horizontal setFrame:CGRectMake(_img_horizontal.frame.origin.x, self.lbl_planDetail.frame.size.height + self.lbl_planDetail.frame.origin.y + 10, _img_horizontal.frame.size.width, _img_horizontal.frame.size.height)];
    
    [_img_vertical setFrame:CGRectMake(_img_vertical.frame.origin.x, _img_vertical.frame.origin.y, _img_vertical.frame.size.width, self.img_horizontal.frame.size.height + self.img_horizontal.frame.origin.y - _img_vertical.frame.origin.y)];
    
    [_info_view setFrame:CGRectMake(_info_view.frame.origin.x, _info_view.frame.origin.y, _info_view.frame.size.width, self.img_horizontal.frame.size.height + self.img_horizontal.frame.origin.y + 10)];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.info_view.frame.size.height + self.info_view.frame.origin.y + 10);
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

#pragma mark - UIButton Click event
//Back to previous page
-(IBAction)Btn_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//Make call
-(IBAction)Btn_Call:(id)sender
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:[self.dataDictionary valueForKey:@"phone_no"]];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else
    {
        [app Show_Alert:@"Failed" SubTitle:@"Your device does not support calling functionality" CloseTitle:@"OK"];
    }
}

//Redirect to Website
-(IBAction)btn_website:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[self.dataDictionary objectForKey:@"url"]]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.dataDictionary objectForKey:@"url"]]];
    }
    else
    {
        [app Show_Alert:@"Failed" SubTitle:@"Can not open this website" CloseTitle:@"OK"];
    }
}

@end
