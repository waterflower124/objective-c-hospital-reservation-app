//
//  About.m
//  Hospital
//
//  Created by Redixbit on 17/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "About.h"
#import "Constants.h"
@interface About ()
{
    NSString *language;
}
@end

@implementation About

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
     language=[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        NSLog(@"CheRtl2");
        _imgBack.image = [_imgBack.image imageFlippedForRightToLeftLayoutDirection];
        
        
    }
    if (iPhoneVersion == 5) {
        cornerRound = 5;
    }
    else
    {
        cornerRound = 15;
    }
    
    _backImgOne.backgroundColor = [UIColor whiteColor];
    _backImgOne.layer.cornerRadius = cornerRound;
    _backImgOne.clipsToBounds = YES;
    
    _backImgTwo.backgroundColor = [UIColor whiteColor];
    _backImgTwo.layer.cornerRadius = cornerRound;
    _backImgTwo.clipsToBounds = YES;
    
    _backImgThree.backgroundColor = [UIColor whiteColor];
    _backImgThree.layer.cornerRadius = cornerRound;
    _backImgThree.clipsToBounds = YES;
    
    _lblDoctorFinder.text =NSLocalizedString(@"LblTitel", @"");
    _lblDesc.text =NSLocalizedString(@"LblDesc", @"");
    _lblVersion.text =NSLocalizedString(@"Version", @"");
    _lblVersionName.text =NSLocalizedString(@"VersionName", @"");
    
    _lblContactUs.text=NSLocalizedString(@"LblContactUs", @"");
    _lblFreaktemplate.text=NSLocalizedString(@"LblFreaktemplate", @"");
    _lblMail.text=NSLocalizedString(@"LblMail", @"");
    _lblWebsite.text=NSLocalizedString(@"LblWeb", @"");
    
    _lblAboutUs.text=NSLocalizedString(@"LblAbout", @"");
    _lblAboutdesc.text=NSLocalizedString(@"LblAboutDesc", @"");
    
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _aboutUsView.frame.origin.y+_aboutUsView.frame.size.height+20)];
//    _lblAboutdesc.numberOfLines = 0;
//    [_lblAboutdesc sizeToFit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)Btn_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
