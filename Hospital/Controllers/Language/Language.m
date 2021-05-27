//
//  Language.m
//  Hospital
//
//  Created by Water Flower on 9/5/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "Language.h"
#import <objc/runtime.h>

@interface CustomizedBundle : NSBundle
@end

//@implementation CustomizedBundle
//static const char kAssociatedLanguageBundle = 0;
//
//-(NSString*)localizedStringForKey:(NSString *)key
//                            value:(NSString *)value
//                            table:(NSString *)tableName {
//
//    NSBundle* bundle=objc_getAssociatedObject(self, &kAssociatedLanguageBundle);
//
//    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] :
//    [super localizedStringForKey:key value:value table:tableName];
//}
//
//
//@end
//
//@implementation NSBundle (Custom)
//+(void)setLanguage:(NSString*)language {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        object_setClass([NSBundle mainBundle], [CustomizedBundle class]);
//    });
//
//    objc_setAssociatedObject([NSBundle mainBundle], &kAssociatedLanguageBundle, language ?
//                             [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//@end

static const char kBundleKey = 0;

@interface BundleEx : NSBundle

@end

@implementation BundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle *bundle = objc_getAssociatedObject(self, &kBundleKey);
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    }
    else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end


@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BundleEx class]);
    });
    if ([self isCurrentLanguageRTL:language]) {
        if ([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            [[UITableView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
    }else {
        if ([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
            [[UITableView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
            [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:[self isCurrentLanguageRTL:language] forKey:@"AppleTextDirection"];
    [[NSUserDefaults standardUserDefaults] setBool:[self isCurrentLanguageRTL:language] forKey:@"NSForceRightToLeftWritingDirection"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    id value = language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil;
    objc_setAssociatedObject([NSBundle mainBundle], &kBundleKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isCurrentLanguageRTL:(NSString *)code
{
    return ([NSLocale characterDirectionForLanguage:code] == NSLocaleLanguageDirectionRightToLeft);
}
@end

@interface Language ()

@end

@implementation Language

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    enflagImageView.layer.cornerRadius = 15;
    enflagImageView.layer.masksToBounds = YES;
    arflagImageView.layer.cornerRadius = 15;
    arflagImageView.layer.masksToBounds = YES;
    
    // set language
    titleLabel.text = NSLocalizedString(@"language_title", @"");
    entextLabel.text = NSLocalizedString(@"english", @"");
    artextLabel.text = NSLocalizedString(@"arabic", @"");
}

- (IBAction)englishButtonAction:(id)sender {
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    if([language isEqualToString:@"en"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self setLanguage:@"en"];
    }
}

- (IBAction)arabicButtonAction:(id)sender {
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    if([language isEqualToString:@"ar"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self setLanguage:@"ar"];
    }
}

- (void)setLanguage:(NSString *)language {
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:DEFAULTS_KEY_LANGUAGE_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [NSBundle setLanguage:language];
    
//    if([language isEqualToString:@"ar"]) {
//        UIView.appearance.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//        UIImageView.appearance.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//    }
    
    
    ViewController*loginController=[[UIStoryboard storyboardWithName:@"Main10" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"]; //or the homeController
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
    navController.navigationBarHidden=YES;
    [UIApplication sharedApplication].delegate.window.rootViewController=navController;
}

@end
