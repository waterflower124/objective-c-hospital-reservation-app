//
//  Constants.h
//
//  Created by Naren on 29/01/15.


#ifndef CustomTableView_Constants_h
#define CustomTableView_Constants_h
#define DEFAULTS_KEY_LANGUAGE_CODE @"Language"
#define country @"ar"
#define character 2
#define LoadingColor [UIColor colorWithRed:237.0/255.0 green:112.0/255.0 blue:0.0/255.0 alpha:1.0]

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define IS_DEVICE_RUNNING_IOS_7_AND_ABOVE() ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : ([[UIScreen mainScreen] bounds].size.height == 812 ? 10 : 999)))))

#define releway @"Raleway"
#define relewayBold @"Raleway-Bold"

#define SERVER_URL @"https://medbooking.app/Apicontrollers/"
#define image_Url @"https://medbooking.app/uploads/"

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

#define GameName @"Hospital"

#define GameUrl @"https://itunes.apple.com/in/app/itunes-u/id490217893?mt=8"

#define AddsID @"ca-app-pub-5413446995476072/3153109949"
#define InterstitialID @"ca-app-pub-5413446995476072/6106576348"
#define kShowAds @"NO"
#define strFalse @"False"

#define No_OF_data 8

#endif
