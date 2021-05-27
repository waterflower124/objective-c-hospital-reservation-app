//
//  TermsOfUse.h
//  Hospital
//
//  Created by Water Flower on 10/27/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface TermsOfUse : UIViewController {
    IBOutlet UILabel *titleLabel;
    IBOutlet WKWebView *termsWebView;
    
}

@end

NS_ASSUME_NONNULL_END
