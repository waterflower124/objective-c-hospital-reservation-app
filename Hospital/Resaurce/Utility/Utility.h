//
//  Utility.h
//  VideoTemplate
//
//  Created by Redixbit on 01/12/16.
//  Copyright (c) 2016 Redixbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "DejalActivityView.h"

#import "Constants.h"

#import "SCLAlertView.h"

@interface Utility : NSObject <UIAlertViewDelegate>

+(Utility *)sharedInstance;

+(UIColor *)getColor:(NSString *)hexColor;

+ (NSString *)hexStringFromColor:(UIColor *)color;

+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message;

+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelTitle;

+(void)setShadowOfView:(UIView *)view;

+(void)setNavigation:(UIView *)view;

+(void)setTextWithPaddingOfTextField:(UITextField *)textField;

+(void)setTextWithPaddingOfTextField1:(UITextField *)textField;


+(void)setTextWithPaddingOfTextField:(UITextField *)textField withPadding:(CGFloat)padding;

+(void)setTextField:(UITextField *)textField cornerRadius:(CGFloat)cornerRadius;

+(void)setView:(UIView *)view cornerRadius:(CGFloat)cornerRadius;

+(void)setButton:(UIButton *)button cornerRadius:(CGFloat)cornerRadius;

+(void)ChangePlaceholderColor:(NSString*)placeholderText textfield:(UITextField *)textfield;
+(void)ChangePlaceholderColor1:(NSString*)placeholderText textfield:(UITextField *)textfield;

+(void)setTextWithPaddingOfLabel:(UILabel *)label;

+(BOOL)NSStringIsValidEmail:(NSString *)checkString;

+(void)startLoadingViewForView:(UIView *)view;

+(void)stopLoadingForView:(UIView *)view;

+(void)stopLoading;

+(BOOL)checkInternetConnection;

+(void)internetConnectionNotFound;

+(void)showSnackbarWithText:(NSString *)title;

+(void)showServerFailed;

+(void)showConnectionTimeoutFailed;

@end
