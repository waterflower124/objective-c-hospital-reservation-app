//
//  AppDelegate.h
//  Hospital
//
//  Created by Redixbit on 04/08/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSString *stringToken;
@property(strong,nonatomic)NSString *strdbpath;
@property (retain, nonatomic) NSURLConnection *connection1;
@property (retain, nonatomic) NSMutableData *receivedData1;
@property (nonatomic,retain) NSString *InstanceID;
- (BOOL)Check_Connection;
-(void)Show_Alert:(NSString *)title SubTitle:(NSString *)sub_title CloseTitle:(NSString *)close_title;

@end

