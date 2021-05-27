//
//  About.h
//  Hospital
//
//  Created by Redixbit on 17/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface About : UIViewController
{
    CGFloat cornerRound;
    CGFloat scrollHieght;
}
@property (weak, nonatomic) IBOutlet UIView *versionView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgOne;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctorFinder;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblVersionName;

@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblContactUs;
@property (weak, nonatomic) IBOutlet UILabel *lblFreaktemplate;
@property (weak, nonatomic) IBOutlet UILabel *lblMail;
@property (weak, nonatomic) IBOutlet UILabel *lblWebsite;

@property (weak, nonatomic) IBOutlet UIView *aboutUsView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgThree;
@property (weak, nonatomic) IBOutlet UILabel *lblAboutUs;
@property (weak, nonatomic) IBOutlet UILabel *lblAboutdesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
