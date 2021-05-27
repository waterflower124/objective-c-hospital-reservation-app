//
//  Language.h
//  Hospital
//
//  Created by Water Flower on 9/5/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Language : UIViewController {
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *enflagImageView;
    IBOutlet UILabel *entextLabel;
    IBOutlet UIImageView *arflagImageView;
    IBOutlet UILabel *artextLabel;
    
}

- (void)setLanguage:(NSString *)language;

@end



NS_ASSUME_NONNULL_END
