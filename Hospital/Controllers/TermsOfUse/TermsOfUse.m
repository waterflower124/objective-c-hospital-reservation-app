//
//  TermsOfUse.m
//  Hospital
//
//  Created by Water Flower on 10/27/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import "TermsOfUse.h"

@interface TermsOfUse ()

@end

@implementation TermsOfUse

- (void)viewDidLoad {
    [super viewDidLoad];
    // set language
    titleLabel.text = NSLocalizedString(@"Terms_Title", @"");

    NSString *StringURL;
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    if ([language isEqualToString:country]) {
        StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, @"terms.php?lang=ar"];
    } else {
        StringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL, @"terms.php?lang=en"];
    }
    StringURL = [StringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: StringURL]];

    [request setHTTPMethod:@"GET"];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!error) {
            NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
            dispatch_async(dispatch_get_main_queue(), ^{
                [termsWebView loadHTMLString:[headerString stringByAppendingString:contentOfURL] baseURL:nil];
            });
            
        }
    }];
    [task resume];
}

-(IBAction)Btn_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
