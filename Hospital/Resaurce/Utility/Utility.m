//
//  Utility.m
//  VideoTemplate
//
//  Created by Redixbit on 01/12/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"

//static DGActivityIndicatorView *activityIndicatorView = nil;
static UIView *loadingView = nil;

@implementation Utility

#pragma mark - Theme Change Methods

+ (Utility *)sharedInstance
{
    static dispatch_once_t once;
    static Utility *sharedMyClass;
    dispatch_once(&once, ^ {
        sharedMyClass = [[self alloc] init];
    });
    return sharedMyClass;
}

//Return UIColor from HEX to RGB format
+(UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

//RGB to Hex
+ (NSString *)hexStringFromColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
}


+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelTitle
{
//    if ([UIAlertController class])
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            [alertController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [alertController addAction:cancel];
//        
//        UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
//        [navController presentViewController:alertController animated:YES completion:nil];
//        
//    }
//    else
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil];
//        [alertView show];
//    }
    
    SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
    UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [alert showCustom:navController image:nil color:[UIColor darkGrayColor] title:title subTitle:message closeButtonTitle:cancelTitle duration:0.0];
}
#pragma mark - View Design
+(void) setShadowOfView:(UIView *)view
{
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    view.layer.shadowRadius = 3.0f;
}

+(void)setNavigation:(UIView *)view
{
//    view.layer.shadowColor = [[UIColor blackColor] CGColor];
//    view.layer.shadowOpacity = 0.5f;
//    view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
//    view.layer.shadowRadius = 3.0f;
//    view.backgroundColor = [self getColor:THEME_COLOR];
}

+(void)setTextWithPaddingOfTextField:(UITextField *)textField
{
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,8,textField.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",textField.placeholder] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}
+(void)setTextWithPaddingOfTextField1:(UITextField *)textField
{
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,textField.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",textField.placeholder] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}

+(void)setTextWithPaddingOfTextField:(UITextField *)textField withPadding:(CGFloat)padding
{
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,padding,textField.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",textField.placeholder] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}
// Change Place holder color



+(void)setTextField:(UITextField *)textField cornerRadius:(CGFloat)cornerRadius
{
    textField.layer.cornerRadius = cornerRadius;
    textField.layer.masksToBounds = YES;
}

+(void)setView:(UIView *)view cornerRadius:(CGFloat)cornerRadius
{
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
}

+(void)setButton:(UIButton *)button cornerRadius:(CGFloat)cornerRadius
{
    button.layer.cornerRadius = cornerRadius;
    button.layer.masksToBounds = YES;
}

+(void)setTextWithPaddingOfLabel:(UILabel *)label
{
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.firstLineHeadIndent = 8.0f;
    style.headIndent = 8.0f;
    style.tailIndent = -8.0f;
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:label.text attributes:@{ NSParagraphStyleAttributeName : style}];
    label.attributedText = attrText;
}

+(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



+(void)stopLoading
{
//    [DejalBezelActivityView removeViewAnimated:NO];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // code here
        [loadingView removeFromSuperview];
//    });
}
+(void)stopLoadingForView:(UIView *)view
{
//    [DejalBezelActivityView removeViewAnimated:NO];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        // code here
    
    for (UIView *innerView in view.subviews)
    {
        if ([innerView isKindOfClass:[UIView class]] && innerView.tag == 9999)
        {
            [innerView removeFromSuperview];
        }
    }
//    });
}
+(BOOL)checkInternetConnection
{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus != NotReachable)
    {
        return YES;
    }
    else
    {
        [self internetConnectionNotFound];
        return NO;
    }
}



@end
