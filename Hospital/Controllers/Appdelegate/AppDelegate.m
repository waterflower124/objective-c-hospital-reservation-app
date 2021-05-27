//
//  AppDelegate.m
//  Hospital
//
//  Created by Redixbit on 27/07/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "Reachability.h"
#import "SCLAlertView.h"
#import "Utility.h"
#import "Slider.h"
#import "Language.h"
@import Firebase;
@interface AppDelegate ()<FIRMessagingDelegate>
{
    NSString *isFalse;
  
}
@property (nonatomic, strong) NSString *strUUID;
@property (nonatomic, strong) NSString *strDeviceToken;

@end

@implementation AppDelegate
NSString *const kGCMMessageIDKey = @"gcm.message_id";

@synthesize  stringToken;
static NSString * const kClientID = @"";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self CopyandCheckdb];
    [self RegisterForPushNotification:application];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults]setObject:@"ASC" forKey:@"OrderBy"];
        [[NSUserDefaults standardUserDefaults]setObject:@"50" forKey:@"Radius"];
        UIImage *image=[UIImage imageNamed:@"profile1.png"];
        
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"Profile"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

     [GIDSignIn sharedInstance].clientID = kClientID;
    
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    Language *language_vc = [[Language alloc] initWithNibName:nil bundle:nil];
    if ([language isEqualToString:country]) {
        [language_vc setLanguage:@"ar"];
    } else {
        [language_vc setLanguage:@"en"];
    }
    NSString *isSaved =  [[NSUserDefaults standardUserDefaults] stringForKey:@"loginSaved"];
    if (isSaved != nil)
    {
        ViewController*loginController=[[UIStoryboard storyboardWithName:@"Main10" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"]; //or the homeController
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
        navController.navigationBarHidden=YES;
        self.window.rootViewController=navController;
    } else {
        Slider *loginController=[[UIStoryboard storyboardWithName:@"Main10" bundle:nil] instantiateViewControllerWithIdentifier:@"Slider"]; //or the homeController
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
        navController.navigationBarHidden=YES;
        self.window.rootViewController=navController;
        NSLog(@"Is Not Save");
    }
    
//    if(iPhoneVersion==5)
//    {
//        NSString *isSaved =  [[NSUserDefaults standardUserDefaults] stringForKey:@"loginSaved"];
//        NSLog(@"isSaved %@",isSaved);
//        if (isSaved != nil)
//        {
//            ViewController*loginController=[[UIStoryboard storyboardWithName:@"Main5" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"]; //or the homeController
//            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
//            navController.navigationBarHidden=YES;
//            self.window.rootViewController=navController;
//        }
//        else
//        {
//            Slider *loginController=[[UIStoryboard storyboardWithName:@"Main5" bundle:nil] instantiateViewControllerWithIdentifier:@"Slider"]; //or the homeController
//            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
//            navController.navigationBarHidden=YES;
//            self.window.rootViewController=navController;
//            NSLog(@"Is Not Save");
//        }
//
//    }else if(iPhoneVersion==10){
//
//        NSString *isSaved =  [[NSUserDefaults standardUserDefaults] stringForKey:@"loginSaved"];
//        if (isSaved != nil)
//        {
//            ViewController*loginController=[[UIStoryboard storyboardWithName:@"Main10" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"]; //or the homeController
//            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
//            navController.navigationBarHidden=YES;
//            self.window.rootViewController=navController;
//        }
//        else
//        {
//            Slider *loginController=[[UIStoryboard storyboardWithName:@"Main10" bundle:nil] instantiateViewControllerWithIdentifier:@"Slider"]; //or the homeController
//            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
//            navController.navigationBarHidden=YES;
//            self.window.rootViewController=navController;
//            NSLog(@"Is Not Save");
//        }
//
//    }else{
//
//        NSString *isSaved =  [[NSUserDefaults standardUserDefaults] stringForKey:@"loginSaved"];
//        if (isSaved != nil)
//        {
//            ViewController*loginController=[[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"]; //or the homeController
//            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
//            navController.navigationBarHidden=YES;
//            self.window.rootViewController=navController;
//        }
//        else
//        {
//            Slider *loginController=[[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"Slider"]; //or the homeController
//            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
//            navController.navigationBarHidden=YES;
//            self.window.rootViewController=navController;
//            NSLog(@"Is Not Save");
//        }
//    }
    
    [FBSDKSettings setAppID:@"637614423063830"];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [self ShowAlertforAppRefreshStatus];
    
    if (@available(iOS 13, *)) {
        [self.window setOverrideUserInterfaceStyle: UIUserInterfaceStyleLight];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive %@",_InstanceID);
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return handled;
    
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
    NSLog(@"deviceToken1 = %@",deviceToken);
    
    NSLog(@" Registered device for remote notifications: %@",
          [deviceToken.description stringByReplacingOccurrencesOfString:@" " withString:@""]);
    stringToken = [deviceToken.description stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"checkdeviceToken%@",deviceToken.description);
    
    
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"checkstringToken%@",stringToken);
    [[NSUserDefaults standardUserDefaults]setObject:stringToken forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    NSLog(@"instanceId_notification=>%@",[notification object]);
    _InstanceID = [NSString stringWithFormat:@"%@",[notification object]];
    [[NSUserDefaults standardUserDefaults] setObject:_InstanceID forKey:@"Reg_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"viewDidAppear");
    NSString *object =  [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"OneTime"];
    if(object != nil){
        
        NSLog(@"Done");
    }
    else
    {
        [self registerUser];
    }
    [self connectToFcm];
}

- (void)connectToFcm {
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            
            NSLog(@"InstanceID_connectToFcm = %@", _InstanceID);

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"instanceId_tokenRefreshNotification22=>%@",[[FIRInstanceID instanceID] token]);
                    
                });
            });
        }
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center      willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)        (UNNotificationPresentationOptions))completionHandler
{
    NSLog(@"userNotificationCenter: willPresentNotification: withCompletionHandler:");
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey])
    {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    NSLog(@"%@", userInfo);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION" object:nil];
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Change this to your preferred presentation option
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
    UNNotificationPresentationOptions presentationOptions =         UNNotificationPresentationOptionSound      +UNNotificationPresentationOptionAlert;
    completionHandler(presentationOptions);
}

-(void)ShowAlertforAppRefreshStatus{
    
    UIAlertView *alert;
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
    }
}

-(void)RegisterForPushNotification:(UIApplication *)application
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
        
#pragma clang diagnostic pop
    
    }
    else
    {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max)
        {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        else
        {
            // iOS 10 or later
            
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
            
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            // For iOS 10 data message (sent via FCM)
            [FIRMessaging messaging].remoteMessageDelegate = self;
            
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    [FIRApp configure];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert| UIUserNotificationTypeBadge| UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
#else
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#endif
    
}

-(void)CopyandCheckdb
{
    NSArray *dirpath = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *docdir =[dirpath objectAtIndex:0];
    
    self.strdbpath =[docdir stringByAppendingString :@"Hospital_db.sqlite"];
    
    NSLog(@"dbpath =%@",self.strdbpath);
    
    BOOL success;
    
    NSFileManager *fm =[NSFileManager defaultManager];
    
    success =[fm fileExistsAtPath:self.strdbpath];
    
    if (success)
    {
        NSLog(@"Already Present");
        
    }
    else
    {
        NSError *err;
        NSString *resource =[[NSBundle mainBundle]pathForResource:@"Hospital_db" ofType:@"sqlite"];
        
        success =[fm copyItemAtPath:resource toPath:self.strdbpath error:&err];
        
        if (success)
        {
            NSLog(@"Successfully Created");
        }
        else
        {
            NSLog(@"Error = %@",err);
        }
    }
}

#pragma mark - Reachability

- (BOOL)Check_Connection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

#pragma mark Alert Display
-(void)Show_Alert:(NSString *)title SubTitle:(NSString *)sub_title CloseTitle:(NSString *)close_title
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    UIColor *color = [UIColor colorWithRed:13.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
    [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
    [alert showCustom:self image:nil color:color title:title subTitle:sub_title closeButtonTitle:close_title duration:0.0f];
}
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@" Failed to register for remote notifications: %@", error);
}


- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (userInfo[kGCMMessageIDKey])
    {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    NSLog(@"userInfo=>%@", userInfo);
    NSLog(@"Received remote notifcation: %@", userInfo);
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground || application.applicationState==UIApplicationStateActive )
    {
        
        
    }
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

#endif
- (void)applicationReceivedRemoteMessage:( FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"applicationReceivedRemoteMessage : %@", remoteMessage.appData);
}

#pragma mark - POST method
-(void)registerUser
{
    if ([Utility checkInternetConnection])
    {
        //create request
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        //Set Params
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        
        //Create boundary, it can be anything
        NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        NSLog(@"cheCk_ID %@",_InstanceID);
        [parameters setValue:_InstanceID forKey:@"device_id"];
        [parameters setValue:@"iphone" forKey:@"device_type"];
        
        // add params (all params are strings)
        for (NSString *param in parameters)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //Close off the request with the boundary
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the request
        [request setHTTPBody:body];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@tokendata.php",SERVER_URL]]];
        
        _connection1 = [NSURLConnection connectionWithRequest:request delegate:self];
        [_connection1 start];
    }
}
#pragma mark - NSURLConnection Delegate Method

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
        self.receivedData1 = [NSMutableData new];
        [_receivedData1 setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
        [_receivedData1 appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
        NSLog(@"post %@" , error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    if (_receivedData1 != nil)
    {
        NSMutableDictionary *dictData = [NSJSONSerialization JSONObjectWithData:_receivedData1 options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"Response : %@",dictData);
        NSMutableArray *tempArray = [dictData objectForKey:@"Status"];
        isFalse = [[tempArray objectAtIndex:0] valueForKey:@"id"];
        NSLog(@"check26352 %@",isFalse);
        if ([isFalse isEqualToString:@"True"]) {
            NSLog(@"True");
            [[NSUserDefaults standardUserDefaults] setObject:isFalse forKey:@"OneTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else
        {
            NSLog(@"False");
        }
    }
   
    
}

@end
